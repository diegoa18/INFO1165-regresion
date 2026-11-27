# INFO-1165 | Valor mediano de las viviendas en grupos de bloques censales de California

library(mgcv)

# 1. Preparación reproducible desde el archivo original
datos_raw <- read.csv("housing_raw.csv")
datos_sin_na <- na.omit(datos_raw)
elegibles <- subset(datos_sin_na, median_house_value < 500000)

# Conserva el filtro, la muestra y la partición del proyecto original.
set.seed(1121)
muestra <- elegibles[sample(seq_len(nrow(elegibles)), 10000), ]

datos <- data.frame(
  Bloque_ID = paste0("Bloque_", seq_len(nrow(muestra))),
  Valor_Vivienda = round(muestra$median_house_value / 1000, 2),
  Edad_Media = muestra$housing_median_age,
  Dormitorios_Totales = muestra$total_bedrooms,
  Habitaciones_Totales = muestra$total_rooms
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

# 2. Ajuste con el 80% de entrenamiento
base <- lm(Valor_Vivienda ~ 1, data = entrenamiento)
lineal_habitaciones <- lm(Valor_Vivienda ~ Habitaciones_Totales, data = entrenamiento)
formula_original <- Valor_Vivienda ~ Edad_Media + Habitaciones_Totales
lineal_original <- lm(formula_original, data = entrenamiento)
lineal_log <- lm(update(formula_original, log1p(Valor_Vivienda) ~ .),
                 data = entrenamiento)
aditivo_original <- gam(
  Valor_Vivienda ~ s(Edad_Media) + s(Dormitorios_Totales) + s(Habitaciones_Totales),
  data = entrenamiento
)

cat("\nPrueba F parcial: habitaciones frente a edad y habitaciones\n")
print(anova(lineal_habitaciones, lineal_original))

# 3. Comparación en las mismas 2.000 observaciones de prueba
# La corrección de retransformación usa solo los residuos de entrenamiento.
factor_retransformacion <- mean(exp(residuals(lineal_log)))
predicciones <- list(
  "Promedio de entrenamiento" = predict(base, newdata = prueba),
  "LM con habitaciones" = predict(lineal_habitaciones, newdata = prueba),
  "LM original" = predict(lineal_original, newdata = prueba),
  "LM log1p" = expm1(predict(lineal_log, newdata = prueba) + log(factor_retransformacion)),
  "GAM original" = predict(aditivo_original, newdata = prueba)
)

observado <- prueba$Valor_Vivienda
errores <- vapply(predicciones, function(prediccion) observado - prediccion,
                  numeric(nrow(prueba)))

# El AIC se compara únicamente entre modelos con la misma escala de respuesta.
resultados <- data.frame(
  Modelo = names(predicciones),
  R2_Ajustado_Entrenamiento = c(
    summary(base)$adj.r.squared, summary(lineal_habitaciones)$adj.r.squared,
    summary(lineal_original)$adj.r.squared, summary(lineal_log)$adj.r.squared,
    summary(aditivo_original)$r.sq
  ),
  Escala_R2_Ajustado = c(rep("Miles de USD", 3), "log1p", "Miles de USD"),
  AIC_Escala_Original = c(AIC(base), AIC(lineal_habitaciones), AIC(lineal_original),
                          NA_real_, AIC(aditivo_original)),
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
