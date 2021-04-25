library(DBI)

# Modo_1: Conectando ao banco de dados
conn <- DBI::dbConnect(RPostgres::Postgres(),
                       host = "direito.consudata.com.br",
                       dbname = "stf_saulo",
                       user = "saulo",
                       password = "rcdpost!gres")

# Modo_2: Conectando ao banco de dados
# conn <- DBI::dbConnect(RPostgres::Postgres(),
#                        host="localhost",
#                        dbname="stf_saulo",
#                        user=Sys.getenv("DBUSER"),
#                        password=Sys.getenv("DBPASSWORD"))


# Criando banco de Dados
dbExecute(conn,"create database stf_saulo") #rodar uma vez para criar o banco


# Modo_1: Listar as conexoes ao banco
#lista <- DBI::dbGetQuery(conn,"select datname nome,datcollate,datctype,pg_encoding_to_char(encoding),datacl access_privileges from pg_database")

# Modo_2: Listar as conexoes ao banco
pg_l <- function(conn){

  DBI::dbGetQuery(conn,"SELECT d.datname as Name,
       pg_catalog.pg_get_userbyid(d.datdba) as Owner,
       pg_catalog.pg_encoding_to_char(d.encoding) as Encoding,
       d.datcollate as Collate,
       d.datctype as Ctype,
       pg_catalog.array_to_string(d.datacl, E'\n') AS Access FROM pg_catalog.pg_database d ORDER BY 1")
}

lista <- pg_l(conn)


## Enviando as tabelas do R para o banco

#informacoes <- as.data.frame(informacoes)
dbWriteTable(conn,"informacoes", informacoes) #caso de erro transforma em "as.data.frame".

#detalhes <- as.data.frame(detalhes)
dbWriteTable(conn,"detalhes", detalhes)

#movimentacao <- as.data.frame(movimentacao)
dbWriteTable(conn,"movimentacao", movimentacao)

#partes <- as.data.frame(partes)
partes <- dbWriteTable(conn,"partes", partes)

# Visualizando as tabelas que foram enviadas para o banco
tabelas <- dbListTables(conn)

# finalizar conexao ao banco
dbDisconnect(conn)


dbExecute #executa uma tarefa no banco, mas não retornar o resultado
dbGetQuery #executa uma tarefa no banco, e retornar o resultado
dbWriteTable #envia uma tabela/dataframe para o banco

