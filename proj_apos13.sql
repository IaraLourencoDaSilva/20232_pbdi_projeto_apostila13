-- Exercício
--1.4.1 Exibe o número de estudantes maiores de idade

DO $$
DECLARE
	v_age INT;
	v_count INT;
BEGIN
	CALL sp_idade_maior(v_age, v_count);
	RAISE NOTICE 'Total: %', v_count;
END;
$$

DROP PROCEDURE IF EXISTS sp_idade_maior;
CREATE OR REPLACE PROCEDURE sp_idade_maior(
	IN age INT,
	OUT result_count INT
) LANGUAGE plpgsql
AS $$
BEGIN 
	IF age > 2 THEN 
		 SELECT COUNT(*) INTO result_count FROM tb_perfomance;
	END IF;
END;
$$

-- SELECT * FROM tb_performance;

-- CREATE TABLE tb_performance(
-- 	cod_per SERIAL PRIMARY KEY,
-- 	AGE INT,
-- 	GENDER INT,
-- 	SALARY INT,
-- 	PREP_EXAM INT,
-- 	NOTES INT,
-- 	GRADE INT
-- );