-- Процедура CLR
-- Инфляция (
CREATE OR REPLACE PROCEDURE update_prices(coeff_ FLOAT) AS
$$
plan = plpy.prepare("UPDATE courses SET price = price * ($1)", ["FLOAT"])
plpy.execute(plan, [coeff_])
$$ language plpython3u;

call update_prices(1.1);

