# INFO-1165 | Valor mediano de las viviendas en grupos de bloques censales de California

library(mgcv)

# 1. Preparación reproducible desde el archivo original
datos_raw <- read.csv("housing_raw.csv")
datos_sin_na <- na.omit(datos_raw)
elegibles <- subset(datos_sin_na, median_house_value < 500000)

# Conserva el filtro, la muestra y la partición del proyecto original.
set.seed(1121)
muestra <- elegibles[sample(seq_len(nrow(elegibles)), 10000), ]

# Solo hay cuatro bloques ISLAND en la muestra. Se agrupan con NEAR OCEAN.
zona <- muestra$ocean_proximity
zona[zona == "ISLAND"] <- "NEAR OCEAN"

datos <- data.frame(
  Bloque_ID = paste0("Bloque_", seq_len(nrow(muestra))),
  Valor_Vivienda = round(muestra$median_house_value / 1000, 2),
  Edad_Media = muestra$housing_median_age,
  Dormitorios_Totales = muestra$total_bedrooms,
  Habitaciones_Totales = muestra$total_rooms,
  Ingreso_Mediano = muestra$median_income,
  Habitaciones_por_Hogar = muestra$total_rooms / muestra$households,
  Zona = factor(zona, levels = c("INLAND", "<1H OCEAN", "NEAR BAY", "NEAR OCEAN")),
  Longitud = muestra$longitude,
  Latitud = muestra$latitude
)

write.table(datos, "Datos_Viviendas_Limpios.csv", sep = ";",
            row.names = FALSE, quote = FALSE)

set.seed(1121)
indices_entrenamiento <- sample(seq_len(nrow(datos)), floor(0.8 * nrow(datos)))
entrenamiento <- datos[indices_entrenamiento, ]
prueba <- datos[-indices_entrenamiento, ]

cat("\nPreparación de datos\n")
print(c(Raw = nrow(datos_raw), Sin_NA = nrow(datos_sin_na),
        Bajo_500_mil = nrow(elegibles), Entrenamiento = nrow(entrenamiento),
        Prueba = nrow(prueba)))
print(rbind(Entrenamiento = table(entrenamiento$Zona), Prueba = table(prueba$Zona)))

# 2. Ajuste con el 80% de entrenamiento
base <- lm(Valor_Vivienda ~ 1, data = entrenamiento)

# El LM original sirve de referencia para comparar con la especificación anterior.
lineal_original <- lm(Valor_Vivienda ~ Edad_Media + Habitaciones_Totales,
                      data = entrenamiento)

lineal_ingreso <- lm(Valor_Vivienda ~ Ingreso_Mediano, data = entrenamiento)
formula_lineal <- Valor_Vivienda ~ Ingreso_Mediano + Habitaciones_por_Hogar +
  Edad_Media + Zona
lineal <- lm(formula_lineal, data = entrenamiento)

lineal_log <- lm(update(formula_lineal, log1p(Valor_Vivienda) ~ .),
                 data = entrenamiento)

aditivo <- gam(
  Valor_Vivienda ~ s(Ingreso_Mediano, k = 15) +
    s(Habitaciones_por_Hogar, k = 15) + s(Edad_Media, k = 10) + Zona,
  data = entrenamiento, method = "REML"
)

cat("\nPrueba F parcial: LM con ingreso frente al LM completo\n")
print(anova(lineal_ingreso, lineal))

cat("\nCoeficientes del LM completo e intervalos clásicos al 95%\n")
print(cbind(coef(summary(lineal)), confint(lineal)), digits = 5)

cat("\nModelo logarítmico\n")
print(summary(lineal_log))

cat("\nModelo aditivo\n")
print(summary(aditivo))

set.seed(1121)
cat("\nChequeo de dimensión de las bases del GAM (k)\n")
print(k.check(aditivo))

