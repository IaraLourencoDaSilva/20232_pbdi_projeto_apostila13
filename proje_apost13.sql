-- Exercício
-- 1.5.3 Devolve o percentual de alunos que se preparam pelo menos um pouco para os
-- “midterm exams” e que são aprovados (grade > 0).

DO $$
DECLARE
    resultado NUMERIC(10,2);
BEGIN
    resultado := percent_aprov_com_prep_exam();
    RAISE NOTICE 'Percentual de alunos que se preparam para "midterm exams" e são aprovados: %', resultado;
END;
$$;

CREATE OR REPLACE FUNCTION percent_aprov_com_prep_exam()
RETURNS FLOAT LANGUAGE plpgsql
AS $$
DECLARE
    total_estudantes INT;
    aprovados_com_prep_exam INT;
BEGIN
    -- Alunos que se preparam para o exame
    SELECT COUNT(*) INTO total_estudantes FROM tb_performance WHERE PREP_EXAM > 0;
    -- Alunos aprovados no exames 
    SELECT COUNT(*) INTO aprovados_com_prep_exam FROM tb_performance WHERE PREP_EXAM > 0 AND GRADE > 0;
    -- Alunos aprovados com preparação
    RETURN aprovados_com_prep_exam * 100.0 / total_estudantes;
END;
$$;


-- 1.5.2 Responde (devolve boolean) se é verdade que, entre os estudantes que fazem
-- anotações pelo menos algumas vezes durante as aulas, pelo menos 70% são aprovados
-- (grade > 0).
DO $$
DECLARE
    resultado BOOLEAN;
BEGIN
    resultado := percent_aprovados_com_anotacoes();
    RAISE NOTICE 'Pelo menos 70%% dos estudantes com anotações são aprovados? %', resultado;
END;
$$

CREATE OR REPLACE FUNCTION percent_aprovados_com_anotacoes()
RETURNS BOOLEAN LANGUAGE plpgsql
AS $$
DECLARE
    total_estudantes INT;
    aprovados_com_anotacoes INT;
BEGIN
    -- O total de alunos que fazem anotações
    SELECT COUNT(*) INTO total_estudantes FROM tb_performance WHERE NOTES > 0;
    -- O total de alunos aprovados com anotações
    SELECT COUNT(*) INTO aprovados_com_anotacoes FROM tb_performance WHERE NOTES > 0 AND GRADE > 0;
    -- 70% aprovados
    RETURN aprovados_com_anotacoes * 100.0 / total_estudantes >= 70;
END;
$$


-- 1.5.1 Responde (devolve boolean) se é verdade que todos os estudantes de renda acima de
-- 410 são aprovados (grade > 0).

DO $$
DECLARE
    resultado BOOLEAN;
BEGIN
    resultado := todos_acima_410();
    RAISE NOTICE 'Todos os estudantes de renda acima de 410 são aprovados? %', resultado;
END;
$$


CREATE OR REPLACE FUNCTION todos_acima_410()
RETURNS BOOLEAN LANGUAGE plpgsql
AS $$
DECLARE
    renda_acima_410 BOOLEAN;
BEGIN
    SELECT EXISTS (SELECT 1 FROM tb_performance WHERE salary > 410 AND grade <= 0) INTO renda_acima_410;
    RETURN NOT renda_acima_410;
END;
$$;


--  1.4.3 Recebe um sexo como parâmetro em modo IN e utiliza oito parâmetros em modo OUT
-- para dizer qual o percentual de cada nota (variável grade) obtida por estudantes daquele
-- sexo.
DO $$
DECLARE
    v_percentual_nota_1 FLOAT;
    v_percentual_nota_2 FLOAT;
    v_percentual_nota_3 FLOAT;
    v_percentual_nota_4 FLOAT;
    v_percentual_nota_5 FLOAT;
    v_percentual_nota_6 FLOAT;
    v_percentual_nota_7 FLOAT;
    v_percentual_nota_8 FLOAT;
BEGIN
    CALL sp_percentual_nota(1, v_percentual_nota_1, v_percentual_nota_2, v_percentual_nota_3, v_percentual_nota_4, v_percentual_nota_5, v_percentual_nota_6, v_percentual_nota_7, v_percentual_nota_8);
    RAISE NOTICE 'Percentual da nota 1: %', v_percentual_nota_1;
    RAISE NOTICE 'Percentual da nota 2: %', v_percentual_nota_2;
	RAISE NOTICE 'Percentual da nota 3: %', v_percentual_nota_3;
	RAISE NOTICE 'Percentual da nota 4: %', v_percentual_nota_4;
	RAISE NOTICE 'Percentual da nota 5: %', v_percentual_nota_5;
	RAISE NOTICE 'Percentual da nota 6: %', v_percentual_nota_6;
	RAISE NOTICE 'Percentual da nota 7: %', v_percentual_nota_7;
	RAISE NOTICE 'Percentual da nota 8: %', v_percentual_nota_8;
END;
$$;

DROP PROCEDURE IF EXISTS sp_percentual_nota;
CREATE OR REPLACE PROCEDURE sp_percentual_nota(
	IN sexo_param INT,
	OUT percentual_nota_1 FLOAT,
    OUT percentual_nota_2 FLOAT,
    OUT percentual_nota_3 FLOAT,
    OUT percentual_nota_4 FLOAT,
    OUT percentual_nota_5 FLOAT,
    OUT percentual_nota_6 FLOAT,
    OUT percentual_nota_7 FLOAT,
    OUT percentual_nota_8 FLOAT
) LANGUAGE plpgsql 
AS $$
BEGIN
    -- Calcular o percentual de cada nota para o sexo especificado
    SELECT COUNT(*) * 100.0 /(SELECT COUNT(*) FROM tb_performance) INTO percentual_nota_1 FROM tb_performance WHERE gender = sexo_param AND grade = 1;
    SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tb_performance) INTO percentual_nota_2 FROM tb_performance WHERE gender = sexo_param AND grade = 2;
    SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tb_performance) INTO percentual_nota_3 FROM tb_performance WHERE gender = sexo_param AND grade = 3;
    SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tb_performance) INTO percentual_nota_4 FROM tb_performance WHERE gender = sexo_param AND grade = 4;
    SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tb_performance) INTO percentual_nota_5 FROM tb_performance WHERE gender = sexo_param AND grade = 5;
    SELECT COUNT(*) * 100.0 /(SELECT COUNT(*) FROM tb_performance) INTO percentual_nota_6 FROM tb_performance WHERE gender = sexo_param AND grade = 6;
    SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tb_performance)INTO percentual_nota_7 FROM tb_performance WHERE gender = sexo_param AND grade = 7;
    SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tb_performance) INTO percentual_nota_8 FROM tb_performance WHERE gender = sexo_param AND grade = 8;
END;
$$

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