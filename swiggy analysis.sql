SELECT * FROM `swiggydata.sql`.swiggy;

QUESTIONS

01 HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?
02 WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?
02 HOW MANY RESTAURANTS SELL( HAVE WORD "PIZZA" IN THEIR NAME)?
03 WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?
05 WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?
06 WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?
07 FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE. 
08 FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL    
   RESTAURANTS TOGETHER.
09 RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.
10 WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?
11 LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME
12 WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?
13 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?
14 WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?
15 Determine the Most Expensive and Least Expensive Cities for Dining:
16 Calculate the Rating Rank for Each Restaurant Within Its City
*/


-- 01 HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?


select count(distinct restaurant_name) high_rated_restaurant_count
from swiggy
where rating >4.5;

-- 02  WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?

select City
from swiggy
group by city
order by count(*) desc
limit 1;


02 HOW MANY RESTAURANTS SELL( HAVE WORD "PIZZA" IN THEIR NAME)?

select count(distinct restaurant_name)as count
from swiggy
where
restaurant_name like '%PIZZA%'

03 WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?

select cuisine,count(*)as count
from swiggy
group by cuisine
order by 2 desc 
limit 1;

05 WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?

select city,round(avg(rating),1)as avg_rating
from swiggy
group by city

06 WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?

select restaurant_name,max(price) as hisghest_price
from swiggy
where menu_category="RECOMMENDED"
group by restaurant_name


-- 07 FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS
-- THAT OFFER CUISINE OTHER THAN INDIAN CUISINE. 

select distinct restaurant_name,cost_per_person
from swiggy where cuisine<>'Indian'
order by cost_per_person desc
limit 5;


-- 08 FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST 
-- WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL    
-- RESTAURANTS TOGETHER.
   
   select distinct restaurant_name,cost_per_person
   FROM swiggy
   where cost_per_person>(select avg(cost_per_person)
   from swiggy)
   ;
   
--   09 RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME 
-- BUT ARE LOCATED IN DIFFERENT CITIES.


select distinct t1.restaurant_name,t1.city,t2.city
from swiggy t1 join swiggy t2 
on t1.restaurant_name=t2.restaurant_name and
t1.city<>t2.city;

-- 10 WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN
--  THE 'MAIN COURSE' CATEGORY?

SELECT restaurant_name,count(item)as item_count
from swiggy
where menu_category="main course"
group by restaurant_NAME
order by 2 desc
limit 1;

-- 11 LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN 
-- IN ALPHABETICAL ORDER OF RESTAURANT NAME


select restaurant_name,
count(case when veg_or_nonveg='veg' then 1 else 0 end )/count(*)*100 as pct
from swiggy
group by 1
order by 1 asc;

-- 12 WHICH IS THE RESTAURANT PROVIDING THE LOWEST 
-- AVERAGE PRICE FOR ALL ITEMS?


select distinct restaurant_name,
avg(price) as average_price
from swiggy group by restaurant_name
order by average_price limit 1;


-- 13 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?

select restaurant_name,count(distinct menu_category)
from swiggy
group by 1
order by 2 desc
limit
5;



-- 14 WHICH RESTAURANT PROVIDES THE 
-- HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?

select restaurant_name,count(case when veg_or_nonveg='non-veg' then 1 end )/count(*) *100 as non_veg_pct 
from swiggy
group by 1
order by 2 desc limit 1



-- 15 Determine the Most Expensive and Least Expensive Cities for Dining:


WITH CityExpense AS (
    SELECT city,
        MAX(cost_per_person) AS max_cost,
        MIN(cost_per_person) AS min_cost
    FROM swiggy
    GROUP BY city
)
SELECT city,max_cost,min_cost
FROM CityExpense
ORDER BY max_cost DESC;


-- 16 Calculate the Rating Rank for Each Restaurant Within Its City


WITH RatingRankByCity AS (
    SELECT distinct
        restaurant_name,
        city,
        rating,
        DENSE_RANK() OVER (PARTITION BY city ORDER BY rating DESC) AS rating_rank
    FROM swiggy
)
SELECT
    restaurant_name,
    city,
    rating,
    rating_rank
FROM RatingRankByCity
WHERE rating_rank = 1;


select * from swiggy;