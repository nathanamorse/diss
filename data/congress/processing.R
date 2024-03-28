library(tesseract)

e1920 = pdftools::pdf_convert('data/congress/1920election.pdf', dpi = 600)

e1920t = ocr(e1920)

e1920t[1]

# Split the text into lines
text_lines <- str_split(e1920t[1], "\n")[[1]]

# Initialize empty data frame
df <- data.frame(state = character(), 
                 office = character(), 
                 candidate = character(), 
                 party = character(), 
                 votes = numeric(), 
                 stringsAsFactors = FALSE)

# Loop through the lines
for (i in seq_along(text_lines)) {
  line <- text_lines[i]
  
  # Check if line contains state information
  if (str_detect(line, "^[A-Z]+\\.")) {
    state <- str_extract(line, "^[A-Z]+")
  }
  
  # Check if line contains office information
  if (str_detect(line, "For [A-Z ]+\\.")) {
    office <- str_extract(line, "(?<=For )[A-Z ]+(?=\\.)")
  }
  
  # Check if line contains candidate information
  if (str_detect(line, "\\(Dem\\)|\\(Rep\\)|\\(Soc\\)")) {
    candidate_info <- str_match(line, "([A-Za-z .]+) \\((Dem|Rep|Soc)\\)\\.\\.\\. ([0-9,]+)")[, 2:4]
    if (!is.na(candidate_info[1])) {
      candidate <- candidate_info[1]
      party <- candidate_info[2]
      votes <- as.numeric(gsub(",", "", candidate_info[3]))
      
      # Add to data frame
      df <- rbind(df, data.frame(state, office, candidate, party, votes, stringsAsFactors = FALSE))
    }
  }
  
}
