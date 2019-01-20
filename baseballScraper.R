pacman::p_load(pool, DBI, tidyverse, keyringr, RPostgreSQL, baseballr, BRRR, lubridate)

db <- dbPool(PostgreSQL(),
             dbname = 'pitchers_2018',
             host = 'localhost')

beg_date <- ymd(Sys.Date() - 6)
end_date <- ymd(Sys.Date())

start_dates <- as.character(seq(ymd("2018-03-01"), beg_date, by = "weeks"))
end_dates <- as.character(seq(ymd("2018-03-07"), end_date, by = "weeks"))

game_dates <- tibble(start_dates, end_dates)
month(game_dates$start_dates)
game_dates <- game_dates %>% 
  filter(!month(start_dates) %in% c(11,12,1)) %>% 
  mutate_at(c("start_dates", "end_dates"), as.character)

pitcher_rows <- list()

for (i in seq(1,nrow(game_dates))) {
  dat <- scrape_statcast_savant_pitcher_all(start_dates[i], end_dates[i])
  pitcher_rows[[i]] <- dat
  Sys.sleep(10)
}; skrrrahh(43)
  
pitcher_data <- do.call(rbind, pitcher_rows)

glimpse(pitcher_data)

dbWriteTable(db, "Pitchers", pitcher_data)

poolClose(db)
