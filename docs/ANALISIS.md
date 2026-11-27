# Análisis de resultados

## Comparación de modelos

Ajustamos con 8.000 observaciones y calculamos todos los errores de predicción sobre los mismos 2.000 casos. Un RMSE menor indica que las predicciones quedan más cerca de los valores observados según una métrica que penaliza más los errores grandes. El MAE mide el error absoluto medio. El R² de prueba compara la suma de errores cuadrados de cada modelo con la variación alrededor de la media observada de prueba.

| Modelo | R² ajustado de entrenamiento | AIC en escala original | RMSE de prueba (miles de USD) | MAE de prueba (miles de USD) | R² de prueba |
|---|---:|---:|---:|---:|---:|
| Promedio de entrenamiento | 0,000 | 95.773,0 | 100,44 | 81,17 | −0,00008 |
| LM original | 0,036 | 95.478,9 | 99,25 | 79,56 | 0,024 |
| LM con ingreso | 0,406 | 91.601,2 | 77,66 | 59,04 | 0,402 |
| LM completo | 0,558 | 89.253,1 | 68,27 | 50,12 | 0,538 |
| LM log1p | 0,604 en escala log | — | 74,03 | 51,34 | 0,457 |
| GAM | 0,584 | 88.780,9 | **66,31** | **48,51** | **0,564** |

- **Ingreso.** El LM con solo ingreso reduce en 21,59 mil USD el RMSE frente al LM original de edad y habitaciones totales. Al sumar edad, habitaciones por hogar y zona al ingreso, el RMSE baja otros 9,39 mil USD.
- **Modelos anidados.** El LM con ingreso está contenido en el LM completo. La prueba F parcial contrasta que los cinco coeficientes añadidos sean cero en conjunto. El resultado clásico es F(5, 7993) = 548,01, con p < 2,2 × 10⁻¹⁶. La heterocedasticidad observada exige cautela con ese p-valor y refuerza la importancia de la evaluación en prueba.
- **Escala logarítmica.** Ajustamos `log1p` solo a la respuesta. Calculamos el promedio de `exp(residuo)` en entrenamiento (1,0570) y aplicamos `expm1(predicción_log + log(factor))`. El factor global corrige la retransformación para aproximar la media original bajo una distribución similar de errores entre perfiles. Su eficacia puede variar si la dispersión depende de los predictores. El RMSE y el MAE se comparan en miles de USD. El AIC de la respuesta transformada se omite porque la verosimilitud de ese ajuste está en otra escala.
- **AIC.** Mide el ajuste con una penalización por complejidad. Entre el LM completo y el GAM, ambos ajustados a la misma respuesta y observaciones, el AIC disminuye aproximadamente 472 puntos. Esa comparación usa el AIC del ajuste, con grados de libertad efectivos para el GAM. La mejora predictiva observada es menor, con una caída del RMSE de 1,95 mil USD (2,9 %).

## Coeficientes del LM completo

Los efectos se expresan en miles de USD y comparan grupos de bloques iguales en los demás predictores del modelo. Los intervalos al 95 % y los p-valores son los clásicos del LM. El diagnóstico indica que sus supuestos de varianza constante y distribución normal son aproximaciones deficientes en estos datos. Los coeficientes describen asociaciones condicionales en la muestra.

| Término | Estimación | IC 95 % clásico | p clásico | Interpretación |
|---|---:|---:|---:|---|
| Intercepto | −8,80 | [−14,83; −2,76] | 0,0043 | Es la predicción algebraica para el interior con ingreso, edad y habitaciones por hogar iguales a cero, un perfil fuera del rango observado. |
| Ingreso mediano | +36,24 | [35,24; 37,25] | < 0,001 | Por cada USD 10.000 adicionales de ingreso mediano, el valor predicho aumenta en unos USD 36.244. |
| Habitaciones por hogar | −0,33 | [−0,95; 0,29] | 0,297 | La pendiente lineal estimada es pequeña y su intervalo incluye cero. |
| Edad mediana | +0,76 | [0,64; 0,88] | < 0,001 | Por cada año adicional de edad mediana, el valor predicho aumenta en unos USD 760. |
| `<1H OCEAN` | +65,83 | [62,34; 69,33] | < 0,001 | Los sectores de esta categoría tienen un valor predicho unos USD 65.835 mayor que el interior. |
| `NEAR BAY` | +79,09 | [73,76; 84,42] | < 0,001 | Los sectores cercanos a una bahía tienen un valor predicho unos USD 79.090 mayor que el interior. |
| `NEAR OCEAN` | +84,23 | [79,38; 89,07] | < 0,001 | Los sectores de esta categoría, que incluye cuatro observaciones de islas en la muestra total, tienen un valor predicho unos USD 84.228 mayor que el interior. |

