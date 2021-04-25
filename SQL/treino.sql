-- !preview conn=conn


-- SELECT incidente from informacoes limit 5

-- SELECT * FROM informacoes limit 5

/* SELECT incidente, assunto1 assunto
FROM informacoes */

--- QUALIFICANDO UMA COLUNA ---
/* SELECT informacoes.incidente, informacoes.assunto1 assunto, detalhes.classe
FROM informacoes
INNER JOIN detalhes using (incidente) */

---

--- SELECAO COM FILTRO ---
/* SELECT *
from detalhes
where classe = 'HC' */

/* SELECT *
from "detalhes"
where classe = 'AI' */

/* SELECT *
from "detalhes"
where classe = 'AI'
and relator_atual = 'MINISTRO PRESIDENTE' */

/* SELECT *
from "detalhes"
where classe = 'AI'
OR relator_atual = 'MINISTRO PRESIDENTE' */



/* JOINS NO POSTGRESQL */

-- SELECT * FROM d1 INNER JOIN d2 USING (a)

--Juntando tabelas com Subquery
-- SELECT * FROM d1 INNER JOIN (SELECT a, b AS b_y FROM d2) AS foo USING (a)

--Subquery: outra forma de juntar é criando uma tabela temporária (CMD)
with k as (

select a, b as b_y
from d2

)

select * from d1
inner join k using(a)





