load_and_clean <- function(path, sheet) {
  suppressPackageStartupMessages({
    library(readxl)
    library(dplyr)
  })

  df <- read_excel(path, sheet = sheet)

  numeric_cols <- c("n SG", "n CG", "Mean SG", "Mean SD SG",
                    "Mean CG", "Mean SD CG")

  df %>%
    filter(if_all(all_of(numeric_cols), ~ !is.na(.x))) %>%
    mutate(across(all_of(numeric_cols), as.numeric))
}
