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
