# ==============================================================================
# PROJECT: Gender Disparities in Global Mortality (2016)
# AUTHOR: Baran
# DESCRIPTION: Visualizing WHO data using Lancet Journal design standards
# ==============================================================================

# 1. Load Required Libraries
library(tidyverse)
library(readxl)
library(ggsci)
library(scales)

# 2. Load and Clean Raw Data
data_2016 <- read_excel("GHE2016_Deaths_Global_2000_2016.xls", sheet = "2016 Global", skip = 9)

clean_data <- data_2016 |>
  select(1, 2, everything())

# 3. Data Preparation & Long-Format Reshaping
gender_data <- clean_data |>
  select(
    Disease = `...3`,
    Male = `...7`,
    Female = `...9`
  ) |>
  filter(Disease %in% c(
    "Communicable, maternal, perinatal and nutritional conditions",
    "Noncommunicable diseases",
    "Injuries"
  )) |>
  mutate(
    Male = as.numeric(Male),
    Female = as.numeric(Female),
    Disease = case_when(
      Disease == "Communicable, maternal, perinatal and nutritional conditions" ~ "Communicable & Nutritional",
      TRUE ~ Disease
    )
  ) |>
  pivot_longer(
    cols = c(Male, Female),
    names_to = "Gender",
    values_to = "Deaths"
  )

# 4. Generate Publication-Grade Visualization (Lancet Style)
ggplot(data = gender_data, aes(x = reorder(Disease, -Deaths), y = Deaths, fill = Gender)) +
  geom_col(position = "dodge", width = 0.7) +
  theme_classic() +
  scale_fill_lancet() +
  scale_y_continuous(
    labels = scales::label_number(suffix = "M", scale = 1e-6),
    expand = expansion(mult = c(0, 0.1))
  ) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 20)) +
  theme(
    axis.text.x = element_text(color = "black", size = 9, face = "bold"),
    axis.text.y = element_text(color = "black", size = 9),
    axis.title = element_text(face = "bold", size = 10),
    plot.title = element_text(face = "bold", size = 14, hjust = 0),
    plot.subtitle = element_text(color = "gray30", size = 11),
    legend.position = "right",
    legend.title = element_text(face = "bold")
  ) +
  labs(
    title = "Gender Disparities in Global Mortality (2016)",
    subtitle = "Demographic Health Equity Analysis of WHO Global Health Estimates",
    x = "Cause of Death",
    y = "Number of Deaths",
    caption = "Source: World Health Organization (WHO) | Visualized by Baran"
  )

# 5. Save the Final High-Resolution Plot
ggsave("global_gender_disparities_plot.png", width = 10, height = 6, dpi = 300)

