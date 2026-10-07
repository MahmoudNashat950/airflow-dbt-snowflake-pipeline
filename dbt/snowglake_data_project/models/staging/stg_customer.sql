select 
id as customer_id ,
name as customer_name ,
email ,
country
FROM {{source('raw_data' , 'customers')}}