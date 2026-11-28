# Auditoría del proyecto INFO-1165

**Fecha** 28 de noviembre de 2026

La [rúbrica registrada en el plan](PLAN.md#rúbrica) se usó como fuente de los criterios de evaluación. El [plan inicial](https://github.com/diegoa18/INFO1165-regresion/blob/207206538a277f210ff28373e6206b19f7b76b55/docs/PLAN.md) pide preparar diapositivas y registra una exposición de 5 a 10 minutos, con selección al azar del expositor el 3 de diciembre a las 9:30 h. No se dispuso de una copia independiente del enunciado oficial de esta evaluación. El cotejo se limita a los requisitos que el grupo documentó.

## Rúbrica y evidencia

| Criterio | Peso | Evidencia | Estado |
|---|---:|---|---|
| Problema | 10 % | La pregunta identifica qué se predice y a qué unidad corresponde. El README y las láminas 1–2 exponen la fuente, la unidad, el filtro y la partición. | Verificado en los materiales. |
| Modelo | 15 % | El README define respuesta, predictores y unidades. La lámina 3 explica el LM y el GAM con los mismos cuatro predictores y da un ejemplo de interpretación. La lámina 8 contiene los coeficientes. | Verificado en los materiales. |
| Análisis de resultados | 25 % | Las láminas 4–7 presentan la comparación en prueba, los suavizados, el diagnóstico y la elección del GAM. Las láminas 9–10 respaldan la comparación estadística y el desglose por zona. Las cifras concuerdan con el script. | Verificado en los materiales y en R. |
| Respuesta a preguntas | 30 % | El banco contiene 18 preguntas resueltas. Las láminas de respaldo cubren coeficientes, escala logarítmica, AIC, prueba F y diferencias geográficas. | Material listo. La comprensión individual se comprueba en el ensayo. |
| Expresión oral | 10 % | El guion y las notas definen los términos y guían la interpretación sin perder la unidad de análisis. | Material listo. La expresión depende de la exposición de cada integrante. |
| Manejo del tiempo | 10 % | Las siete láminas principales suman 7 min 10 s previstos. El respaldo se usa durante las preguntas. | Pauta dentro del rango. El tiempo real está pendiente de cronometrar. |

## Comprobaciones técnicas

- **Datos.** Ejecuté el script en una carpeta con solo el código y el CSV original. Obtuve 20.640 filas de origen, 20.433 completas, 19.448 elegibles y una muestra de 10.000 sin repetidos. Los 8.000 casos de entrenamiento y los 2.000 de prueba tienen identificadores disjuntos. El CSV original, el procesado y ambos archivos de métricas coincidieron por SHA-256 con sus respectivas copias del proyecto.
- **Ajuste y comparación.** Los seis modelos usan las mismas 8.000 filas de entrenamiento. La prueba F parcial añade cinco coeficientes y los AIC comparables usan la respuesta original. Comprobé por separado la retransformación del LM logarítmico y recalculé RMSE y MAE para los seis modelos. La comparación de AIC con el GAM usa los grados de libertad efectivos del ajuste. [Documentación de mgcv](https://cran.r-project.org/web/packages/mgcv/refman/mgcv.html).
- **Resultado.** El GAM obtuvo 66,31 mil USD de RMSE, 48,51 mil USD de MAE y 0,564 de R² de prueba. El LM completo obtuvo 68,27 mil USD de RMSE. La diferencia es de 1,95 mil USD o 2,9 %. El RMSE combinado, reconstruido con los tamaños y los errores cuadráticos de las cuatro zonas, reproduce el resultado global.
- **PowerPoint.** Revisé visualmente las diez láminas y reimporté el archivo exportado. Comprobé que contiene diez notas de expositor, tres tablas y cinco gráficos editables con sus datos incrustados. Las cifras clave de las tablas coinciden con R. Las notas de las siete láminas principales incluyen su tiempo por separado.

La corrida usó R 4.5.1, `mgcv` 1.9-3 y `lmtest` 0.9-40. Para repetirla, sigue [las instrucciones del README](../README.md#ejecución).

## Hallazgos que conviene defender

- **Validez del diagnóstico.** Shapiro–Wilk y Breusch–Pagan apoyan la cautela con los intervalos clásicos del LM. El gráfico QQ muestra dónde cambian las colas y la dispersión por deciles muestra el cambio de varianza. Durbin–Watson necesita un orden interpretable. El mapa es un diagnóstico espacial exploratorio.
- **Predicciones fuera del rango filtrado.** El umbral se aplica a los valores observados. En la corrida auditada hubo 3 predicciones de al menos USD 500.000 en el LM con ingreso, 2 en el LM completo y 13 en el LM log1p. El GAM quedó entre 41,90 y 465,78 mil USD en los casos de prueba. Se evaluaron las predicciones originales de cada modelo sin recortarlas.
- **Alcance de la precisión.** Comparar seis modelos en una sola partición muestra cuál rindió mejor allí. La magnitud de la diferencia GAM–LM puede variar en otra muestra. La vecindad entre grupos y el uso de datos de 1990 limitan las conclusiones sobre regiones nuevas y precios actuales.

Queda pendiente que cada integrante exponga de principio a fin, registre su tiempo y responda preguntas sin leer. Usa el [guion](PRESENTACION.md) y el [banco](PREGUNTAS.md) en ese ensayo.
