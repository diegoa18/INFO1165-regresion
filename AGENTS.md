# AGENTS.md — INFO-1165 Regresión

Proyecto universitario (UCT, Estadística Computacional): modelo de regresión en R sobre *California Housing Prices* (Kaggle), presentado oralmente el **3 de diciembre de 2026, 9:30 h** (5 a 10 min, expositor elegido al azar). La nota es la presentación: cada resultado debe poder explicarlo cualquier integrante.

## Documentos

- `docs/PLAN.md`: objetivo, rúbrica, hallazgos y tareas con ID. Léelo antes de tocar el análisis o la presentación.
- `docs/PROGRESO.md`: estado de cada tarea y próximo paso. Léelo al empezar una sesión.
- `docs/HISTORIAL.md`: bitácora de cambios, una entrada por commit, la más reciente arriba.

## Ritual de commit

Todo commit incluye, en el mismo commit:

1. `docs/PROGRESO.md` actualizado: estado de las tareas tocadas, fecha de "Última actualización", próximo paso.
2. Una entrada nueva arriba en `docs/HISTORIAL.md` con el formato que define ese archivo.
3. `docs/PLAN.md` actualizado si cambió el alcance, una decisión o un hallazgo. Las tareas nuevas reciben el siguiente ID libre de su fase.

Mensajes de commit en español, con prefijo convencional (`feat:`, `fix:`, `docs:`, `refactor:`) y referencia a la tarea, p. ej. `feat(T2.1): agrega median_income al modelo`.

## Convenciones del análisis

- Todo el análisis vive en `analisis_regresion.R`, ejecutable de principio a fin con `Rscript analisis_regresion.R`. Tras cambiarlo, córrelo completo y anota en el historial las métricas que cambiaron (R² ajustado, AIC, RMSE de test).
- `housing_raw.csv` es el dato original de Kaggle y se mantiene intacto. `Datos_Viviendas_Limpios.csv` se regenera desde el raw borrándolo y corriendo el script.
- Semilla `set.seed(1121)` en todo muestreo, para que los números de la presentación sean reproducibles.
- Métodos limitados a los de la unidad: regresión lineal (`lm`), transformaciones, diagnóstico de residuos y GAM (`mgcv`). Si se propone otro método, se registra como decisión en `docs/PLAN.md` antes de implementarlo.
- Código, comentarios y documentos en español. Cada número que vaya a la presentación se acompaña de su interpretación en lenguaje simple.
