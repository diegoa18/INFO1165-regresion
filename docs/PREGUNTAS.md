# Preguntas para defender el proyecto

## 1. ¿Qué intentamos predecir y qué representa una fila?

El valor mediano de las viviendas de un grupo de bloques censales, en miles de USD de 1990. La fila agrega las viviendas y hogares del sector. El modelo predice el valor mediano de ese grupo.

## 2. ¿Cómo se pasó de 20.640 a 10.000 observaciones?

Se quitaron 207 filas con faltantes y otras 985 con un valor de USD 500.000 o más. Ese umbral excluye los valores en el tope de registro (USD 500.001) y conserva el filtro de la versión original. De las 19.448 elegibles se muestrearon 10.000 sin reemplazo.

## 3. ¿Por qué usamos ingreso mediano y habitaciones por hogar?

El ingreso se asocia con el valor de la vivienda y el modelo con solo ingreso ya reduce el RMSE de 99,25 a 77,66 mil USD frente al LM original. Dividir habitaciones por hogares permite comparar sectores de tamaños distintos. El cociente puede ser muy alto cuando un sector tiene pocos hogares registrados.

## 4. ¿Cómo se interpreta el coeficiente del ingreso?

En el LM completo, dos sectores con los mismos valores para las demás variables y una diferencia de USD 10.000 en ingreso mediano tienen, según el ajuste, una diferencia de unos USD 36.244 en el valor mediano predicho. Es una asociación condicional.

## 5. ¿Cómo entra la proximidad al océano?

Es un factor con `INLAND` como referencia. El coeficiente de `NEAR BAY` en el LM completo indica aproximadamente USD 79.090 de diferencia predicha respecto del interior, para el mismo ingreso, edad y habitaciones por hogar. Los cuatro casos de islas se incluyeron en la categoría `NEAR OCEAN` porque una categoría propia se ajustaría con muy pocos casos.

## 6. ¿Qué aporta un GAM?

Suma curvas suaves para las variables numéricas y desplazamientos por zona. Conserva una interpretación por predictor y permite que el cambio de valor por cada unidad sea distinto a lo largo de la curva. La penalización regula cuánto puede ondular.

## 7. ¿Qué significa edf y qué forma tienen las curvas?

Los grados de libertad efectivos miden la flexibilidad del suavizado. Una recta tiene aproximadamente un grado de libertad para el término centrado. Aquí ingreso tiene edf 10,09 y sube, habitaciones tiene 9,48 y cae hasta cerca de seis antes de repuntar, y edad tiene 6,84 y sube más en el tramo alto.

## 8. ¿Cómo puede habitaciones por hogar tener p = 0,297 en el lineal y aparecer en el GAM?

El LM prueba una pendiente única. En el GAM el efecto primero cae y luego sube, de modo que una sola pendiente puede quedar cerca de cero. Los contrastes corresponden a funciones distintas.

## 9. ¿Para qué probamos log1p y cómo volvimos a dólares?

El log comprime valores altos y puede mejorar el ajuste si la relación es multiplicativa. Invertimos la transformación con `expm1` y un factor calculado con residuos de entrenamiento para aproximar la media original. Su RMSE de 74,03 mil USD fue mayor que el del LM completo y el del GAM.

## 10. ¿En qué se diferencian RMSE, MAE y R² de prueba?

El RMSE toma la raíz del promedio de los errores cuadrados. El MAE promedia los errores absolutos. Ambos conservan la unidad del valor y el RMSE penaliza más los errores grandes. El R² de prueba compara el error cuadrático con la variación respecto de la media de prueba. En el GAM, RMSE = 66,31, MAE = 48,51 y R² = 0,564.

## 11. ¿Por qué el R² ajustado del LM logarítmico es más alto?

Su 0,604 se calcula sobre una respuesta logarítmica. El 0,584 del GAM se calcula sobre valores en miles de USD. Al llevar todas las predicciones a miles de USD, el GAM logra el menor RMSE y mayor R² en prueba.

## 12. ¿Cuándo usamos la prueba F y cuándo AIC?

El LM con ingreso está anidado en el LM completo. La prueba F clásica pregunta si sus cinco coeficientes adicionales son cero en conjunto y exige supuestos como homocedasticidad. Para comparar el GAM con el LM completo usamos AIC sobre la misma respuesta. El AIC penaliza la complejidad y se calcula en entrenamiento. Para estimar precisión fuera del ajuste usamos el error en prueba.

## 13. ¿Qué indican Shapiro–Wilk y Breusch–Pagan?

Shapiro–Wilk contrasta normalidad y el QQ muestra desviaciones visibles en las colas. Breusch–Pagan contrasta varianza constante y el gráfico de escala-localización muestra dispersión cambiante. En ambos casos p < 0,001. Esto limita la confianza en los intervalos clásicos del LM.

## 14. ¿Por qué no aplicamos Durbin–Watson?

El contraste requiere un orden en el que tenga sentido hablar de observaciones consecutivas. Los grupos de bloques se muestrearon y ordenaron al azar. Usamos un mapa exploratorio de errores para ver si hay agrupaciones geográficas.

## 15. ¿Qué modelo elegimos y hasta dónde llega la conclusión?

El GAM dio 66,31 mil USD de RMSE, frente a 68,27 del LM completo y 100,44 del promedio. El mayor cambio vino de mejorar las variables. La ventaja del GAM sobre el LM es pequeña y se observó en una sola partición aleatoria del censo de 1990. El resultado se limita a sectores con valores bajo el umbral y no permite estimar el error en zonas geográficas completamente nuevas.

## Pauta de exposición oral

| Bloque | Punto a defender | Tiempo |
|---|---|---:|
| 1 | Pregunta predictiva y unidad de análisis | 0:30 |
| 2 | Datos, exclusiones y partición | 1:00 |
| 3 | Predictores, LM y GAM | 1:10 |
| 4 | RMSE de prueba, escala original y mejora | 1:15 |
| 5 | Curvas y grados de libertad efectivos | 1:15 |
| 6 | Residuos, supuestos y cautela en inferencia | 1:10 |
| 7 | Modelo elegido y alcance | 0:50 |
| | **Total previsto** | **7:10** |

Cada integrante puede seguir los siete bloques en orden y practicar preguntas al azar. El tiempo de la tabla es una meta para el ensayo.