# 3. Comparación en las mismas 2.000 observaciones de prueba
# El ajuste de retransformación estima E[exp(error)] con los residuos de entrenamiento.
# Sin este factor, invertir el log entrega una estimación del centro en escala log.
factor_retransformacion <- mean(exp(residuals(lineal_log)))
predicciones <- list(
  predict(base, newdata = prueba),
  predict(lineal_original, newdata = prueba),
  predict(lineal_ingreso, newdata = prueba),
  predict(lineal, newdata = prueba),
  expm1(predict(lineal_log, newdata = prueba) + log(factor_retransformacion)),
  GAM = predict(aditivo, newdata = prueba)
)

observado <- prueba$Valor_Vivienda
errores <- vapply(predicciones, function(prediccion) observado - prediccion,
                  numeric(nrow(prueba)))

# R² de prueba usa el promedio de los valores observados en el conjunto de prueba.
resultados <- data.frame(
  Modelo = c("Promedio de entrenamiento", "LM original", "LM con ingreso",
             "LM completo", "LM log1p", "GAM"),
  R2_Ajustado_Entrenamiento = c(
    summary(base)$adj.r.squared, summary(lineal_original)$adj.r.squared,
    summary(lineal_ingreso)$adj.r.squared, summary(lineal)$adj.r.squared,
    summary(lineal_log)$adj.r.squared, summary(aditivo)$r.sq
  ),
  Escala_R2_Ajustado = c(rep("Miles de USD", 4), "log1p", "Miles de USD"),
  AIC_Escala_Original = c(AIC(base), AIC(lineal_original), AIC(lineal_ingreso),
                          AIC(lineal), NA_real_, AIC(aditivo)),
  RMSE_Prueba = sqrt(colMeans(errores^2)),
  MAE_Prueba = colMeans(abs(errores)),
  R2_Prueba = 1 - colSums(errores^2) / sum((observado - mean(observado))^2)
)

cat("\nComparación en prueba (RMSE y MAE en miles de USD)\n")
print(resultados, digits = 6, row.names = FALSE, na.print = "—")
cat("\nFactor de retransformación log1p:", factor_retransformacion, "\n")

# 4. Diagnóstico del LM completo y visualización del GAM
residuos_lineal <- residuals(lineal)
set.seed(1121)
cat("\nShapiro-Wilk (submuestra de 5.000 residuos del LM completo)\n")
print(shapiro.test(sample(residuos_lineal, min(5000, length(residuos_lineal)))))
cat("\nBreusch-Pagan (versión studentizada, LM completo)\n")
print(lmtest::bptest(lineal))

# Los casos influyentes se identifican para revisar su efecto, sin borrarlos.
cook <- cooks.distance(lineal)
mas_influyentes <- head(order(cook, decreasing = TRUE), 3)
cat("\nBloques con mayor distancia de Cook en el LM completo\n")
print(data.frame(
  Bloque = entrenamiento$Bloque_ID[mas_influyentes],
  Habitaciones_por_Hogar = entrenamiento$Habitaciones_por_Hogar[mas_influyentes],
  Apalancamiento = unname(hatvalues(lineal)[mas_influyentes]),
  Distancia_Cook = unname(cook[mas_influyentes])
), row.names = FALSE, digits = 4)

carpeta_resultados <- "resultados"
dir.create(carpeta_resultados, showWarnings = FALSE)
write.csv(resultados, file.path(carpeta_resultados, "metricas.csv"), row.names = FALSE)

png(file.path(carpeta_resultados, "diagnostico_lm.png"),
    width = 1200, height = 950, res = 140)
par(mfrow = c(2, 2), mar = c(4.2, 4.2, 3, 1), mgp = c(2.4, 0.8, 0))
plot(lineal, which = c(1, 2, 3, 5), id.n = 0, pch = 16,
     col = adjustcolor("#27516B", 0.25),
     caption = c("Residuos vs. ajustados", "QQ normal", "Escala-localización",
                 "Distancia de Cook", "Residuos vs. leverage", "Cook vs. leverage"))
invisible(dev.off())

