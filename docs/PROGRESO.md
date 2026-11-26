# Progreso

**Última actualización:** 2026-11-25
**Días para la presentación:** 8 (3 de diciembre de 2026, 9:30 h)

## Próximo paso

Que el grupo tome la decisión **D1** (agregar `median_income` o no) para desbloquear la Fase 2.

## Bloqueos

- T2.1 y todas las tareas de la Fase 3 esperan la decisión D1.

## Estado de tareas

Estados: ⬜ pendiente · 🟡 en curso · ✅ hecho · ⛔ bloqueado

| ID | Tarea | Estado | Responsable | Nota |
|---|---|---|---|---|
| D1 | Decidir variables | ⬜ | Grupo | Ver hallazgos 1 y 2 en PLAN |
| D2 | Decidir sección optimización | ⬜ | Grupo | |
| T1.1 | Problema en el README | ⬜ | | |
| T1.2 | Tabla de variables | ⬜ | | Depende de D1 |
| T2.1 | Aplicar D1 en el script | ⛔ | | Espera D1 |
| T2.2 | Corregir `anova()` | ⬜ | | |
| T2.3 | RMSE en escala original | ⬜ | | |
| T2.4 | Aplicar D2 | ⛔ | | Espera D2 |
| T3.1 | Interpretar coeficientes | ⛔ | | Espera T2.1 |
| T3.2 | Interpretar residuos | ⛔ | | Espera T2.1 |
| T3.3 | Interpretar GAM | ⛔ | | Espera T2.1 |
| T3.4 | Conclusiones | ⛔ | | Espera T3.1–T3.3 |
| T4.1 | Diapositivas | ⬜ | | |
| T4.2 | Banco de preguntas | ⬜ | | |
| T4.3 | Ensayo cronometrado | ⬜ | Todos | |

## Métricas actuales

Del script en su estado actual (registrar aquí cada vez que cambien):

| Modelo | R² ajustado | RMSE test (miles USD) |
|---|---|---|
| Línea base: predecir el promedio | 0 | 100.4 |
| LM `Valor ~ Edad + Habitaciones` | 0.036 | 99.2 |
| GAM completo (`modelo8`) | 0.128 | 94.0 |
