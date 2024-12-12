artistData <- list(
  sqlite_path = here::here('db/sqldb.db'),
  ## The primary table to look at editing 
  mainTable = 'Artist',
  ## Primary key of the table to edit 
  primaryKey = 'ArtistId',
  ## list of columns for the mainTable
  mainTable_cols = c('ArtistId','Name'),
  ## no show vars 
  no_show_vars = c('ArtistId'),
  ## list of variables that will be shown as the dropdown - best to have a table for that 
  dropdown_query = NA,
  
  ## the read query will be different from the write query - since we might need to show the user what we need 
  read_query = "select * from Artist",
  dropdown_var = NA
)