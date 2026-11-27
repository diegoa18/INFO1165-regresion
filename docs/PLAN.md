# Plan de trabajo

## Objetivo

**Predecir el valor mediano de las viviendas de un grupo de bloques censales de California (censo de 1990) a partir de sus características**, con los modelos de la unidad (regresión lineal y GAM), y presentarlo en 5 a 10 minutos.

- **Fuente:** Kaggle — *California Housing Prices* (`camnugent/california-housing-prices`), 20.640 grupos de bloques.
- **Limpieza:** se excluyen filas con faltantes y valores de USD 500.000 o más. Conservamos la muestra original de 10.000 grupos y la partición 80/20 de entrenamiento y prueba.
- **Entrega:** presentación oral, 3 de diciembre de 2026, 9:30 h. Un integrante elegido al azar presenta y responde preguntas.

## Rúbrica

| Criterio | Peso | Qué pide para el 3 |
|---|---|---|
| Problema | 10 % | Problema claro y fuente de datos explícita |
| Modelo | 15 % | Modelo y variables presentados con claridad |
| Análisis de resultados | 25 % | Análisis claro, con conceptos bien aplicados |
| Respuesta a preguntas | 30 % | Comprensión profunda ante las preguntas del docente |
| Expresión oral | 10 % | Lenguaje técnico adecuado |
| Manejo del tiempo | 10 % | Entre 5 y 10 minutos |

Un 0 en un criterio arrastra a 0 al siguiente (Problema → Modelo → Análisis → Preguntas).

## Hallazgos de la revisión (2026-11-25)

1. **Poder predictivo casi nulo.** Con las variables actuales (edad, dormitorios y habitaciones totales), el mejor modelo (GAM `modelo8`) tiene R² ajustado 0.128 y RMSE de test 94.0; el LM llega a 99.2, frente a 100.4 de predecir siempre el promedio.
2. **Variables mal elegidas.** `total_rooms` y `total_bedrooms` son totales del bloque: miden su tamaño, no el de cada vivienda. Quedó fuera `median_income` (correlación 0.65 con el valor). Un LM con ingreso, habitaciones por hogar, edad y `ocean_proximity` llega a R² ≈ 0.57.
3. **`anova()` entre modelos no anidados** (filas con `Df = 0`). El test F solo aplica a modelos anidados; para los demás se compara con AIC.
4. **RMSE en escalas distintas.** El RMSE log (0.54) no es comparable con el de escala original (99.2); hace falta `expm1()` antes de comparar.
5. **Shapiro-Wilk con n = 5000** rechaza normalidad casi siempre; la interpretación debe apoyarse en el QQ-plot.
6. **Sección 1 (optimización con datos simulados)** no tiene relación con el problema; ocupa tiempo de la presentación.
7. **Faltan conclusiones e interpretación** de coeficientes y diagnósticos.

## Decisiones

| ID | Decisión | Estado |
|---|---|---|
| D1 | Incorporar ingreso mediano, habitaciones por hogar, edad mediana y zona. Conservar el LM original como referencia. Agrupar los cuatro casos de islas con la categoría cercana al océano. | Planificada |
| D2 | Retirar la simulación de optimización y dedicar el análisis y la exposición a los datos de vivienda. | Aplicada el 2026-11-27 |
| D3 | Conservar el filtro y la partición originales. Aplicar el log solo a la respuesta y volver a miles de USD con un factor estimado en entrenamiento. | Aplicada el 2026-11-27 |
| D4 | Usar un mapa exploratorio de residuos en prueba. Durbin–Watson requiere un orden con sentido para la autocorrelación de primer orden. | Planificada |

## Tareas

Cada tarea termina cuando se cumple su criterio de completado. El estado vive en `PROGRESO.md`.

### Fase 1 — Problema y datos

- **T1.1** Escribir el problema en una frase en el README. *Completado:* el README abre con la pregunta, la fuente y la limpieza.
- **T1.2** Describir cada variable usada (nombre original, nombre en el script, unidad, qué mide). *Completado:* tabla en el README con todas las variables de los modelos finales.

### Fase 2 — Modelo

- **T2.1** Aplicar D1 en `analisis_regresion.R`. *Completado:* el script corre de principio a fin y el historial registra las métricas nuevas.
- **T2.2** Corregir las comparaciones `anova()` para comparar solo modelos lineales anidados. Usar AIC para los demás modelos ajustados sobre la misma escala y observaciones. *Completado:* ningún `anova()` del script devuelve filas con `Df = 0`.
- **T2.3** Calcular el RMSE de test de todos los modelos en escala original (`expm1()` para los log). *Completado:* una sola tabla final compara todos los modelos en miles de USD.
- **T2.4** Aplicar D2. *Completado:* la sección queda como se decidió.

### Fase 3 — Análisis

- **T3.1** Interpretar los coeficientes del modelo lineal final (signo, magnitud, significancia, intervalo de confianza). *Completado:* una frase por coeficiente en `docs/ANALISIS.md`.
- **T3.2** Interpretar los gráficos y las pruebas de Shapiro–Wilk y Breusch–Pagan. Explicar cuándo aplica Durbin–Watson y revisar el mapa exploratorio de residuos. *Completado:* cada test aplicable tiene H₀, resultado e implicación y se documenta el alcance del mapa.
- **T3.3** Interpretar el GAM final (curvas `s()`, edf, comparación por AIC con el LM). *Completado:* se explica qué relación no lineal capta cada término suavizado.
- **T3.4** Conclusiones: modelo elegido, error esperado, limitaciones. *Completado:* sección de conclusiones en `docs/ANALISIS.md`.

### Fase 4 — Presentación

- **T4.1** Preparar la exposición oral con una secuencia de problema, datos, modelos, resultados y conclusiones. *Completado:* pauta escrita con tiempos y cifras verificadas en `docs/PREGUNTAS.md`.
- **T4.2** Banco de preguntas probables con respuesta (por qué ese R², por qué log, qué es un GAM, qué dicen los residuos, por qué esas variables, qué es AIC). *Completado:* `docs/PREGUNTAS.md` con al menos 10 preguntas respondidas.
- **T4.3** Ensayo cronometrado: cada integrante presenta una vez. *Completado:* todos dentro de 5 a 10 minutos.
