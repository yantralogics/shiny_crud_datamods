library(DBI)

sqlpath <- here::here('db/sqldb.db')

conn <- DBI::dbConnect(RSQLite::SQLite(),sqlpath)
DBI::dbListTables(conn)
artists = dbReadTable(conn,"Artist")
albums = dbReadTable(conn,"Album")
customer = dbReadTable(conn,"Customer")
employee = dbReadTable(conn,"Employee")
genre = dbReadTable(conn,'Genre')
playlist = dbReadTable(conn,"Playlist")
mediaType = dbReadTable(conn,"MediaType")
playlistTrack = dbReadTable(conn,"PlayListTrack")
track = dbReadTable(conn,"Track")

DBI::dbDisconnect(conn)
