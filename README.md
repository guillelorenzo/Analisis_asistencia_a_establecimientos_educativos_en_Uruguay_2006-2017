# Análisis de asistencia a establecimientos educativos en Uruguay (2006–2017)

Análisis exploratorio del porcentaje de personas de 3 a 22 años que asisten a un establecimiento educativo en Uruguay, desagregado por edad, zona geográfica y año.

Fuente: [Catálogo de datos abiertos del MIDES](https://catalogodatos.gub.uy/dataset/mides-indicador-10386)

---

## Estructura del repositorio

```
├── Script_analisis_datos_educacion.R
├── 10386_porcentaje_de_personas_de_3_a_22_aos_que_asisten_a_un_establecimiento_educativo_segun_eda.xlsx
└── graficos/
    ├── Grafico_1_asistencia_promedio_y_variacion_por_edad.pdf
    ├── Grafico_2_asistencia_promedio_por_edad_segun_zona.pdf
    ├── Grafico_3_variacion_promedio_por_edad_segun_zona.pdf
    └── Grafico_4_asistencia_promedio_por_edad_segun_ano.pdf
```

---

## Datos

La base contiene 960 observaciones con las siguientes variables:

| Variable | Tipo | Descripción |
|---|---|---|
| `edadacceso` | Numérico | Edad (3 a 22 años) |
| `Zona 3` | Carácter | Zona geográfica |
| `año` | Numérico | Año (2006 a 2017) |
| `valor` | Numérico | % de asistencia |

  Zonas geográficas:  
- Montevideo
- Localidades del interior con 5.000 habitantes o más
- Localidades del interior con menos de 5.000 habitantes y área rural
- Zonas Rurales

---

## Requisitos

```r
library(readxl)
library(tidyverse)
```

---

## Metodología

A partir de la base original se construyeron tres objetos analíticos:

-   `asist_prom_por_edad`  : promedio de asistencia y variación en puntos porcentuales (pp) entre edades consecutivas, agregando todas las zonas y años.
-   `asist_prom_por_edadyzona`  : mismo cálculo desagregado por zona geográfica. La variación se calcula dentro de cada zona para evitar comparaciones entre grupos.
-   `asist_prom_por_edadyaño`  : promedio de asistencia por edad y año, colapsando las zonas.

La variación se calcula como la diferencia en puntos porcentuales entre una edad y la anterior (`lag()`), lo que permite identificar en qué edades se producen las mayores caídas en asistencia.

---

## Hallazgos principales

### Gráfico 1 — Asistencia promedio y variación por edad
El pico de asistencia se alcanza a los   9 años  , a partir de donde desciende de forma ininterrumpida. Entre los 5 y 10 años la variación es mínima, lo que indica una etapa de asistencia estable y elevada. A partir de los   14 años   la caída supera los 25 puntos porcentuales por año, con su máximo a los 18 años (casi -25pp), edad esperada de finalización del liceo. Tras ese pico, la reducción continúa pero a un ritmo decreciente.

### Gráfico 2 — Asistencia promedio por edad según zona
Montevideo presenta consistentemente la mayor asistencia, con una excepción a los 5 años donde las localidades del interior la superan. Las cuatro zonas siguen un patrón similar: asistencia alta y estable hasta los 12–13 años, con una caída que se acentúa a partir de los 16. Las zonas rurales registran la menor asistencia en la mayoría de las edades, excepto después de los 18 años, donde las localidades del interior con menos de 5.000 habitantes pasan a tener los valores más bajos.

### Gráfico 3 — Variación promedio por edad según zona
Hasta los 7 años, las zonas rurales son las que mayor crecimiento registran en asistencia; a partir de ahí, son también las que mayor caída presentan. Montevideo es la zona con menor reducción en la mayoría de las edades (excepto a los 16 y 22 años). Todas las zonas siguen una tendencia clara y marcada a lo largo del ciclo etario.

### Gráfico 4 — Asistencia promedio por edad según año
A lo largo del período 2006–2017 la asistencia aumentó en prácticamente todas las edades. Gracias a la escala de color monocromática (viridis), se puede observar cómo los años más recientes (tonos claros) presentan una asistencia notoriamente mayor que los años anteriores (tonos oscuros), con diferencias marcadas especialmente en las edades de mayor deserción.
