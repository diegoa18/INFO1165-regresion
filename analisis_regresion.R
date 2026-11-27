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

carpeta_resultados <- "resultados"
dir.create(carpeta_resultados, showWarnings = FALSE)
write.csv(resultados, file.path(carpeta_resultados, "metricas.csv"), row.names = FALSE)
