### =========================================================================
### INFO-1165 | Regresión Lineal Múltiple y Modelos Aditivos Generalizados
### Réplica metodológica de Tema_IV.R con partición 80/20 (N = 10,000)
### =========================================================================

archivo_raw <- "housing_raw.csv"
archivo_csv <- "Datos_Viviendas_Limpios.csv"

if (!file.exists(archivo_csv)) {
  set.seed(1121)
  raw_housing <- read.csv(archivo_raw)

  # Limpieza: eliminar NAs y el tope artificial censal (500,001 USD)
  housing_clean <- na.omit(raw_housing)
  housing_clean <- subset(housing_clean, median_house_value < 500000)

  # Muestra aleatoria de 10,000 observaciones
  indices_10k <- sample(1:nrow(housing_clean), size = 10000, replace = FALSE)
  housing_10k <- housing_clean[indices_10k, ]

  datos_exportar <- data.frame(
    Bloque_ID = paste0("Bloque_", 1:10000),
    Valor_Vivienda = round(housing_10k$median_house_value / 1000, 2),
    Edad_Media = housing_10k$housing_median_age,
    Dormitorios_Totales = housing_10k$total_bedrooms,
    Habitaciones_Totales = housing_10k$total_rooms
  )

  write.table(datos_exportar, file = archivo_csv, sep = ";",
              row.names = FALSE, quote = FALSE)
}

### 1. Optimización Numérica vs. Regresión Lineal
set.seed(1121)
n <- 10
x <- runif(n, 0, 10)
y <- x + rnorm(n, 0, 2) # error normal mu=0, sigma=2
plot(x, y, main = "Optimización Numérica vs. LM")

datos_sim <- data.frame(x = x, y = y)

fx <- function(data, par) {
  with(data, sum((par[2] * x + par[1] - y)^2))
}

gradZ <- function(par, data) {
  with(data, c(
    sum(2 * (par[2] * x + par[1] - y)),
    sum(2 * x * (par[2] * x + par[1] - y))
  ))
}

result <- optim(c(1, 0), fx, gradZ, data = datos_sim)
result$par
abline(a = result$par[1], b = result$par[2], col = "red")

model <- lm(y ~ x, data = datos_sim)
summary(model)
abline(a = model$coefficients[1], b = model$coefficients[2], col = "blue") # Modelo estimado
abline(a = 0, b = 1, col = "darkgreen")                                    # Modelo real
abline(a = 0, b = model$coefficients[2], col = "orange")
round(confint(model, level = 0.95), 3)

### 2. Carga de datos y Partición 80% Entrenamiento / 20% Prueba
datos_completos <- read.table(archivo_csv, sep = ";", header = TRUE)

set.seed(1121)
n_total <- nrow(datos_completos)
idx_train <- sample(1:n_total, size = floor(0.80 * n_total), replace = FALSE)

datos      <- datos_completos[idx_train, ]   # 80% Entrenamiento (8,000)
datos_test <- datos_completos[-idx_train, ]  # 20% Prueba (2,000)

library(gclus)

### 3. Correlaciones y Modelos Lineales (Escala Original)
datosPred     <- datos[, 2:5]
datosTestPred <- datos_test[, 2:5]

dta.r   <- abs(cor(datosPred))
dta.col <- dmat.color(dta.r)
dta.o   <- order.single(dta.r)
cpairs(datosPred, dta.o, panel.colors = dta.col,
       gap = 0.5, main = "Correlaciones (Escala Original)")
cor(datosPred)

# Dormitorios_Totales y Habitaciones_Totales tienen alta correlación (~0.936)
modelo1 <- lm(Valor_Vivienda ~ Edad_Media + Habitaciones_Totales, data = datosPred)
summary(modelo1)
round(confint(modelo1, level = 0.95), 3)

modelo2 <- lm(Valor_Vivienda ~ Edad_Media + Dormitorios_Totales, data = datosPred)
summary(modelo2)
round(confint(modelo2, level = 0.95), 3)

modelo3 <- lm(Valor_Vivienda ~ Dormitorios_Totales, data = datosPred)
summary(modelo3)
round(confint(modelo3, level = 0.95), 3)

modelo4 <- lm(Valor_Vivienda ~ Habitaciones_Totales, data = datosPred)
summary(modelo4)
round(confint(modelo4, level = 0.95), 3)

anova(modelo1, modelo2, modelo3, modelo4)
AIC(modelo1, modelo2, modelo3, modelo4)
anova(modelo1, modelo4)
AIC(modelo1, modelo4)

# Validación en test (20%) - Escala original
pred_m1 <- predict(modelo1, newdata = datosTestPred)
rmse_m1 <- sqrt(mean((datosTestPred$Valor_Vivienda - pred_m1)^2))
cat("\nRMSE Test (modelo1 escala original):", rmse_m1, "\n")

