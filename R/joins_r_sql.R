# JOINS NO R E NO POSTGRESQL

library(dplyr)
library(tibble)
library(pander)
library(DBI)

# link: https://rpg.consudata.com.br/posts/2021-01-03-joins-no-r-e-no-postgresql/

# Conexao
conn <- connections::connection_open(RPostgres::Postgres(),host="direito.consudata.com.br", dbname="stf_saulo",user="saulo",password="xxxxxxxxx")
con <- DBI::dbConnect(RPostgres::Postgres(),host="direito.consudata.com.br",dbname="stf_saulo",user="saulo",password="xxxxxxxxx")


tabelas <- c("df", "dd", "dk", "df1", "df2", "df3")

# Removendo tabelas do banco
walk(tabelas, ~{

  dbRemoveTable(conn, .x)

})


set.seed(035)
d1 <- tibble::tibble(a=sample(1:5,5),
                     b=sample(c(NA_real_,6:9),5),
                     c=sample(c(NA_character_,sample(letters,4)),5))


set.seed(936)
d2 <- tibble::tibble(a= sample(c(NA_real_,2:7),7),b=sample(c(NA_real_,3:8),7))


# inner_join
d3 <- inner_join(d1,d2,by = "a")

d3 <- d3 %>%
  mutate(b = coalesce(b.x,b.y))
pander::pander(d3)

d3 <- d3 %>%
  mutate(b = coalesce(b.x,b.y),
         b.x = NULL,
         b.y = NULL)
pander::pander(d3)

inner_join(d1,d2,by=c("a","b")) %>%
pander::pander()

d4 <- d1 %>%
  select(aa = a, everything())

inner_join(d4,d2,by=c("aa"="a"))


# left_join e right_join
left_join(d1,d2, by = "a")

right_join(d1,d2, by="a")

d2 %>%
  filter(a !=6 ) %>%
  right_join(d1, by = "a")

left_join(d1,d2, by = "a",keep = TRUE)


# full_join
full_join(d1,d2, by = "a")

full_join(d1,d2, by = c("a","b"))


# semi_join
semi_join(d1,d2, by = "a") #mantém no df "d1" só os que são correspondentes no df "d2"

d1 %>%                #semi_join é equivalente a operacao "%in%"
  filter(a %in% d2$a) #deve-se usar "%in%" quando for filtrar correspondentes em um "vetor"


# anti_join
anti_join(d1,d2, by = "a")

d1 %>%
  filter(!a %in% d2$a) #anti_join é equivalente a esta operacao "! %in%"


# self_join (joins de uma tabela com ela mesma)
func <- tibble::tibble(
  
  id_funcionario = c(1:8),
  nome = c("Heloísa","Daniel","Thandara","Naiara","Patrick","Haydee","Julia","Fabio"),
  id_supervisor = c(NA_real_,1,1,2,2,3,3,3)
)

dplyr::inner_join(func,func,by = c("id_supervisor"= "id_funcionario")) %>%
  dplyr::select(funcionario = nome.x, supervisor = nome.y)

#___________________________________________________________________________


## JOINS COM POSTGRE

# enviando as tabelas para o banco
iwalk(list(d1 = d1, d2 = d2), ~{

  dbWriteTable(conn, .y, .x)

})

##obs: ir para o arquivo "treino.sql"
#remotes::install_github("jjesusfilho/rpsql")

## AULA: 24/04/21 ___________
# INNER JOIN
j <- DBI::dbGetQuery(conn, "
WITH cte1 AS (

SELECT a, b AS b_y 
FROM d2

)

SELECT a, b, c
FROM d1
INNER JOIN cte1 USING(a);")


# LEFT JOIN 
j <- dbGetQuery(conn, "
SELECT d1.a, d2.b, c 
FROM d1 
LEFT OUTER JOIN d2 
ON d1.a = d2.a;")


# ANTI JOIN 
j <- dbGetQuery(conn, "
SELECT * FROM d1 
WHERE NOT EXISTS(
  SELECT  -- Não precisa selecionar coluna alguma.
  FROM d2
  WHERE d2.a = d1.a);")


# SELF JOIN
dbWriteTable(con, "func", func) #enviando a tabela para o Postgre

func <- dbGetQuery(conn, "
SELECT f.nome funcionario, s.nome supervisor
FROM func f 
JOIN func s ON s.id_funcionario = f.id_supervisor;")


