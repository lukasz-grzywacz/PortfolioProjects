CREATE FUNCTION `get_fiscal_quater`
(date_to_calculate date,
fiscal_year_drop integer)
RETURNS char(2)
BEGIN
set date_to_calculate_fiscal = YEAR(DATE_ADD(date, INTERVAL 4 MONTH));
set quater = QUATER(date_to_calculate_fiscal);
RETURN 'Q' + quater;
END
