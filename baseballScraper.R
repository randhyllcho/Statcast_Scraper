library(tidyverse)
library(baseballr)
library(BRRR)
library(lubridate)

start_dates <- as.character(seq(ymd("2018-03-01"), ymd(Sys.Date() - 6), by = "weeks"))
end_dates <- as.character(seq(ymd("2018-03-07"), ymd(Sys.Date()), by = "weeks"))

game_dates <- tibble(start_dates, end_dates)

game_dates <- game_dates %>% 
  filter(!month(start_dates) %in% c(11,12,1)) %>% 
  mutate_at(c("start_dates", "end_dates"), as.character)

rows <- list()
pitcher_rows <- list()

for (i in seq(1,nrow(game_dates))) {
  dat <- scrape_statcast_savant_pitcher_all(start_dates[i], end_dates[i])
  pitcher_rows[[i]] <- dat
}; skrrrahh(43)

hitter_data <- rbind_list(rows)
pitcher_data <- do.call(rbind, pitcher_rows)


write.csv(hitter_data, "marapr2018_Hitters.csv", row.names = FALSE)
write.csv(pitcher_data, "season2018_Pitchers.csv", row.names = FALSE)

