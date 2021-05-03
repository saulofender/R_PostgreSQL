-- !preview conn=conn


-- SELECT incidente from informacoes limit 5;

-- SELECT * FROM informacoes limit 5;

/* SELECT incidente, assunto1 assunto
FROM informacoes; */

--- QUALIFICANDO UMA COLUNA ---
/* SELECT informacoes.incidente, informacoes.assunto1 assunto, detalhes.classe
FROM informacoes
INNER JOIN detalhes using (incidente); */

---

--- SELECAO COM FILTRO ---
/* SELECT *
from detalhes
where classe = 'HC'; */

/* SELECT *
from "detalhes"
where classe = 'AI'; */

/* SELECT *
from "detalhes"
where classe = 'AI'
and relator_atual = 'MINISTRO PRESIDENTE'; */

/* SELECT *
from "detalhes"
where classe = 'AI'
OR relator_atual = 'MINISTRO PRESIDENTE'; */



/* JOINS NO POSTGRESQL */

-- SELECT * FROM d1 INNER JOIN d2 USING (a);

--Juntando tabelas com Subquery
-- SELECT * FROM d1 INNER JOIN (SELECT a, b AS b_y FROM d2) AS foo USING (a);

--Subquery: outra forma de juntar é criando uma tabela temporária (CTE)
/* with k as (

select a, b as b_y
from d2

)

select * from d1
inner join k using(a); */

-------------------------------------------------------------------------------
--- 24/04/21

---INNER JOIN

/* SELECT *
FROM d1
INNER JOIN d2 USING(a); */

-- OU ENTAO, O MAIS RECOMENDADO FAZER: 

/* WITH cte1 AS (
SELECT a, b AS b_y 
FROM d2
)
SELECT a, b, c
FROM d1
INNER JOIN cte1 USING(a); */


---LEFT JOIN

/* SELECT * FROM d1 LEFT OUTER JOIN d2 USING(a); */

/* SELECT d1.a, d2.b, c FROM d1 LEFT OUTER JOIN d2 ON d1.a = d2.a; */

/* SELECT d1.a a_x,
       d1.b a_x,
       d1.c,
       d2.a AS a_y,
       d2.b AS a_y
FROM d1 LEFT OUTER JOIN d2 ON d1.a = d2.a AND d1.b = d2.b; */

/* SELECT * FROM d1 LEFT JOIN d2 ON d1.a = d2.a WHERE d2.b = 3; */


---ANTI JOIN 

/* SELECT * FROM d1 
WHERE NOT EXISTS(
SELECT  -- Não precisa selecionar coluna alguma.
FROM d2
WHERE d2.a = d1.a); */

/* SELECT *
FROM d1
WHERE a NOT IN (
SELECT a
FROM d2
WHERE a IS NOT NULL); */


---SELF JOIN
SELECT f.nome funcionario, s.nome supervisor
FROM func f 
JOIN func s ON s.id_funcionario = f.id_supervisor;
