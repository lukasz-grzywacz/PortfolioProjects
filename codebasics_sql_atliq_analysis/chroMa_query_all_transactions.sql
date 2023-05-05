use gdb041;
select 
	s.date, s.product_code,
    p.product, p.variant, s.sold_quantity, 
    g.gross_price,
   round( g.gross_price * s.sold_quantity,2) as gross_price_total,
   pre.pre_invoice_discount_pct
from fact_sales_monthly s
join dim_product p
	on p.product_code = s.product_code
join fact_gross_price g
	on g.product_code = s.product_code and
    g.fiscal_year=YEAR(date_add(s.date, interval 4 month))
join fact_pre_invoice_discount pre
	on pre.customer_code = s.customer_code and
    pre.fiscal_year=get_fiscal_year(s.date)
where 
	customer_code=90002002 and
    get_fiscal_year(s.date) = 2021
order by date asc
limit 100000;





