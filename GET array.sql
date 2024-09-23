create view cars as
select c.*, jsonb_agg(jsonb_build_object('id', ci.id, 'path', ci.path)) as imgs
from products.cars c
inner join products.car_imgs as ci on product_id = c.id
group by c.id, c.brand
order by c.id;

select * from cars;