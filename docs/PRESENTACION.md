# Guion de exposición

El [PowerPoint de INFO-1165](INFO1165-California.pptx) tiene siete láminas principales y tres de respaldo. El tiempo de 7 min 10 s es la meta del ensayo de las primeras siete.

## 1. Pregunta y unidad de análisis (0:30)

Queremos saber qué tan bien se puede predecir el valor mediano de las viviendas de un grupo de bloques censales de California. Usamos características que se registraron en el censo, como el ingreso mediano y la proximidad al océano. Cada fila resume un grupo de bloques y el precio se expresa en miles de dólares estadounidenses de 1990. Vamos a comparar un modelo lineal y un modelo aditivo con la misma muestra de prueba.

## 2. Procedencia, limpieza y partición (1:00)

California Housing Prices, en Kaggle, reúne datos del censo estadounidense de 1990. De 20.640 grupos quitamos 207 filas con faltantes. Entre las demás se excluyeron 985 cuyo valor mediano era de 500.000 dólares o más, lo que incluye el tope de 500.001. De las 19.448 filas elegibles se tomó una muestra aleatoria de 10.000 sin reemplazo. Con semilla 1121 se reproduce este proceso y la partición de 8.000 grupos para ajustar y 2.000 para evaluar. Por eso los resultados se refieren a la población filtrada y no incluyen los valores del tramo censurado.

## 3. Modelos y predictores (1:10)

El lineal completo usa ingreso mediano, medido en unidades de diez mil dólares, habitaciones por hogar, edad mediana en años y una zona de proximidad al océano. El cociente de habitaciones por hogar permite comparar sectores de distinto tamaño. Usamos el interior como referencia y agrupamos cuatro observaciones de islas con la categoría cercana al océano.

En el lineal cada predictor numérico tiene una pendiente fija. Por ejemplo, con edad, habitaciones y zona iguales, 10.000 dólares adicionales de ingreso se asocian con 36.244 dólares más de valor mediano predicho. El GAM reemplaza las tres pendientes por curvas estimadas con penalización y conserva las diferencias de nivel por zona. Ambos modelos estiman asociaciones con los otros predictores fijos.

## 4. Resultados fuera del ajuste (1:15)

Comparamos seis alternativas sobre las mismas 2.000 observaciones. RMSE y MAE están en miles de dólares. El RMSE da más peso a los errores grandes. El R² de prueba usa como referencia la variación respecto de la media observada de prueba. En cambio, el promedio de la primera fila se calculó únicamente con entrenamiento.

El lineal original obtuvo 99,25 de RMSE. Solo el ingreso llegó a 77,66 y el lineal completo a 68,27. El GAM llegó a 66,31 y tuvo también el menor MAE, de 48,51. El log vuelve a la misma escala con una corrección estimada en entrenamiento. Su RMSE de 74,03 quedó por encima del lineal completo.

El R² de prueba de 0,564 indica una reducción de aproximadamente 56,4 % en la suma de errores cuadrados frente a usar la media observada de prueba.

## 5. Efectos parciales (1:15)

Cada curva muestra la contribución del predictor al valor estimado, en miles de dólares, con el resto fijo. La contribución está centrada alrededor de cero, y se suma a las otras para obtener la predicción. Los ejes verticales usan rangos distintos.

El ingreso muestra la mayor variación en su rango central. Habitaciones por hogar baja hasta unas seis y luego repunta. Eso explica por qué una sola pendiente lineal puede quedar cerca de cero. En edad el efecto aumenta hacia el extremo alto y se aplana entre unos 28 y 37 años. Los grados de libertad efectivos, 10,09, 9,48 y 6,84, describen la flexibilidad estimada de cada ajuste. Una recta correspondería aproximadamente a uno.

Las curvas se dibujan entre los percentiles 1 y 99, pero se ajustaron con las 8.000 observaciones.

## 6. Diagnóstico del lineal (1:10)

El gráfico QQ compara los cuantiles de los residuos estandarizados con los de una normal. El extremo superior se separa de la referencia. Shapiro–Wilk, con 5.000 residuos, también señala desviaciones. El otro gráfico resume la desviación estándar del residuo por decil del valor ajustado. La dispersión cambia, algo coherente con Breusch–Pagan.

Los dos contrastes dieron p menor que 0,001. Esto pide cautela al interpretar los intervalos clásicos. Hallamos observaciones de alto apalancamiento y usamos distancia de Cook para identificarlas. Conservamos esas filas. Durbin–Watson requiere un orden con sentido para hablar de rezagos. La ubicación se revisó mediante un mapa de errores del GAM en prueba.

## 7. Elección y alcance (0:50)

El GAM dio el menor error observado, con 66,31 mil dólares de RMSE. La diferencia frente al lineal completo fue de unos 1.955 dólares, un 2,9 %. La reducción mayor vino de incorporar el ingreso y las otras características. Entre los ajustes en la misma escala, el GAM obtuvo también el AIC más bajo.

La comparación corresponde a una sola partición aleatoria de datos de 1990. Puede haber grupos vecinos a ambos lados de la partición. El resultado describe predicción dentro de la muestra filtrada y permite hablar de asociaciones. Quedan sin medir la precisión en regiones completas que no participaron en el ajuste, el desempeño con precios actuales y la estabilidad de la ventaja entre modelos.

## Láminas de respaldo

- **8. Coeficientes del LM.** Interpretar los efectos a igual valor de las demás variables y explicar la categoría de referencia.
- **9. Contrastes y transformación.** Distinguir entre la prueba F parcial, el AIC de entrenamiento y el RMSE de prueba.
- **10. Error del GAM por zona.** Revisar qué diferencias aparecen en la muestra y por qué no equivalen a una validación geográfica.

Las cifras se pueden comprobar en [el análisis](ANALISIS.md) y las respuestas de práctica están en el [banco de preguntas](PREGUNTAS.md).
