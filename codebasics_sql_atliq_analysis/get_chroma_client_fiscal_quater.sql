use gdb041;

select *,  get_fiscal_quater(date)
from fact_sales_monthly 
where 
	customer_code = 90002002
    and YEAR(DATE_ADD(date, INTERVAL 4 MONTH))=2021
    and get_fiscal_quater(date)="Q4"
order by date desc;
select * from dim_customer where customer like "%croma%"
and market = "india";