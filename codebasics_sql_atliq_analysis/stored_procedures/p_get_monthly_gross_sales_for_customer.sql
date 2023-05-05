CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monthly_gross_sales_for_customer`(
	in_customer_codes text
)
BEGIN
	select
            s.date as fiscal_year,
            sum(round(sold_quantity*g.gross_price,2)) as yearly_sales
	from fact_sales_monthly s
	join fact_gross_price g
	on 
	    g.fiscal_year=YEAR(date_add(s.date, interval 4 month)) and
	    g.product_code=s.product_code
	where
	    FIND_IN_SET(s.customer_code, in_customer_codes)>0
	group by s.date
	order by fiscal_year; 
END