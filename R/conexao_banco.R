### CONEXAO AO BANCO DE DADOS

## Modo_1:
# Conectando ao banco de dados
conn <- DBI::dbConnect(RPostgres::Postgres(),
                  host = "direito.consudata.com.br",
                  user = "saulo",
                  dbname = "edicao3",
                  password = "xxxxxxxxx")

# Disconectando do banco de dados
DBI::dbDisconnect(conn)


## Modo_2:
# Outro forma de conectar
library(DBI)
conn <- dbConnect(RPostgres::Postgres(),
                       host = "localhost",
                       user = "postgres",
                       dbname = "postgres",
                       password = "xxxxxxxxx")

dbDisconnect(conn)


## Modo_3:
library(connections)

conn <- connection_open(RPostgres::Postgres(),
                        host = "direito.consudata.com.br",
                        dbname = "stf_saulo",
                        user = "saulo",
                        password = "xxxxxxxxx"
                        #password = Sys.getenv("DBPASSWORD") #não funcionou
                        )

