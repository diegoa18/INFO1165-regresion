# INFO-1165 · Regresión lineal y modelos aditivos

**¿Qué tan bien podemos predecir el valor mediano de las viviendas de un grupo de bloques censales de California a partir del ingreso del sector, las características de sus viviendas y su cercanía al océano?**

Usamos [California Housing Prices (Kaggle)](https://www.kaggle.com/datasets/camnugent/california-housing-prices), con 20.640 grupos de bloques del censo de 1990. Quitamos 207 filas con datos faltantes y, de las restantes, 985 con un valor mediano de USD 500.000 o más. De las 19.448 elegibles extraemos 10.000 sin reemplazo y usamos 8.000 para entrenar y 2.000 para evaluar. La semilla `1121` reproduce la muestra y la partición originales.

## Variables

| Columna original | Variable en R | Unidad | Uso |
|---|---|---|---|
| `median_house_value` | `Valor_Vivienda` | Miles de USD de 1990 | Respuesta. Valor mediano de las viviendas del grupo de bloques. |
| `median_income` | `Ingreso_Mediano` | Decenas de miles de USD de 1990 | Ingreso mediano de los hogares. |
| `total_rooms`, `households` | `Habitaciones_por_Hogar` | Habitaciones por hogar | Cociente entre el total de habitaciones y la cantidad de hogares del sector. |
| `housing_median_age` | `Edad_Media` | Años | Edad mediana de las viviendas del sector. |
| `ocean_proximity` | `Zona` | Categoría | `INLAND` (referencia), `<1H OCEAN`, `NEAR BAY` y `NEAR OCEAN`. Agrupamos los cuatro casos `ISLAND` de la muestra con `NEAR OCEAN`. |
| `total_rooms` | `Habitaciones_Totales` | Habitaciones | Total del sector. Se usa como predictor en el LM original y para calcular el cociente. |
| `longitude`, `latitude` | `Longitud`, `Latitud` | Grados | Coordenadas para el mapa de residuos. |

El CSV procesado también conserva `Dormitorios_Totales` del análisis inicial y genera un `Bloque_ID` para identificar cada fila de la muestra.

## Ejecución

Instala las dependencias una vez en R. En RStudio, abre `INFO1165-regresion.Rproj` para trabajar desde la raíz del repositorio.

```r
install.packages(c("mgcv", "lmtest"))
```

Desde una terminal en la raíz del repositorio con Rscript disponible:

```sh
Rscript analisis_regresion.R
```

El script lee `housing_raw.csv`, regenera `Datos_Viviendas_Limpios.csv` con separador `;` y ajusta los modelos. Imprime los coeficientes, las pruebas y las métricas. Guarda `metricas.csv` y tres gráficos en `resultados/`.

## Resultado

El GAM obtuvo **66,31 mil USD de RMSE**, **48,51 mil USD de MAE** y **0,564 de R²** en los 2.000 casos de prueba. El LM completo obtuvo 68,27 mil USD de RMSE. La evaluación corresponde a una partición aleatoria de datos censales de 1990 bajo el umbral de valor indicado.

- [Interpretación de los resultados y diagnóstico](docs/ANALISIS.md)
- [Plan](docs/PLAN.md), [progreso](docs/PROGRESO.md) e [historial](docs/HISTORIAL.md)
