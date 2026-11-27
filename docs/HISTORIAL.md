# Historial

Bitácora del proyecto, la entrada más reciente arriba. Cada commit agrega una entrada con este formato:

```
## AAAA-MM-DD — <título corto>
- **Autor:** <nombre> (+ IA usada, si aplica)
- **Tareas:** <IDs de PLAN.md>
- **Cambios:** <qué se hizo, en 1 a 3 viñetas>
- **Métricas:** <R² / AIC / RMSE que cambiaron, o "sin cambios">
```

---

## 2026-11-27 — Diagnóstico y lectura de resultados
- **Autor:** Frante23 (+ Codex)
- **Tareas:** T3.1–T3.4
- **Cambios:**
  - Se añaden Shapiro–Wilk, Breusch–Pagan, distancia de Cook y gráficos de residuos al LM completo. Se documenta la cautela al interpretar sus intervalos clásicos.
  - Se grafican los efectos parciales del GAM y se añaden los contrastes por percentil y un mapa exploratorio de errores de prueba. El orden aleatorio del muestreo no define rezagos interpretables para Durbin–Watson.
  - Se interpretan los coeficientes, AIC, suavizados y alcance de la evaluación en ANALISIS.md.
- **Métricas:** sin cambios en R², AIC ni RMSE. Shapiro–Wilk W = 0,9327 y Breusch–Pagan BP = 270,76, ambos con p < 0,001.

## 2026-11-27 — Predictores censales y modelos ajustados
- **Autor:** Frante23 (+ Codex)
- **Tareas:** T1.2, T2.1
- **Cambios:**
  - Se amplía el CSV con ingreso, habitaciones por hogar, zona y coordenadas. Se conservan las primeras cinco columnas, los 10.000 casos originales y la partición con semilla 1121.
  - Se agrupan las cuatro observaciones de islas con NEAR OCEAN y se usa INLAND como referencia. El LM original se mantiene como referencia histórica.
  - Se ajustan el LM de ingreso, el LM completo, su alternativa logarítmica y un GAM con tres suavizados estimados por REML.
- **Métricas:** LM con ingreso R² ajustado 0,406, AIC 91.601,2, RMSE 77,66. LM completo R² ajustado 0,558, AIC 89.253,1, RMSE 68,27. LM log1p R² ajustado 0,604 en log y RMSE 74,03. GAM R² ajustado 0,584, AIC 88.780,9, RMSE 66,31. Los RMSE están en miles de USD de prueba.

## 2026-11-27 — Evaluación comparable de los modelos de referencia
- **Autor:** Frante23 (+ Codex)
- **Tareas:** T2.2–T2.4
- **Cambios:**
  - Se retiran la simulación de optimización y los contrastes F que agrupaban modelos no anidados. La comparación F parcial añade edad al LM de habitaciones.
  - Se conserva el muestreo original. Se ajusta log1p solo sobre la respuesta y se usa un factor de retransformación calculado con residuos de entrenamiento.
  - Se unifican RMSE, MAE y R² en prueba, y se informa AIC para los modelos ajustados sobre la misma escala de respuesta.
- **Métricas:** LM original R² ajustado 0,036, AIC 95.478,9, RMSE 99,25. GAM original R² ajustado 0,128, AIC 94.700,7, RMSE 93,95. LM log1p R² ajustado 0,036 sobre escala log y RMSE 99,34 en prueba. Los RMSE están en miles de USD.

## 2026-11-27 — Objetivo y alcance de la exposición oral
- **Autor:** Frante23 (+ Codex)
- **Tareas:** T1.1, T4.1
- **Cambios:**
  - El README identifica qué se predice, la unidad de análisis, la fuente, los filtros y los tamaños de entrenamiento y prueba.
  - La fase de presentación se organiza como una pauta oral cronometrada. El proyecto mantiene el objetivo de explicar el análisis en 5 a 10 minutos.
- **Métricas:** sin cambios.

## 2026-11-25 — Base de trabajo y revisión contra la rúbrica
- **Autor:** Vicente Matus (+ Claude)
- **Tareas:** —
- **Cambios:**
  - Se crean `AGENTS.md`, `CLAUDE.md`, `docs/PLAN.md`, `docs/PROGRESO.md` y `docs/HISTORIAL.md`.
  - Revisión del proyecto contra la rúbrica; hallazgos y tareas registrados en `docs/PLAN.md`.
- **Métricas:** sin cambios (línea base registrada en `docs/PROGRESO.md`).

## 2026-11-25 — Versión inicial del proyecto
- **Autor:** diegoa18
- **Tareas:** —
- **Cambios:**
  - `cbb03db` Script único `analisis_regresion.R` y dataset limpio (N = 10,000).
  - `dbbb3ac` Dataset raw original de Kaggle y lectura local.
  - `e5f7fff`, `319616e` README.
- **Métricas:** LM R² ajustado 0.036, RMSE test 99.2; GAM `modelo8` R² ajustado 0.128, RMSE test 94.0.