## Diagnóstico del LM completo

Después de ejecutar el script, abre [los cuatro gráficos del LM](../resultados/diagnostico_lm.png).

| Evidencia | Resultado | Implicación |
|---|---|---|
| Residuos frente a ajustados | La línea suavizada presenta curvatura y la dispersión cambia con el ajuste. | Una sola pendiente por predictor deja estructura sin capturar. |
| QQ normal | La cola superior se aparta marcadamente de la recta y hay un residuo negativo extremo. | Las colas se desvían de la normalidad. |
| Shapiro–Wilk | H₀: la distribución es normal. En 5.000 residuos de entrenamiento, W = 0,9327 y p < 2,2 × 10⁻¹⁶. | El contraste detecta desviaciones. El QQ permite evaluar su forma y la submuestra grande hace sensible al test. |
| Escala-localización y Breusch–Pagan studentizada | H₀: varianza constante. BP = 270,76, 6 grados de libertad y p < 2,2 × 10⁻¹⁶. | Los residuos se dispersan de forma diferente según el ajuste. Los errores estándar clásicos pueden estar mal calibrados. |
| Apalancamiento y distancia de Cook | `Bloque_4189` tiene una distancia de Cook de 0,284 y 61,8 habitaciones por hogar. `Bloque_6572` tiene 132,5 habitaciones por hogar y apalancamiento de 0,387. | Conviene conocer la presencia de cocientes extremos al interpretar el ajuste. Conservamos esas filas durante el análisis. |
| Independencia y ubicación | Durbin–Watson contrasta autocorrelación de primer orden entre observaciones consecutivas. Aquí el orden es aleatorio y carece de significado como secuencia. El [mapa de residuos del GAM en prueba](../resultados/residuos_gam_mapa.png) muestra agrupaciones locales de errores grandes, con ambos signos. | El mapa es exploratorio. Una partición aleatoria puede colocar grupos vecinos en entrenamiento y prueba. |

## Curvas del GAM

El GAM gaussiano con enlace identidad suma tres efectos suavizados y un desplazamiento por zona. Ajusta la penalización por REML. La [figura de curvas parciales](../resultados/curvas_gam.png) muestra el rango entre los percentiles 1 y 99 de cada variable, con bandas puntuales aproximadas del 95 % para el efecto parcial centrado. El ajuste usa todas las filas de entrenamiento. Los grados de libertad efectivos (edf) describen la flexibilidad estimada de cada curva. Un valor cercano a 1 correspondería aproximadamente a una recta.

| Término | edf | Relación ajustada con los demás predictores fijos |
|---|---:|---|
| `s(Ingreso_Mediano)` | 10,09 | Ascendente en el tramo central. El efecto parcial pasa de −79,83 a +89,20 mil USD entre los percentiles 10 y 90 de ingreso. |
| `s(Habitaciones_por_Hogar)` | 9,48 | Desciende hasta unas seis habitaciones por hogar y luego repunta. Los efectos en el tramo alto son más inciertos. La curvatura ayuda a explicar por qué la pendiente global del LM resume mal esta asociación. |
| `s(Edad_Media)` | 6,84 | Sube al pasar de viviendas más nuevas a edades intermedias, cambia poco entre los 28 y 37 años y vuelve a subir para las edades altas. |

Los tres contrastes de suavizados dan p < 2,2 × 10⁻¹⁶ en la salida de R, bajo la aproximación de `mgcv`. El chequeo de dimensión de base dio índices `k` próximos a 1 (1,018, 1,022 y 0,995, respectivamente) y en esta corrida no mostró señales claras de bases insuficientes.

## Conclusiones

El GAM obtuvo el menor error de los modelos evaluados. En prueba, su RMSE fue de unos **USD 66.314** y su MAE de **USD 48.515** para el valor mediano de un grupo de bloques. La mayor reducción del error se observa al incorporar el ingreso y enriquecer los predictores. El GAM aporta una mejora adicional de aproximadamente **USD 1.955 de RMSE** frente al LM completo y permite explicar relaciones que cambian de pendiente.

Los resultados corresponden a grupos de bloques californianos en 1990, con datos completos y valores bajo USD 500.000. La partición aleatoria evalúa la predicción de otros grupos de la misma población filtrada. La separación entre modelos puede variar con otra muestra, especialmente si se dejan regiones completas fuera del entrenamiento. El análisis tampoco identifica efectos causales ni estima valores de viviendas individuales.
