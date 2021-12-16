with hotels as (
select * from Hotel_Project..['2018$']
union
select * from Hotel_Project..['2019$']
union
select * from Hotel_Project..['2020$'])

/*
select
arrival_date_year, hotel,
round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as Revenue 
from hotels
group by arrival_date_year, hotel

select * from Hotel_Project..market_segment$
*/

select *
from hotels
left join Hotel_Project..market_segment$
on hotels.market_segment = market_segment$.market_segment
left join Hotel_Project..meal_cost$ 
on Hotel_Project..meal_cost$.meal = hotels.meal
