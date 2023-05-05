with cte1 as(
SELECT 
	s.market,
    c.region,
	round(sum(gross_price_total)/1000000,2) as gross_sales_mln
FROM net_sales s
join dim_customer c on s.customer_code = c.customer_code
where 
	fiscal_year = 2021
group by s.market,c.region),
cte2 as(
select 
	*,
	dense_rank() over(partition by region order by gross_sales_mln desc) as drnk
from cte1)
select * from cte2 where drnk <=2
;


