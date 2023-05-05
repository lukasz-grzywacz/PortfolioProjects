CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_year`(date_to_calculate date
) RETURNS int
    DETERMINISTIC
BEGIN
declare fiscal_year int;

set fiscal_year = YEAR(DATE_ADD(date_to_calculate, INTERVAL 4 MONTH));
RETURN fiscal_year;
END