addData <- function(data,row,tableName,db_path,primaryKey,dropdown_var,dropdown_query,mainTable_cols){
  ## add to the database table
  ## get appropriate Add data
  
  conn <- dbConnect(RSQLite::SQLite(),db_path)
  
  ## Need to get the dropdown data
  
  for(i in 1:length(dropdown_query)){
    if(!is.na(dropdown_var[i])){
      row <- row %>%
        left_join(dbGetQuery(conn,dropdown_query[i]),dropdown_var[i])  
    }
    
  }
  #drop_db = dbGetQuery(conn,dropdown_query)
  
  # browser()
  ## Need to increment the primary key
  pk_query <- sprintf("Select max(%s) AS V1 from %s ",primaryKey,tableName)

    newData <- row %>%
      mutate({{primaryKey}} := (dbGetQuery(conn,pk_query) %>% pull(V1))+1) %>%
      select(mainTable_cols)

  
  dbAppendTable(conn,tableName,newData)
  dbDisconnect(conn)
}

appendData <- function(data_to_append,tableName,db_path,dropdown_var,mainTable_cols){
  ## This function is for the uploaded data that needs to be appended
  ## similar functionality as compared to add data
  ## EXCEPT - Pit_ID values are assumed to be included in the data upload
  
  conn <- dbConnect(RSQLite::SQLite(),db_path)
  
  ## Need to get the dropdown data
  ## Need to increment the primary key
  
  newData <- data_to_append %>% select(-all_of(dropdown_var)) %>%
    select(mainTable_cols)
  dbAppendTable(conn,tableName,newData)
  dbDisconnect(conn)
}



deleteData <- function(data,row,tableName,db_path,primaryKey){
  ##  delete from database table
  conn <- dbConnect(RSQLite::SQLite(),db_path)
  
  query_DF <- row %>%
    #group_by(Pit_Id) %>%
    summarise(MaxID = max(eval(rlang::parse_expr(primaryKey)),na.rm = T),
              MinID = min(eval(rlang::parse_expr(primaryKey)),na.rm = T)) %>%
    ungroup()
  
  query <- sprintf(
    "DELETE  FROM %s where %s BETWEEN %s AND %s",
    tableName,
    primaryKey,
    query_DF$MinID,
    query_DF$MaxID
  )
  # query <- sprintf('DELETE from %s where %s',mainTable,primary_key_statement)
  dbExecute(conn,query)
  dbDisconnect(conn)
}

editData <- function(data,row,tableName,db_path,primaryKey,mainTable_cols){
  ## edit this particular database table
  conn <- dbConnect(RSQLite::SQLite(),db_path)
  # browser()
  # for(i in 1:length(dropdown_query)){
  #   if(!is.na(dropdown_var[i])){
  #     row <- row %>%
  #       left_join(dbGetQuery(conn,dropdown_query[i]),dropdown_var[i])  
  #   }
  #   
  # }
  ## Need to get the dropdown data
  #drop_db = dbGetQuery(conn,dropdown_query)
  ##Whenever we are in the edit mode, we do not need to do anything else here
  newData <- row %>%
    select(mainTable_cols)
  ## Need to increment the primary key
  query_DF <- newData %>%
    t() %>%
    as.data.frame() %>%
    tibble::rownames_to_column() %>%
    mutate(querystring = paste0(rowname,' = ',"'",V1,"'"))
  
  primary_key_statement = query_DF %>% filter(rowname == primaryKey) %>% pull(querystring)
  update_statement = query_DF %>% filter(rowname != primaryKey) %>% pull(querystring) %>% paste(collapse = ',')
  # browser()
  query <- sprintf(
    "UPDATE  %s SET %s where %s",
    tableName,
    update_statement,
    primary_key_statement
  )
  # Submit the update query and disconnect
  dbExecute(conn, query)
  dbDisconnect(conn)
}

## readData
loadData <- function(query,db_path,dropdown_var = NA) {
  # Connect to the database
  db <- dbConnect(RSQLite::SQLite(), db_path)
  # Construct the fetching query
  query <- sprintf(query)
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  # browser()
  if(length(dropdown_var)>0 & !any(is.na(dropdown_var))){
    for(i in 1:length(dropdown_var)){
      thisVar = dropdown_var[i]
      data <- data %>% mutate({{thisVar}} := factor(data[,{{thisVar}}]))
    }
    
    
  }
  saveRDS(data,here::here('latestData.RDS'))
  data
  
}
