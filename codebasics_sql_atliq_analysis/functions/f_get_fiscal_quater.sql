CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_quater`(date_to_calculate date
) RETURNS char(2) CHARSET latin1
    DETERMINISTIC
BEGIN
declare date_to_calculate_fiscal date;
declare quater char(2);

set date_to_calculate_fiscal = DATE_ADD(date_to_calculate, INTERVAL 4 MONTH);
set quater = QUARTER(date_to_calculate_fiscal);
RETURN concat('Q',quater);
END