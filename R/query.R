library(connections)
library(tidyverse)
library(DBI)
conn <- connection_open(RPostgres::Postgres(),
                        host = "direito.consudata.com.br",
                        dbname = "stf_saulo",
                        user="saulo",
                        #password=Sys.getenv("DBPASSWORD")
                        password = "rcdpost!gres"
                        )

# Modo dplyr (não recomendado)
df <- tbl(conn,"informacoes") %>%
      select(incidente,assunto = assunto1) %>%
      collect()

# Modo Getquery (recomendado)
df <- dbGetQuery(conn,"
                 select incidente, assunto1 as assunto
                 from informacoes
                 ")


selecionar <- function(conn = NULL, tbl, ...){

    dplyr::tbl(conn, tbl) %>%
    dplyr::select(...) %>%
    dplyr::collect()

}

df <- selecionar(conn = conn, "detalhes", incidente, sigilo, meio)
df <- selecionar(conn = conn, "detalhes", 1,2)


## filtrar (where)

df <- dbGetQuery(conn,"
                 select * from
                 detalhes
                 where classe = 'AI'
                 or relator_atual = 'MINISTRO PRESIDENTE'
                 ")


df <- tbl(conn,"detalhes") %>%
      filter(classe == "AI" | relator_atual == "MINISTRO PRESIDENTE") %>%
      collect()


query <- dbSendQuery(conn,"
                 select * from
                 detalhes
                 where classe = 'AI'
                 or relator_atual = 'MINISTRO PRESIDENTE'
                     ")
dd <- dbFetch(query, n = 20)


dk <- dbFetch(query, n = 20)



