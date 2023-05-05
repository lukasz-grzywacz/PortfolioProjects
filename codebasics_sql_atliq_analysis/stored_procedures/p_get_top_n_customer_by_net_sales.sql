CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_customer_by_net_sales`(
	in_market varchar(50),
	in_fiscal_year int,
    in top_n int
)
BEGIN
SELECT 
	c.customer,
    round(sum(net_sales)/1000000,2) as net_sales_mln
FROM net_sales s
join dim_customer c on s.customer_code = c.customer_code 
where fiscal_year = in_fiscal_year and s.market = in_market
group by c.customer
order by net_sales_mln desc
limit top_n;
END