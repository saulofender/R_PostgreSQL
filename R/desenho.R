library(DBI)
library(dbx)
library(dm)

# criando as tabelas vazias
dbCreateTable(con,"informacoes", informacoes)
dbCreateTable(con,"detalhes", detalhes)
dbCreateTable(con,"partes", partes)
dbCreateTable(con, "movimentacao",movimentacao)

# inserindo informacoes nas tabelas
dbx::dbxInsert(con,"informacoes",informacoes)
dbx::dbxInsert(con,"detalhes",detalhes)
dbx::dbxInsert(con,"partes", partes)
dbx::dbxInsert(con,"movimentacao",movimentacao)

# criando as restricoes 
dbExecute(con,"
          alter table informacoes add primary key (incidente)

          ")

dbExecute(con,"
          create index on detalhes (incidente)

          ")

dbExecute(con,"

          alter table detalhes add constraint informacoes_detalhes foreign key (incidente) references informacoes (incidente)

          ")


dbExecute(con,"
          create index on partes (incidente)

          ")

dbExecute(con,"

          alter table partes add constraint informacoes_detalhes foreign key (incidente) references informacoes (incidente)

          ")

dbExecute(con,"
          create index on movimentacao (incidente)

          ")

dbExecute(con,"

          alter table movimentacao add constraint informacoes_detalhes foreign key (incidente) references informacoes (incidente)

          ")


# desenho do esquema
desenho <- dm_from_src(con, table_names = c("informacoes","detalhes","partes","movimentacao"))

dm_draw(desenho, view_type = "all")



