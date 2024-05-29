
select * from sales;
select * from users;
select * from product;
select * from goldusers_signup;
/*1 display the total amt spent by customers on zomato*/
select s.userid,sum(p.price)as su
from product p
join sales s
on p.product_id=s.product_id
group by s.userid;
/*2. how many days each customer visited zomato?*/
select userid,count(distinct created_date) as c
from sales
group by userid;
select s.userid,p.product_name
from sales s
join product p
on s.product_id=p.product_id;
select userid,min(created_date)
from sales s
inner join
(select product_name from product) p
on s.product_id=p.product_id;
/*3. most purchased products by the customers*/
select product_id,count(product_id) cmax 
from sales
group by product_id
order by cmax desc;
/*4. which item is most popular among customers?/*
select product_id, count(product_id)
from sales
where product_id=1 or product_id=2 or  product_id=3
group by product_id;
/* which item is most popoular amond each customer*/
select s.userid,s.product_id,count(s.product_id) as c
case
when(max(c))then "most purchased"
when(min(c))then "least purchased"
end as mp
from sales s
join product p
on s.product_id=p.product_id;
select s.userid,count(p.product_id)as s
from product p
join sales s
on p.product_id=s.product_id
group by s.userid;
/* what was the first product purchased by each customer?*/
select * from
(select * ,rank() over(partition by userid order by(created_date))rnk from sales)
a where rnk=1;
/*6.what was the first product purchased by each customer after becoming a member?/*
select * from 
(select c.*,rank() over (partition by userid order by created_date)rnk from (select s.userid,s.created_date,s.product_id,g.gold_signup_date from sales s
inner join goldusers_signup g
on s.userid=g.userid
and created_date>gold_signup_date)c)d where rnk=1;

/*7. which item was purchased just before the customer became a member?/*
select * from
(select c.*,rank() over (partition by userid order by created_date desc)rnk from (select s.userid,s.created_date,s.product_id,g.gold_signup_date from sales s
inner join goldusers_signup g
on s.userid=g.userid
and created_date<gold_signup_date)c)d where rnk=1;
/*8. what are the total orders and amt spent by each customer before they became a member?/*
 select userid,count(created_date) order_purchased,sum(price) total_amt_spent from
 (select c.*,p.price from
 (select s.userid,s.created_date,s.product_id,g.gold_signup_date from sales s
 inner join goldusers_signup g
 on s.userid=g.userid
 and created_date<=gold_signup_date)c
 inner join product p
 on c.product_id=p.product_id)e
 group by userid;
 /*9.calculate points collected by each customers and which product has maximum number of points*/
 select userid,sum(total_points) totalpoints_earned from
 (select e.*,amt/points total_points from
 (select d.*,
 case when product_id=1 then 5
 when product_id=2 then 2
 when product_id=3 then 5 else 0 end as points from
 (select c.userid,c.product_id,sum(price)amt from
 (select s.*,p.price from sales s
 inner join product p
 on s.product_id=p.product_id)c
 group by userid,product_id)d)e)f group by userid;
 /*10. rank all the transaction made by the customers?/*
 select * ,rank() over (partition by userid order by created_date)rnk from sales;
 