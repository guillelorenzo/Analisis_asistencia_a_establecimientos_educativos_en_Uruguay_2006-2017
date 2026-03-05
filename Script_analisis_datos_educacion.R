library(readxl)
library(tidyverse)

# Abro base de datos, fuente: https://catalogodatos.gub.uy/dataset/mides-indicador-10386
db <- read_excel("/Users/guillelore/Desktop/educacion/10386_porcentaje_de_personas_de_3_a_22_aos_que_asisten_a_un_establecimiento_educativo_segun_eda.xlsx")

# Esquema
glimpse(db)

# Categorías
table(db$edadacceso)
table(db$`Zona 3`)
table(db$año)
table(db$valor)


# Cambio el tipo de "edadacceso" de char a num
db <- db %>%
  mutate(edadacceso = as.numeric(edadacceso))


# % asistencia promedio por edad
asist_prom_por_edad <- db %>%
  group_by(edadacceso) %>%
  summarise(asistencia_prom = mean(valor, na.rm = TRUE)) %>%
  arrange(edadacceso)

# % asistencia promedio por edad segun zona
asist_prom_por_edadyzona <- db %>%
  group_by(edadacceso, `Zona 3`) %>%
  summarise(asistencia_prom = mean(valor, na.rm = TRUE)) %>%
  arrange(`Zona 3`, edadacceso)

# % asistencia por edad segun año
asist_prom_por_edadyaño <- db %>%
  group_by(edadacceso, año) %>%
  summarise(asistencia_prom = mean(valor, na.rm = TRUE)) %>%
  ungroup()

# Calculo variación absoluta
asist_prom_por_edad <- asist_prom_por_edad %>%
  mutate(variacion = (asistencia_prom - lag(asistencia_prom)))

asist_prom_por_edadyzona <- asist_prom_por_edadyzona %>%
  group_by(`Zona 3`) %>%
  mutate(variacion = (asistencia_prom - lag(asistencia_prom))) %>%
  ungroup()

asist_prom_por_edadyaño <- asist_prom_por_edadyaño %>%
  mutate(variacion = (asistencia_prom - lag(asistencia_prom)))


# Gráficos
  # Gráfico 1: Asistencia promedio por edad y variación porcentual
asist_prom_por_edad %>%
  ggplot(aes(x = edadacceso)) +
  geom_col(aes(y = variacion * 5), fill = "steelblue", alpha = 0.6) +
  geom_line(aes(y = asistencia_prom), color = "red", size = 1) +
  scale_x_continuous(breaks = 3:22) +
  scale_y_continuous(
    name = "Asistencia promedio (%)",
    sec.axis = sec_axis(~ . / 5, name = "Variación (pp)")
  ) +
  labs(
    title = "Asistencia promedio a un centro educativo y variación por edad",
    x = "Edad",
    caption = "Fuente: Elaboración propia con base en datos del MIDES"
  )

  # Gráfico 2: Asistencia promedio por edad y zona
ggplot(asist_prom_por_edadyzona, aes(x = edadacceso, y = asistencia_prom, color = `Zona 3`)) +
  geom_line() +
  geom_point() +
  scale_y_log10() + # Escala logaritmica para ver la reduccion con mayor precisión
  scale_y_continuous() +
  scale_x_continuous(breaks = 3:22) +
  labs(
    title = "% de asistencia promedio a un establecimiento educativo por edad según zona (2006 - 2017)",
    x = "Edad",
    y = "Asistencia promedio (%)",
    color = "Zona",
    caption = "Fuente: Elaboracion propia con base en datos del MIDES"
  )

  # Gráfico 3: Variación promedio en asistencia por edad y zona
ggplot(asist_prom_por_edadyzona, aes(x = edadacceso, y = variacion, color = `Zona 3`)) +
  geom_segment(aes(xend = edadacceso, y = 0, yend = variacion)) +
  geom_point(size = 3) +
  scale_x_continuous(breaks = 3:22) +
  labs(
    title = "Variación promedio del período en asistencia por edad según zona (2006 - 2017)", 
    x = "Edad", 
    y = "Variación (pp)",
    color = "Zona",
    caption = "Elaboración propia con base en datos del MIDES")

  # Gráfico 4: % de asistencia promedio a un establecimiento educativo por edad según año
ggplot(asist_prom_por_edadyaño, aes(x = edadacceso, y = asistencia_prom, color = as.factor(año))) +
  geom_line() +
  scale_x_continuous(breaks = 3:22) +
  scale_color_viridis_d(option = "viridis", direction = 1) +
  labs(
    title = "% de asistencia a un establecimiento educativo por edad segun año",
    x = "Edad",
    y = "Asistencia promedio (%)",
    color = "Año",
    caption = "Fuente: Elaboración propia con base en datos del MIDES"
  )

# Fuente: Elaboración propia con base en catálogo de datos abiertos del MIDES