# Se muestra el rango entre los percentiles 1 y 99 de cada predictor para que los extremos no oculten la curva.
# El ajuste usa todas las observaciones del entrenamiento.
variables_suaves <- c("Ingreso_Mediano", "Habitaciones_por_Hogar", "Edad_Media")
etiquetas <- c("Ingreso (decenas de miles de USD)", "Habitaciones por hogar",
               "Edad mediana (años)")
perfil <- entrenamiento[1, ]
for (variable in variables_suaves) {
  perfil[[variable]] <- median(entrenamiento[[variable]])
}
perfil$Zona <- factor("INLAND", levels = levels(entrenamiento$Zona))

png(file.path(carpeta_resultados, "curvas_gam.png"),
    width = 1530, height = 540, res = 135)
par(mfrow = c(1, 3), mar = c(4.5, 4.3, 2.4, 0.8), mgp = c(2.4, 0.75, 0))
for (i in seq_along(variables_suaves)) {
  variable <- variables_suaves[i]
  termino <- paste0("s(", variable, ")")
  limites <- quantile(entrenamiento[[variable]], c(0.01, 0.99))
  rejilla <- seq(limites[1], limites[2], length.out = 200)
  perfiles <- perfil[rep(1, length(rejilla)), ]
  perfiles[[variable]] <- rejilla

  efecto <- predict(aditivo, newdata = perfiles, type = "terms",
                    terms = termino, se.fit = TRUE)
  ajuste <- efecto$fit[, 1]
  margen <- qnorm(0.975) * efecto$se.fit[, 1]

  plot(rejilla, ajuste, type = "n", ylim = range(ajuste - margen, ajuste + margen, 0),
       xlab = etiquetas[i], ylab = "Efecto parcial (miles de USD)")
  polygon(c(rejilla, rev(rejilla)), c(ajuste - margen, rev(ajuste + margen)),
          col = "#D7E8ED", border = NA)
  abline(h = 0, col = "gray45", lty = 2)
  lines(rejilla, ajuste, lwd = 2.5, col = "#27516B")

  # Contrastes para interpretar la forma de cada curva con números reproducibles.
  cuantiles <- quantile(entrenamiento[[variable]], c(0.10, 0.25, 0.50, 0.75, 0.90))
  perfiles_cuantiles <- perfil[rep(1, length(cuantiles)), ]
  perfiles_cuantiles[[variable]] <- cuantiles
  efectos_cuantiles <- predict(aditivo, newdata = perfiles_cuantiles, type = "terms",
                               terms = termino)[, 1]
  cat("\nEfecto parcial de", variable, "por percentil de entrenamiento\n")
  print(round(cbind(Predictor = cuantiles, Efecto = efectos_cuantiles), 2))
}
invisible(dev.off())

# El orden aleatorio de los bloques no define rezagos para Durbin-Watson.
# El mapa permite examinar agrupaciones de los errores del GAM en prueba.
residuos_gam_prueba <- observado - predicciones$GAM
cortes <- cut(residuos_gam_prueba, breaks = c(-Inf, -50, 50, Inf),
              labels = c("Sobreestima > 50", "Entre −50 y 50", "Subestima > 50"))
colores_mapa <- c("#24588E", "#9AA9AA", "#AE4230")
png(file.path(carpeta_resultados, "residuos_gam_mapa.png"),
    width = 1100, height = 950, res = 135)
par(mar = c(4.3, 4.3, 3, 1), mgp = c(2.4, 0.8, 0))
plot(prueba$Longitud, prueba$Latitud, type = "n", xlab = "Longitud", ylab = "Latitud",
     asp = 1 / cos(mean(prueba$Latitud) * pi / 180),
     main = "Residuos del GAM en prueba")
for (grupo in c(2, 1, 3)) {
  indices <- cortes == levels(cortes)[grupo]
  points(prueba$Longitud[indices], prueba$Latitud[indices], pch = 16, cex = 0.65,
         col = adjustcolor(colores_mapa[grupo], alpha.f = 0.7))
}
legend("topright", legend = levels(cortes), col = colores_mapa, pch = 16,
       title = "Observado − predicho (miles de USD)", bty = "n")
invisible(dev.off())
