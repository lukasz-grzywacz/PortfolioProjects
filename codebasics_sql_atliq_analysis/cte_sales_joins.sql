with cte1 as(
select 
	s.date, 
    s.product_code,
    p.product, p.variant, 
    s.sold_quantity, 
    g.gross_price,
   round( g.gross_price * s.sold_quantity,2) as gross_price_total,
   pre.pre_invoice_discount_pct as pre_invoice_discount_pct
from fact_sales_monthly s
join dim_product p
	on p.product_code = s.product_code
join dm_date dt
	on dt.calendar_date = s.date
join fact_gross_price g
	on g.product_code = s.product_code and
    g.fiscal_year=s.fiscal_year
join fact_pre_invoice_deductions pre
	on pre.customer_code = s.customer_code and
    pre.fiscal_year=s.fiscal_year
where s.fiscal_year = 2021)
select *,
	   gross_price_total - (gross_price_total * pre_invoice_discount_pct) as net_invoice_sales
 from cte1;


