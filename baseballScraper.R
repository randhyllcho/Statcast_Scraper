pacman::p_load(pool, DBI, tidyverse, keyringr, RMySQL, baseballr, BRRR, lubridate)

db <- dbPool(MySQL(),
             dbname = 'Pitchers_2018',
             host = 'localhost',
             username = 'root',
             password = decrypt_kc_pw('pitchers_DB'))

beg_date <- as.character(ymd(Sys.Date() - 6))
end_date <- as.character(ymd(Sys.Date()))

if (db_has_table(db, "Pitchers")) {
  pitcher_data <- scrape_statcast_savant_pitcher_all(beg_date, end_date); skrrrahh(43)
  print("New Data writing to table")
} else {
  start_dates <- as.character(seq(ymd("2018-03-01"), beg_date, by = "weeks"))
  end_dates <- as.character(seq(ymd("2018-03-07"), end_date, by = "weeks"))
  
  game_dates <- tibble(start_dates, end_dates)
  
  game_dates <- game_dates %>% 
    filter(!month(start_dates) %in% c(11,12,1)) %>% 
    mutate_at(c("start_dates", "end_dates"), as.character)
  
  pitcher_rows <- list()
  
  for (i in seq(1,nrow(game_dates))) {
    dat <- scrape_statcast_savant_pitcher_all(start_dates[i], end_dates[i])
    pitcher_rows[[i]] <- dat
    Sys.sleep(30)
  }; skrrrahh(43)
  
  pitcher_data <- do.call(rbind, pitcher_rows)
  print("All the Data writing to table")
}

dbWriteTable(db, "Pitchers", pitcher_data, append = TRUE)

poolClose(db)
