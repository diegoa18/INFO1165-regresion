# INFO-1165 · Regresión lineal y modelos aditivos

**¿Qué tan bien podemos predecir el valor mediano de las viviendas de un grupo de bloques censales de California a partir de las características registradas en el censo?**

Usamos [California Housing Prices (Kaggle)](https://www.kaggle.com/datasets/camnugent/california-housing-prices), con 20.640 grupos de bloques del censo de 1990. Quitamos 207 filas con datos faltantes y, de las restantes, 985 con un valor mediano de USD 500.000 o más. De las 19.448 elegibles extraemos 10.000 sin reemplazo y usamos 8.000 para entrenar y 2.000 para evaluar. La semilla `1121` reproduce la muestra y la partición originales.


## Ejecución

Instala las dependencias una vez en R. En RStudio, abre `INFO1165-regresion.Rproj` para trabajar desde la raíz del repositorio.

```r
install.packages("mgcv")
```

Desde una terminal en la raíz del repositorio con Rscript disponible:

```sh
Rscript analisis_regresion.R
```

El script lee `housing_raw.csv`, regenera `Datos_Viviendas_Limpios.csv` con separador `;` y ajusta los modelos. Imprime la prueba F parcial y guarda las métricas de prueba en `resultados/metricas.csv`.
