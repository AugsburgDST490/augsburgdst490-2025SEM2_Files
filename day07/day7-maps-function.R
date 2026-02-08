### DST 490, Day 7

# Topics covered: Introduction to mapping (iteration)
library(tidyverse)

# Unemployment and education data from the USDA. See day07_README.md for data sources

# Name of the uemployment file
unemployment_file <- "day07/Unemployment.xlsx"

unemployment <- readxl::read_excel(unemployment_file,
                                   skip = 4,
                                   sheet = 'UnemploymentMedianIncome')


glimpse(unemployment)



# Name of the file to read in:
education_file <- "day07/Education.xlsx"


education <- readxl::read_excel(education_file ,
                                skip = 3,
                                sheet = 'Education 1970 to 2022')


glimpse(education)

### Task 1: Compute the average unemployment from 2008 - 2012.  Here is some starter code:

unemployment |>
  select(starts_with("Unemployment_rate")) |> 
  pivot_longer(cols=everything()) |>
  separate_wider_position(name,c(name=18,Year = 4)) |>
  mutate(Year = as.numeric(Year)) |>
  filter(Year %in% 2018:2022) |> 
  summarize(avg_unemploy = mean(value,na.rm=TRUE)) |>
  pull(avg_unemploy)

### Task 1a: Now let's define average unemployment function
compute_unemployment <- function(input_data,year_span) {
  
  avg_val <- input_data |>
    select(starts_with("Unemployment_rate")) |>
    pivot_longer(cols = everything()) |>
    separate_wider_position(name, c(name = 18, Year = 4)) |>
    mutate(Year = as.numeric(Year)) |>
    filter(Year %in% year_span) |>
    summarize(avg_unemploy = mean(value, na.rm = TRUE)) |>
    pull(avg_unemploy)
  
  return(avg_val)
}

compute_unemployment(unemployment,2018:2022)


### Task 2: compute this for each FIPS code in the US

# Create a nested list organized by the FIPS code
nested_unemployment <- unemployment |>
  group_by(FIPS_Code) |>
  nest()


# Let's take a peek at the data here:
glimpse(nested_unemployment$data[[1]])


# Try this out ....
compute_unemployment(
  input_data = nested_unemployment$data[[1]],
  year_span = 2018:2022
  )

# Task 2a: Use a nested data frame w/ map_dbl to compute the average unemployment for each of the different localities in the dataset
unemployment_span <- nested_unemployment |>
  mutate(unemployment_pct_2008_2012 = map_dbl(.x=data,
                                     .f=~compute_unemployment(.x,2018:2022))) |>
  select(-data)  # Get rid of the data column

glimpse(unemployment_span)

### Task 3: join with education data from that same timespan:
# First let's make the education dataset a little smaller to work with
# We need a double select so that we first get the FIPS code, and the span of years, and then also variables that are percentages:

education_small <- education |>
  select(`FIPS Code`,State,ends_with("2008-12")) |> 
  select(`FIPS Code`,State,starts_with("Percent") ) 
  

# Next we need to join the unemployment data to the education data
joined_dataset <- unemployment_span |>
  inner_join(education_small,by=c("FIPS_Code"="FIPS Code"))

# Plot the unemployment data with the educational rate:
joined_dataset |>
  ggplot(aes(x=`Percent of adults with less than a high school diploma, 2008-12`,
             y = unemployment_pct_2008_2012)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  labs(y="Average Unemployment Rate (%, 2018-2022)")
  
