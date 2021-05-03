### RESTRICOES NO POSTGRESQL

# Conexao
conn <- connections::connection_open(RPostgres::Postgres(),host="direito.consudata.com.br", dbname="stf_saulo",user="saulo",password="xxxxxxxxx")
con <- DBI::dbConnect(RPostgres::Postgres(),host="direito.consudata.com.br",dbname="stf_saulo",user="saulo",password="xxxxxxxxx")

# Link: https://direito.consudata.com.br/rpsql/restricoes/

# criando uma tabela vazia com CHECK
DBI::dbExecute(con, "
CREATE TABLE alunos (
nome text,
email text CHECK (email ~* '^.+@.+\\..+$'),
nota integer CHECK (nota < 10 AND nota >= 0),
data_matricula date,
data_nascimento date,
CHECK (data_matricula > data_nascimento)
);")

# inserindo valores na tabela
DBI::dbExecute(con, "
insert into alunos values ('jose','jose@consudata.com.br',5,'2020-01-19','1974-08-31');")

DBI::dbExecute(con, 
"insert into alunos values ('jose','jose@consudata.com.br',8,'1973-03-09','1974-08-31');")

DBI::dbExecute(con,
"insert into alunos values ('joao','jose@consudata.com.br',-2,'2020-03-19','1979-04-25');")

# remover tabela
dbRemoveTable(con, "alunos")

# Únicos
DBI::dbExecute(con, "
CREATE TABLE alunos (
nome text,
email text NOT NULL UNIQUE CHECK (email ~* '^.+@.+\\..+$'),
nota integer CHECK (nota < 10 AND nota >= 0),
data_matricula date,
data_nascimento date,
CHECK (data_matricula > data_nascimento)
);
")

DBI::dbExecute(con, "
insert into alunos values ('flávio', 'flavio@gmail.com', 6, '2021-04-24', '1996-01-04');               
")

DBI::dbExecute(con, "
insert into alunos values ('flávio', 'flavio@gmail.com', 6, '2021-04-24', '1996-01-04');               
")

DBI::dbExecute(con, "
insert into alunos values ('flávio', NULL, 6, '2021-04-24', '1996-01-04');               
")

# tentando inserir objeto duplicado do R no Postgre
df <- tibble(nome = 'flávio', email = NA_character_, nota = 6, 
             data_matricula = '2021-04-24', data_nascimento = '1996-01-04')

dbx::dbxInsert(con, "alunos", df)


dbRemoveTable(con, "alunos")

# Chave primária
dbExecute(con, "
CREATE TABLE alunos (
aluno_id integer PRIMARY KEY,
nome text,
email text NOT NULL CHECK (email ~* '^.+@.+\\..+$'),
nota integer CHECK (nota < 10 AND nota >= 0),
data_matricula date,
data_nascimento date,
CHECK (data_matricula > data_nascimento)
);          
")


# verificando os tipos dos campos 
library(rpsql)
d <- pg_d(con, tbl = "informacoes")

# Adicionando chave primaria 
dbExecute(con, "
          alter table informacoes add primary key (incidente);
          ")

# montando a query
q <- glue::glue("
select 
      informacoes.incidente, informacoes.assunto1 as assunto,
      informacoes.data_protocolo, informacoes.orgao_origem,
      informacoes.origem,
      detalhes.meio,
      detalhes.classe,
      detalhes.relator_atual
      from informacoes
      left join detalhes using (incidente);
")

df <- dbGetQuery(con, q)


#sugestão livro: https://use-the-index-luke.com/

# comandos bonus
dbx::dbxUpdate(conn, 'tabela', df, where_cols = c('data')) #atualiza os valores da tabela
dbx::dbxUpsert(conn, 'tabela', df, where_cols = c('data')) #substitui os valores ou não (vc decide)
