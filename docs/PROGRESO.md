# Progreso

**Última actualización** 2026-11-27

**Presentación** 3 de diciembre de 2026, 9:30 h (faltan 6 días)

## Próximo paso

Cada integrante debe ensayar la exposición completa y practicar el banco de preguntas. La pauta cubre 7 min 10 s y el ensayo debe durar entre 5 y 10 min por persona.

## Estado de tareas

| ID | Estado | Resultado |
|---|---|---|
| D1 | Hecho | Ingreso mediano, habitaciones por hogar, edad mediana y zona. |
| D2 | Hecho | Se retiró la simulación ajena a los datos de vivienda. |
| D3 | Hecho | Muestra y partición originales, con predicción logarítmica evaluada en miles de USD. |
| D4 | Hecho | Diagnóstico espacial exploratorio con un mapa de residuos. |
| T1.1 | Hecho | Pregunta y fuente en el README. |
| T1.2 | Hecho | Tabla de variables y unidades en el README. |
| T2.1 | Hecho | LM y GAM ajustados con los predictores nuevos. |
| T2.2 | Hecho | Prueba F parcial del LM con ingreso frente al LM completo. |
| T2.3 | Hecho | Seis modelos evaluados sobre los mismos 2.000 casos y en miles de USD. |
| T2.4 | Hecho | Script dedicado al análisis de vivienda. |
| T3.1 | Hecho | Coeficientes e intervalos del LM completo en [ANALISIS.md](ANALISIS.md). |
| T3.2 | Hecho | Pruebas, gráficos, influencia y mapa de residuos explicados. |
| T3.3 | Hecho | Curvas del GAM, edf y comparación de AIC documentados. |
| T3.4 | Hecho | Modelo elegido, error observado y alcance documentados. |
| T4.1 | Hecho | Pauta de exposición oral de 7 min 10 s, organizada por tema. |
| T4.2 | Hecho | Quince preguntas respondidas y pauta cronometrada en [PREGUNTAS.md](PREGUNTAS.md). |
| T4.3 | Pendiente | Ensayo individual de todos los integrantes. |

## Métricas de referencia

| Modelo | R² ajustado de entrenamiento | AIC en escala original | RMSE de prueba (miles de USD) |
|---|---:|---:|---:|
| Promedio de entrenamiento | 0,000 | 95.773,0 | 100,44 |
| LM original | 0,036 | 95.478,9 | 99,25 |
| LM completo | 0,558 | 89.253,1 | 68,27 |
| GAM | 0,584 | 88.780,9 | 66,31 |
