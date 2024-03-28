# Packages
library(rvest)
library(dplyr)
library(tidyr)

# Scrape the main page for country links
main_url = "https://data.ipu.org/elections?region=&structure=any__lower_chamber&form_build_id=form-LM5XNmMSpTc7Fo099DiBo6Tpjxakn163-9q8jmdpASY&form_id=ipu__utils_filter_form&op=Show+items"
country_links = read_html(main_url) |>
  html_nodes("table") |>  # Select all tables
  html_nodes("a") |>
  html_attr("href") |>
  unique()

# Prefix with domain
country_links = paste0("https://data.ipu.org", country_links)[-c(1:6)]

# Initalize dataframe
parl_parties_full = tibble(`Political group`=NA, Total=NA, Country=NA)

# Scrape each country's data
for (link in country_links) {
  
  # Read webpage
  page = read_html(link)
  
  # Get party composition table
  parties = page |>
    html_nodes(".panel-pane:contains('Parties or coalitions') table") |>
    html_table() |> first()
  
  # Determine if successful
  grabbed = !is.null(parties)
  
  # Remove extra variales
  if (grabbed) {
    if (ncol(parties>2)) {
      parties = parties[,1:2]
    }
  }
  
  # Add country name
  parties$Country = page |> html_nodes("h2") |> html_text() |> first()
  
  # Add to full data
  if (grabbed) parl_parties_full = rbind(parl_parties, parties)
  
}

# Finalize data
parl_parties = parl_parties_full |>
  select(country=Country, party=`Political group`, seats=Total) |>
  group_by(country) |>
  mutate(share = seats*100/sum(seats)) |>
  na.omit()

# Country-level summaries
party_comp = parl_parties |>
  filter(share >= 5) |>
  group_by(country) |>
  summarize(parties = n())

save(parl_parties, party_comp, file="parline.Rdata")

getwd()

