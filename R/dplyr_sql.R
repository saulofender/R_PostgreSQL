# CONECTA AO BANCO
conn <- DBI::dbConnect(RPostgres::Postgres(),host="direito.consudata.com.br",dbname="stf_saulo",user="saulo",password="rcdpost!gres")

# CONECTA AO BANCO E MOSTRA A CONEXAO COM AS TABELAS EM CONNECTIONS
conn <- connections::connection_open(RPostgres::Postgres(),
                                     host = "direito.consudata.com.br",
                                     dbname = "stf_saulo",
                                     user = "saulo",
                                     password = "rcdpost!gres")


# PACOTES
library(tidyverse)
library(DBI)
library(dbx)


# ATRIBUINDO TABELA A UM OBJETO - POSTGRES
dd <- dbGetQuery(conn, "select * from detalhes")

# FILTRO - DPLYR
dd %>%
  slice(1:2)

# FILTRO - POSTGRES (NAO RECOMENDADO)
dbGetQuery(conn,"select * from detalhes limit 2")

# FILTRO - POSTGRES (RECOMENDADO)
dbGetQuery(conn,"
           select * from detalhes
           order by incidente
           limit 2
           ")

# ADICIONAR COLUNA - POSTGRES
dbExecute(conn,"

          alter table detalhes add column detalhes_id serial

          ")

# FILTRO ORDENADO - POSTGRES (MAIS RECOMENDADO)
dbGetQuery(conn,"
           select * from detalhes
           order by detalhes_id
           limit 2
           ")

# EXCLUIR COLUNA - POSTGRES
dbExecute(conn,"alter table detalhes drop column detalhes_id")


# SELECAO COM FILTRO E CONDICAO - POSTGRES
dd <- dbGetQuery(conn,"

                select * from detalhes
                where classe != 'AI'

                ")

dd <- dbGetQuery(conn,"

                select * from detalhes
                where classe <> 'AI'

                ")



query <- dbSendQuery(conn,"
                 select * from
                 detalhes
                 where classe = 'AI'
                 or relator_atual = 'MINISTRO PRESIDENTE'
                     ")

dd <- dbFetch(query, n = 20)

dk <- dbFetch(query, n = 20)

# EMPILHAR LINHAS - DPLYR
df <- bind_rows(dd,dk)

# EMPILHAR LINHAS - POSTGRES
dbWriteTable(conn,"dd", dd)  #ENVIA TABELAS PARA O BANCO

dbWriteTable(conn,"dk", dk)

# BIND_ROWS - POSTGRES
dbExecute(conn,"
          create table df as
          (
          select * from dd
          union
          select * from dk
          )
          ")

# EXCLUIR TABELAS DO BANCO
dbExecute(conn,"drop table dd")
dbExecute(conn,"drop table dk")
dbExecute(conn,"drop table df")


# CRIANDO LISTA DE TABELAS
dfs <- list(dd = dd, df = df, dk = dk)

iwalk(dfs,~{                  # PEGA OS OBJETOS COMO PRIMEIRO ARGUMENTO (dd, df, dk)
                              # E OS NOMES COMO SEGUNDO ARGUMENTO (dd, df, dk)

  dbWriteTable(conn, .y, .x)  # .y É O NOME DO DATAFRAME, .X É O DATAFRAME


})


# CRIANDO TABELAS NO R
df1 <- data.frame(a = 1:5,
                  b = letters[1:5])

df2 <- data.frame(c = 6:10,
                  d = letters[6:10])

# EMPILHAR COLUNAS - DPLYR
df3 <- bind_cols(df1,df2)


# CRIANDO TABELAS NO BANCO - POSTGRES
dbCreateTable(conn,"df1", df1) # AS TABELAS ESTAO VAZIAS
dbCreateTable(conn,"df2", df2)

# INSERINDO UM ID NAS TABELAS
dbExecute(conn,"alter table df1 add column id serial")
dbExecute(conn,"alter table df2 add column id serial")

# POPULA TODAS AS LINHAS DAS TABELAS
dbWriteTable(conn, "df1", df1, append = TRUE)
dbWriteTable(conn, "df2", df2, append = TRUE)

# APAGA TODAS AS LINHAS DAS TABELAS
dbExecute(conn,"truncate df1")
dbExecute(conn,"truncate df2")

# POPULA TODAS AS LINHAS DAS TABELAS COM RAPIDEZ (ESSENCIAL PARA BASES GIGANTES)
dbxInsert(conn,"df1", df1)
dbxInsert(conn,"df2", df2)

# EMPILHAR COLUNAS - POSTGRES
dbExecute(conn,"
          create table df3 as
          (
          select df1.id, df1.a, df1.b, df2.c, df2.d
          from df1, df2
          where df1.id = df2.id
          )
          ")


# Produto cartesiano (expand.grid) - R
df <- expand.grid(list(v1=1:2,
                       v2=c("a","b","c")))

# Produto cartesiano (across) - Dplyr
df <- purrr::cross_df(list(v1=1:2,
                           v2=c("a","b","c")))

# Produto cartesiano - Postgre
df <- dbGetQuery(conn,"select a, d
                     from df1, df2
                 ")