### 4. Transformación Logarítmica log1p()
datosPred    <- log1p(datos[, 2:5])      # log(x+1) entrenamiento
datosTestLog <- log1p(datos_test[, 2:5]) # log(x+1) prueba

dta.r   <- abs(cor(datosPred))
dta.col <- dmat.color(dta.r)
dta.o   <- order.single(dta.r)
cpairs(datosPred, dta.o, panel.colors = dta.col,
       gap = 0.5, main = "Correlaciones (Escala Logarítmica)")
cor(datosPred)

modelo1 <- lm(Valor_Vivienda ~ Edad_Media, data = datosPred)
summary(modelo1)
round(confint(modelo1, level = 0.95), 3)

modelo2 <- lm(Valor_Vivienda ~ Dormitorios_Totales, data = datosPred)
summary(modelo2)
round(confint(modelo2, level = 0.95), 3)

modelo3 <- lm(Valor_Vivienda ~ Habitaciones_Totales, data = datosPred)
summary(modelo3)
round(confint(modelo3, level = 0.95), 3)

modelo4 <- lm(Valor_Vivienda ~ Edad_Media + Habitaciones_Totales, data = datosPred)
summary(modelo4)
round(confint(modelo4, level = 0.95), 3)

modelo5 <- lm(Valor_Vivienda ~ Edad_Media + Dormitorios_Totales, data = datosPred)
summary(modelo5)

anova(modelo1, modelo2, modelo3, modelo4, modelo5)
AIC(modelo1, modelo2, modelo3, modelo4, modelo5)
anova(modelo3, modelo4)
AIC(modelo3, modelo4)

# Validación en test (20%) - Escala logarítmica
pred_log_m4 <- predict(modelo4, newdata = datosTestLog)
rmse_log_m4 <- sqrt(mean((datosTestLog$Valor_Vivienda - pred_log_m4)^2))
cat("\nRMSE Test (modelo4 log1p):", rmse_log_m4, "\n")

### 5. Diagnóstico de Residuos (modelo4 log1p)
par(mfrow = c(2, 2))
plot(modelo4)
par(mfrow = c(1, 1))

plot(density(modelo4$residuals), main = "Densidad de los Residuos (modelo4)")

# H0: Residuos normales (muestra de 5,000 por límite de shapiro.test en R)
set.seed(1121)
shapiro.test(sample(modelo4$residuals, 5000))

# H0: Residuos homocedásticos
library(lmtest)
library(car)
bptest(modelo4)

# H0: No hay autocorrelación
dwtest(modelo4)

### 6. Modelos Aditivos Generalizados (GAM)
library(mgcv)

modelo3_orig <- lm(Valor_Vivienda ~ Habitaciones_Totales, data = datos)

modelo8 <- gam(Valor_Vivienda ~ s(Edad_Media) + s(Dormitorios_Totales) + s(Habitaciones_Totales),
               data = datos)
summary(modelo8)
plot(modelo8, pages = 1)

modelo9 <- gam(Valor_Vivienda ~ Dormitorios_Totales + s(Habitaciones_Totales),
               data = datos)
summary(modelo9)
plot(modelo9, pages = 1)

modelo10 <- gam(Valor_Vivienda ~ s(Habitaciones_Totales),
                data = datos)
summary(modelo10)
plot(modelo10, pages = 1)

summary(modelo3_orig)
AIC(modelo10, modelo3_orig)

modelo11 <- gam(Valor_Vivienda ~ s(Habitaciones_Totales, Dormitorios_Totales),
                data = datos)
summary(modelo11)
plot(modelo11, pages = 1)

AIC(modelo10, modelo11, modelo3_orig)
anova(modelo3_orig, modelo10, modelo11, test = "F")

### 7. Evaluación Final en el 20% de Prueba (Test Set)
pred_test_lm    <- predict(modelo3_orig, newdata = datos_test)
pred_test_gam8  <- predict(modelo8, newdata = datos_test)
pred_test_gam10 <- predict(modelo10, newdata = datos_test)
pred_test_gam11 <- predict(modelo11, newdata = datos_test)

resultados_test <- data.frame(
  Modelo = c(
    "LM Simple (modelo3_orig)",
    "GAM Univariado (modelo10)",
    "GAM Bivariado (modelo11)",
    "GAM Completo (modelo8)"
  ),
  RMSE_Test = round(c(
    sqrt(mean((datos_test$Valor_Vivienda - pred_test_lm)^2)),
    sqrt(mean((datos_test$Valor_Vivienda - pred_test_gam10)^2)),
    sqrt(mean((datos_test$Valor_Vivienda - pred_test_gam11)^2)),
    sqrt(mean((datos_test$Valor_Vivienda - pred_test_gam8)^2))
  ), 3)
)

print(resultados_test)
