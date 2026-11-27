# INFO-1165 · Regresión lineal y modelos aditivos

**¿Qué tan bien podemos predecir el valor mediano de las viviendas de un grupo de bloques censales de California a partir de las características registradas en el censo?**

Usamos [California Housing Prices (Kaggle)](https://www.kaggle.com/datasets/camnugent/california-housing-prices), con 20.640 grupos de bloques del censo de 1990. Quitamos 207 filas con datos faltantes y, de las restantes, 985 con un valor mediano de USD 500.000 o más. De las 19.448 elegibles extraemos 10.000 sin reemplazo y usamos 8.000 para entrenar y 2.000 para evaluar. La semilla `1121` reproduce la muestra y la partición originales.


* **Archivos:**
  * `housing_raw.csv`: Dataset original descargado de Kaggle.
  * `Datos_Viviendas_Limpios.csv`: Base procesada lista para el análisis.
  * `analisis_regresion.R`: Script completo (optimización, regresión lineal, transformación `log1p`, diagnóstico de residuos y GAM).


#### antes de ejecutar por primera vez, preocuren de instalar los siguientes paquetes:
```r
install.packages(c("gclus", "lmtest", "car", "mgcv"))
```

#### Organización del trabajo
* `docs/PLAN.md`: objetivo, rúbrica, hallazgos y tareas.
* `docs/PROGRESO.md`: estado de cada tarea y próximo paso.
* `docs/HISTORIAL.md`: bitácora, una entrada por commit.
* `AGENTS.md`: instrucciones para quien trabaje con IA (Claude, Codex, Cursor, Copilot, etc.).
