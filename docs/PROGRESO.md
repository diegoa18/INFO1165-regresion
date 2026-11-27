# Progreso

**Última actualización** 2026-11-27

**Presentación** 3 de diciembre de 2026, 9:30 h (faltan 6 días)

## Próximo paso

Ajustar los modelos con ingreso, habitaciones por hogar, edad y zona. Mantener el LM de referencia.

## Estado de tareas

| ID | Estado | Resultado |
|---|---|---|
| D1 | Pendiente |  |
| D2 | Hecho | Se retiró la simulación ajena a los datos de vivienda. |
| D3 | Hecho | Muestra y partición originales, con predicción logarítmica evaluada en miles de USD. |
| D4 | Pendiente |  |
| T1.1 | Hecho | Pregunta y fuente en el README. |
| T1.2 | Pendiente |  |
| T2.1 | Pendiente |  |
| T2.2 | Hecho | Prueba F entre los LM anidados de habitaciones y de edad más habitaciones. |
| T2.3 | Hecho | Cinco modelos de referencia comparados en las mismas observaciones y unidades. |
| T2.4 | Hecho | Script dedicado al análisis de vivienda. |
| T3.1 | Pendiente |  |
| T3.2 | Pendiente |  |
| T3.3 | Pendiente |  |
| T3.4 | Pendiente |  |
| T4.1 | Pendiente |  |
| T4.2 | Pendiente |  |
| T4.3 | Pendiente | Ensayo individual de todos los integrantes. |

## Métricas de referencia

| Modelo | R² ajustado de entrenamiento | AIC en escala original | RMSE de prueba (miles de USD) |
|---|---:|---:|---:|
| Promedio de entrenamiento | 0,000 | 95.773,0 | 100,44 |
| LM con habitaciones | 0,019 | 95.618,6 | 99,66 |
| LM original | 0,036 | 95.478,9 | 99,25 |
| LM log1p | 0,036 en escala log | — | 99,34 |
| GAM original | 0,128 | 94.700,7 | 93,95 |
