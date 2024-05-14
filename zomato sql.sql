use  Zomato;
ALTER TABLE main MODIFY datekey varchar(250);
select *from main;


#2 Build a Calendar Table using the Columns Datekey_Opening 

select datekey,year(datekey) Year,
month(datekey)  Month,
day(datekey) Day,
concat("Q","-",quarter(datekey)) Quarter,
monthname(datekey) as Month_Name,
date_format(datekey,'%Y-%b') as YearMonth,
weekday(datekey) AS Weekday,
dayname(DATEKEY) as Weekday_no,

CASE 
	WHEN month(DATEKEY) >= 4 then CONCAT('FM', MONTH(DATEKEY) - 3)
	ELSE CONCAT('FM', MONTH(DATEKEY) + 9)
    END AS financial_month,

CASE 
	WHEN MONTH(datekey) >= 4 AND MONTH(datekey) <= 6 THEN 'FQ1'
	WHEN MONTH(datekey) >= 7 AND MONTH(datekey) <= 9 THEN 'FQ2'
	WHEN MONTH(datekey) >= 10 AND MONTH(datekey) <= 12 THEN 'FQ3'
	ELSE 'FQ4'
    END AS financial_quarter
FROM main;

# 3 Convert the Average cost for 2 column into USD dollars.

select main.Average_Cost_for_two, (Average_Cost_for_two* USDRate ) AS USD_Price 
from main
inner join currency
on main.currency=currency.currency;

# 4 Find the Numbers of Resturants based on City and Country

select city, count(restaurantid) Count_of_restaurants from main
group by city;

select 
country.countryname,count(restaurantid)no_of_restaurants
from main inner join country 
on main.countryCode=country.countryid 
group by country.countryname;

# 5 Numbers of Resturants opening based on Year , Quarter , Month.

SELECT
year(DATEKEY)as Year,count(RESTAURANTID)no_of_restaurants from main
group by year(DATEKEY)
order by year(DATEKEY);


 select MonthName(datekey) as Month,count(RESTAURANTID)no_of_restaurants from main
group by monthname(datekey);


select Quarter as Quater,count(RESTAURANTID)no_of_restaurants from main
group by quarter
order by quarter;

# 6    Count of Resturants based on Average Ratings

SELECT 
    rating, COUNT(restaurantid) count_of_restaurants
FROM
    main
GROUP BY rating
ORDER BY rating;


# 7 Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets

SELECT
CASE
  WHEN currency.USDRate * main.Average_Cost_for_two between 0 AND 50 THEN '0-50'
  WHEN currency.USDRate * main.Average_Cost_for_two between 50 AND 150 THEN '50-150'
  WHEN currency.USDRate * main.Average_Cost_for_two between 150 AND 300 THEN '150-300'
  WHEN currency.USDRate * main.Average_Cost_for_two between 300 AND 500 THEN '300-500'
  END as bucket_range, count(restaurantid) as Restaurants_count  from main
 join currency on main.Currency = currency.Currency
group by bucket_range
order by count(*) desc ;
  
  SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
  
  
  
  # 8 Percentage of Resturants based on "Has_Table_booking"

  select Has_Table_booking, count(restaurantid)Restaurant_count,concat(round(count(restaurantid)/100,1),'%')Percentage from main
  group by Has_Table_booking;
  
 # 9 Percentage of Resturants based on "Has_Online_delivery"

select Has_Online_delivery, count(restaurantid)Restaurant_count,concat(round(count(restaurantid)/100,1),'%')Percentage from main
  group by Has_Online_delivery;
  
  