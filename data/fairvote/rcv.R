library(tidyverse)
library(rvest)
library(httr)
library(jsonlite)


rcv = read.csv("rcv.csv", na.strings="") %>%
  filter(!grepl("(?i)primary", Office), !is.na(Jurisdiction)) %>%
  select(Jurisdiction:Winner) %>%
  mutate(Party=NA)


get_party_affiliation <- function(candidate_name, jurisdiction) {
  
  # Search Wikipedia
  query <- paste(candidate_name, jurisdiction)
  wikipedia_url <- paste0("https://en.wikipedia.org/w/index.php?search=", 
                          gsub(" ", "+", query))
  wikipedia_webpage <- read_html(wikipedia_url)
  
  # Extract the link to the Wikipedia page from the search results
  wikipedia_link <- wikipedia_webpage %>%
    html_node(".mw-search-result-heading a") %>%
    html_attr("href")
    
  if (!is.na(wikipedia_link)) {
    
    # Get party affiliation from the Wikipedia page
    candidate_wikipedia_url <- paste0("https://en.wikipedia.org", wikipedia_link)
    candidate_webpage <- read_html(candidate_wikipedia_url)
    party_affiliation <- candidate_webpage %>%
      html_nodes(xpath = '//*[text() = "Political party"]/following-sibling::td[1]') %>%
      html_text() %>%
      trimws()
    
  } else {
    party_affiliation = ""
  }
  
  if (length(party_affiliation)==0) party_affiliation = ""
  return(party_affiliation)
  
}

for (i in 432:nrow(rcv)) {
  rcv$Party[i] = get_party_affiliation(rcv$Winner[i], rcv$Jurisdiction[i])
}

write.csv(rcv, "rcv-election.csv", row.names=FALSE)


rcv2 = read.csv("rcv-election.csv") %>%
  filter(Party != "Nonpartisan election") %>%
  group_by(Jurisdiction) %>%
  filter(n() > 3) %>%
  ungroup() %>%
  mutate(Election.Date = lubridate::mdy(Election.Date),
         Office = gsub("\\b([1-9])\\b", "0\\1", Office)) %>%
  arrange(Jurisdiction, Office, Election.Date)

write.csv(rcv2, "rcv2.csv", row.names=FALSE)

sf = rcv2 %>% 
  filter(Jurisdiction == "San Francisco", grepl("Board", Office)) %>%
  mutate(Office = gsub(",", "", Office)) %>%
  arrange(-Year, Office)

write.csv(sf, "sf.csv", row.names=FALSE)


turnout = read.csv("HistoricalVoterTurnout_SF.csv") %>%
  mutate(Date = lubridate::mdy(Date),
         Year = format(Date, "%Y"),
         X..Turnout = as.numeric(gsub("%", "", X..Turnout))) %>%
  filter((as.numeric(Year) %% 4 == 0), format(Date, "%m")=="11")



bvt = read.csv("rcv2.csv") %>%
  filter(Jurisdiction=="Burlington", Year>2012) %>%
  mutate(Election.Date = lubridate::myd(Election.Date))






