SET SERVEROUTPUT ON;
---------------------------------Test Requête 2.1----------------------------------------------
--TEST 1
BEGIN
    VerifQuantLivree(304, 202);
END;
/
--TEST 2.1
BEGIN
    VerifQuantLivree(302, 201);
END;
/ 
--TEST 2.2
BEGIN
    VerifQuantLivree(0, 1);
END;
/ 

-------------------------------Test Requête 2.2-----------------------------------------------

--TEST 1
DECLARE
    v_no_client NUMBER := 100; 
BEGIN
    PreparerLivraison(v_no_client);
END;
/
--TEST 2
DECLARE
    v_no_client NUMBER := 103; 
BEGIN
    PreparerLivraison(v_no_client);
END;
/
--TEST 3
DECLARE
    v_no_client NUMBER := 10011; 
BEGIN
    PreparerLivraison(v_no_client);
END;
/