# INFO-1165 — Modelos de Regresión Lineal y GAM
* **Fuente de datos:** Kaggle — *California Housing Prices* (`camnugent/california-housing-prices`), muestra limpia de 10,000 registros (80% entrenamiento / 20% prueba).
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
