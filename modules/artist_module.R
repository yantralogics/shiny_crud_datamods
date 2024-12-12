artist_ui <- function(id){
  page_fluid(
    theme = bs_theme(
      version = 5
    ),
    edit_data_ui(NS(id, id = "id")),
    verbatimTextOutput(NS(id,"result")),
    textOutput(NS(id,'msg')),
    fileInput(NS(id,"upload_data"),'Bulk_Edit_Data')
    
  )
}


artist_server <- function(id,artistData){
  ##Unpack data
  sqlite_path = artistData$sqlite_path
  mainTable = artistData$mainTable
  primaryKey = artistData$primaryKey
  mainTable_cols = artistData$mainTable_cols
  no_show_vars = artistData$no_show_vars
  dropdown_query = artistData$dropdown_query
  dropdown_var = artistData$dropdown_var
  read_query = artistData$read_query
  
  rv2 <- reactiveValues(uploadData = NULL)
  
  data_in <- reactive(loadData(read_query, sqlite_path, dropdown_var))
  
  moduleServer(id, function(input, output, session){
   rv <- reactiveVal()
   
   edited_r <- edit_data_server(
     id = "id",
     data_r = reactive(data_in()),
     add= T,
     update = T,
     delete= T,
     download_csv = T,
     download_excel = T,
     file_name_export = "downloaded_data_",
     var_edit = names(data_in())[!names(data_in()) %in% no_show_vars],
     n_column = 2,
     modal_size = 'l',
     modal_easy_close = T,
     callback_add = function(data,row){
       addData(data,row, mainTable,sqlite_path,primaryKey,dropdown_var,dropdown_query,mainTable_cols)
       return(T)
     },
     callback_delete = function(data,row){
       deleteData(data, row, mainTable, sqlite_path, primaryKey)
       return(T)
     },
     callback_update = function(data,row){
       editData(data, row, mainTable, sqlite_path, primaryKey, mainTable_cols)
       return(T)
     },
     reactable_options = list(
       defaultColDef = colDef(filterable = T),
       #columns = list(no_show_col1 = colDef(show=F)),
       bordered = T,
       compact = T,
       searchable = T,
       highlight =T
     ),
     use_notify = T
   )
   
   output$result <- renderPrint({
     str(edited_r())
   })
   
   observeEvent(rv(),{
     print('Data was updated')
     output$msg <- renderText({
       c('Data was updated')
     })
   })
   
   observeEvent(input$upload_data,{
     
     if(grepl('.xlsx',input$upload_data$datapath)){
       rv2$uploadData <- readxl::read_xlsx(input$upload_data$datapath)
     } else if(grepl('.csv',input$upload_data$datapath)){
       rv2$uploadData <- data.table::fread(input$upload_data$datapath)
     }
     
     showModal(
       modalDialog(
         
         tagList(
           h3('Sure you want to do this bro?'),
           DT::dataTableOutput(NS(id,"upload_data_add"))
         ),
         
         footer = tagList(
           modalButton('Cancel'),
           actionButton(NS(id, "upload_append_data","Append Data")),
           actionButton(NS(id, "upload_overwrite_data","Overwrite Data")),
         ),
         easyClose = T,
         fade = T,
         size = 'l'
       )
       )
   })
     output$upload_data_add<- DT::renderDataTable({
       rv2$uploadData %>% DT::datatable()
     })
     
     ## what happens when we append the data
     observeEvent(input$upload_append_data,{
       
       data_subset <- rv2$uploadData %>% select(names(data_in()))
       appendData(data_subset, mainTable, sqlite_path, dropdown_var, mainTable_cols)
       removeModal()
       shinyjs::refresh()
       
     })
     
     observeEvent(input$upload_overwrite_data,{
       
       data_subset <- rv2$uploadData %>% select(names(data_in()))
       
       deleteData(data= NA, row = data_in(), mainTable, sqlite_path, primaryKey)
       appendData(data_subset, mainTable, sqlite_path, dropdown_var, mainTable_cols)
       
       removeModal()
       shinyjs::refresh()
       
       
     })
   })

}