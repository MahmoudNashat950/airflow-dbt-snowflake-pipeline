SELECT 
O.order_date ,
O.order_id ,
SUM(total_price) as total_price
FROM {{ref('stg_orders')}} O
LEFT JOIN {{ref('stg_order_items')}} oi
    on O.order_id=oi.order_id

group by 1,2
