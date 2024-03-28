#----- Preliminaries -----#

# Packages
library(bib2df)
library(tidyverse)

# Load bibtex file
bib = bib2df("references.bib")


#----- Alphabetize citations -----#
bib2 = bib %>%
  
  # Extract each author last names
  mutate(authors = AUTHOR %>%
           map(~gsub("\\{|\\}|,", "", .x)) %>%
           map(~word(.x, 1, 1))) %>%
  
  # Put each author's last name in its own column
  unnest_wider(authors, names_sep = "_") %>%
  
  # Arrange by authors and then year
  arrange(contains("authors"), YEAR) %>%
  
  # Remove temporary columns
  select(!contains("authors"))


#----- Fix missing brackets -----#
bib3 = bib2 %>% mutate(
  
  # Author names
  AUTHOR = AUTHOR %>%
    map(modify_if, ~grepl("^[^\\{]", .x), ~paste0("{", .x)) %>%
    map(modify_if, ~grepl("[^\\}]$", .x), ~paste0(.x, "}")),
  
  # Editor names
  EDITOR = EDITOR %>%
    map(modify_if, ~grepl("^[^\\{]", .x), ~paste0("{", .x)) %>%
    map(modify_if, ~grepl("[^\\}]$", .x), ~paste0(.x, "}"))
  
)


#----- Write new file -----#
df2bib(bib3, "references2.bib")



