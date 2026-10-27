library (tidyverse)
library (readxl)
data_2016 <- read_excel ("GHE2016_Deaths_Global_2000_2016.xls", sheet = "2016 Global", skip = 9)
View (data_2016)
colnames (data_2016)
clean_data <- data_2016 |> select (1, 2, everything()) 
top_disease <- clean_data |> 
  filter (!is.na(Code)) |>
  head (5) 
top_disease 
plot_data <- clean_data |> 
filter ( Code %in% c(10, 20, 30, 40)) |>
mutate (Disease = c( "Communicable", "Infectious", "Tuberculosis", "STDs"))
ggplot (data = plot_data, aes (x = Disease, y = ...7)) +
  geom_col (fill = "darkblue", width = 0.6) +
  theme_classic () +
  scale_y_continuous (labels = label_comma()) +
  labs (title = "Global Mortality by Select Causes (2016)", subtitle = "Analysis of WHO")
str (clean_data) 
names (clean_data)
gender_data <- clean_data |>
  filter(Code %in% c(10, 20, 30, 40)) |>
  mutate(Disease = c("Communicable", "Infectious", "Tuberculosis", "STDs")) |>
  select(Disease, Male = ...4, Female = ...15) |>
  mutate(Male = as.numeric(Male), Female = as.numeric(Female)) |>
  pivot_longer(cols = c(Male, Female), names_to = "Gender", values_to = "Deaths")
library (ggsci)
ggplot(data = gender_data, aes(x = Disease, y = Deaths, fill = Gender)) +
  geom_col(position = "dodge", width = 0.7) +
  theme_classic() +
  scale_fill_lancet() +
  scale_y_continuous(labels = label_comma()) +
  labs(
    title = "Gender Disparities in Global Mortality (2016)",
    subtitle = "Health Equity Analysis of WHO Global Health Estimates",
    x = "Cause of Death",
    y = "Number of Deaths",
    caption = "Source: WHO | Visualized by Baran | Lancet Color Palette"
  )

gender_data <- clean_data |>
  filter(Code %in% c(10, 20, 30, 40)) |>
  mutate(
    Male_Clean = as.numeric(...4),
    Female_Clean = as.numeric(...15),
    Disease = c("Communicable", "Infectious", "Tuberculosis", "STDs")
  ) |>
  select(Disease, Male = Male_Clean, Female = Female_Clean) |>
  pivot_longer(cols = c(Male, Female), names_to = "Gender", values_to = "Deaths")


ggplot(data = gender_data, aes(x = Disease, y = Deaths, fill = Gender)) +
  geom_col(position = "dodge", width = 0.7) +
  theme_classic() +
  scale_fill_lancet() +
  scale_y_continuous(labels = label_comma()) +
  labs(
    title = "Gender Disparities in Global Mortality (2016)",
    subtitle = "Health Equity Analysis of WHO Global Health Estimates",
    x = "Cause of Death",
    y = "Number of Deaths",
    caption = "Source: WHO | Visualized by Baran | Lancet Color Palette"
  )
head (gender_data, 8) 


gender_data <- clean_data |>
  filter(Code %in% c(10, 20, 30, 40)) |>
  mutate
colnames (clean_data)
# 1. Extract and rename the real columns from clean_data
gender_data <- clean_data |>
  select(
    Disease = `Cause of death`,
    Male = `...7`,
    Female = `...15`
  ) |>
  
  # Data preparation using the exact 3 major WHO categories
  gender_data <- clean_data |>
  select(
    Disease = `...3`,
    Male = `...7`,
    Female = `...15`
  ) |>
  filter(Disease %in% c(
    "Communicable, maternal, perinatal and nutritional conditions",
    "Noncommunicable diseases",
    "Injuries"
  )) |>
  mutate(
    Male = as.numeric(Male),
    Female = as.numeric(Female)
  ) |>
  pivot_longer(cols = c(Male, Female), names_to = "Gender", values_to = "Deaths")


# PROJECT: Gender Disparities in Global Mortality (2016)
# AUTHOR: Baran
# DESCRIPTION: Visualizing WHO data using Lancet Journal design standards
# ==============================================================================

# 1. Initialize the ggplot
ggplot(data = gender_data, aes(x = Disease, y = Deaths, fill = Gender)) +
  
  # 2. Create a grouped bar chart
  geom_col(position = "dodge", width = 0.7) +
  
  # 3. Academic theme with no background grid
  theme_classic() +
  
  # 4. Lancet Journal color palette
  scale_fill_lancet() +
  
  # 5. Format Y-axis numbers
  scale_y_continuous(labels = label_comma(), expand = expansion(mult = c(0, 0.1))) +
  
  # 6. Automatically wrap long text into multiple lines
  scale_x_discrete(labels = function(x) str_wrap(x, width = 25)) +
  
  # 7. Keep text horizontal and centered for perfect readability
  theme(
    axis.text.x = element_text(color = "black", size = 9, face = "bold"),
    axis.text.y = element_text(color = "black"),
    legend.position = "right"
  ) +
  
  # 8. Academic labels and metadata
  labs(
    title = "Gender Disparities in Global Mortality (2016)",
    subtitle = "Demographic Analysis of WHO Major Health Categories",
    x = "Cause of Death",
    y = "Number of Deaths",
    caption = "Source: World Health Organization (WHO) | Visualized by Baran"
  ) +
  scale_y_continuous(labels = scales::label_number(suffix = "M", scale = 1e-6))
# 9. Save the final plot
ggsave("global_gender_disparities_plot.png", width = 10, height = 6, dpi = 300)
