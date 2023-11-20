-- Exercício

-- 1.4.2 Exibe o percentual de estudantes de cada sexo.

DO $$
DECLARE
    v_percentual_feminino FLOAT;
    v_percentual_masculino FLOAT;
BEGIN
    CALL sp_percentual_sexo(v_percentual_feminino, v_percentual_masculino);
    RAISE NOTICE 'Percentual do sexo feminino: %', v_percentual_feminino;
    RAISE NOTICE 'Percentual do sexo masculino: %', v_percentual_masculino;
END;
$$



DROP PROCEDURE IF EXISTS sp_percentual_sexo;
CREATE OR REPLACE PROCEDURE sp_percentual_sexo(
    OUT percentual_feminino FLOAT,
    OUT percentual_masculino FLOAT
) LANGUAGE plpgsql
AS $$
BEGIN
    -- Calcular o percentual de estudantes do sexo feminino
    SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tb_performance) INTO percentual_feminino FROM tb_performance WHERE gender = 1;
    -- Calcular o percentual de estudantes do sexo masculino
    SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tb_performance) INTO percentual_masculino FROM tb_performance WHERE gender = 2;
END;
$$


--1.4.1 Exibe o número de estudantes maiores de idade

DO $$
DECLARE
	v_count INT;
BEGIN
	CALL sp_idade_maior(v_count);
	RAISE NOTICE 'Total: %', v_count;
END;
$$

DROP PROCEDURE IF EXISTS sp_idade_maior;
CREATE OR REPLACE PROCEDURE sp_idade_maior(
	OUT result_count INT
) LANGUAGE plpgsql
AS $$
BEGIN 
	SELECT COUNT(*) INTO result_count FROM tb_performance WHERE age > 1;
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