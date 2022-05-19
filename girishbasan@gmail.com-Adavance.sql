--SQL Advance Case Study


--Q1--BEGIN 
select  distinct l.State from FACT_TRANSACTIONS f inner join DIM_CUSTOMER c on c.IDCustomer = f.IDCustomer inner join DIM_LOCATION l on f.IDLocation =l.IDLocation inner join DIM_DATE d on d.DATE = f.Date
where d.[YEAR] >= 2005





--Q1--END

--Q2--BEGIN
select top 1 l.state,l.Country ,COUNT(f.Quantity)[qty] from FACT_TRANSACTIONS f inner join DIM_MODEL m on m.IDModel = f.IDModel inner join DIM_MANUFACTURER r on r.IDManufacturer = m.IDManufacturer 
inner join DIM_LOCATION l on f.IDLocation =l.IDLocation 
where Country = 'US' and r.Manufacturer_Name = 'Samsung'
group by State, l.Country	





--Q2--END

--Q3--BEGIN      
	
select m.Model_Name ,count(IDCustomer)[num_of_transaction]from FACT_TRANSACTIONS f inner join DIM_MODEL m on m.IDModel = f.IDModel inner join DIM_MANUFACTURER r on r.IDManufacturer = m.IDManufacturer 
inner join DIM_LOCATION l on f.IDLocation = l.IDLocation  
group by l.ZipCode,l.State, Model_Name 
order by num_of_transaction desc




--Q3--END

--Q4--BEGIN
select top 1 m.Model_Name, r.Manufacturer_Name,min(totalprice)[Price] from FACT_TRANSACTIONS f inner join DIM_MODEL m on m.IDModel = f.IDModel inner join DIM_MANUFACTURER r on r.IDManufacturer = m.IDManufacturer
group by Model_Name, Manufacturer_Name
order by Price


--Q4--END

--Q5--BEGIN

select r.Manufacturer_Name,m.Model_Name, avg(Totalprice) [Avg_price] from FACT_TRANSACTIONS f inner join DIM_MODEL m on m.IDModel = f.IDModel inner join DIM_MANUFACTURER r on r.IDManufacturer = m.IDManufacturer 
where Manufacturer_Name in 
     (         
       select top 5 Manufacturer_Name
       from FACT_TRANSACTIONS f inner join DIM_MODEL m on m.IDModel = f.IDModel inner join DIM_MANUFACTURER r on r.IDManufacturer = m.IDManufacturer 
       group by Manufacturer_Name
       order by COUNT(Quantity) desc
	   )
group by Manufacturer_Name,Model_Name
order by avg(totalprice) desc



--Q5--END

--Q6--BEGIN
select c.Customer_Name, d.YEAR ,avg(TotalPrice)[Avg_spent] from FACT_TRANSACTIONS f inner join DIM_CUSTOMER c on c.IDCustomer = f.IDCustomer inner join DIM_DATE d on d.DATE = f.Date 
where [YEAR] = 2009 
group by c.Customer_Name , [YEAR] 
having avg(TotalPrice) > 500





--Q6--END
	
--Q7--BEGIN  
select s1.model_name from 
(select top 5 m.Model_Name, d.YEAR, sum(f.Quantity)[qty] from FACT_TRANSACTIONS f inner join DIM_MODEL m on m.IDModel = f.IDModel 
inner join DIM_DATE d on d.DATE = f.Date 
where [YEAR] in (2008 )
group by m.Model_Name, d.YEAR
order by qty desc) s1
inner join   
(select top 5 m.Model_Name, d.YEAR,sum(f.Quantity)[qty] from FACT_TRANSACTIONS f inner join DIM_MODEL m on m.IDModel = f.IDModel 
inner join DIM_DATE d on d.DATE = f.Date 
where [YEAR] in (2009 )
group by m.Model_Name, d.YEAR
order by qty desc) s2 on s1.model_name = s2.Model_Name
inner join
(select top 5 m.Model_Name, d.YEAR,sum(f.Quantity)[qty] from FACT_TRANSACTIONS f inner join DIM_MODEL m on m.IDModel = f.IDModel 
inner join DIM_DATE d on d.DATE = f.Date 
where [YEAR] in (2010 )
group by m.Model_Name, d.YEAR
order by qty desc) s3 on s2.Model_Name= s3.Model_Name
	


--Q7--END	
--Q8--BEGIN
select top 2 Manufacturer_Name, sales from(
select top 2 Manufacturer_Name, sum(TotalPrice)[sales] from DIM_MANUFACTURER r inner join DIM_MODEL m on r.IDManufacturer = m.IDManufacturer 
inner join FACT_TRANSACTIONS f on f.IDModel = f.IDModel
inner join DIM_DATE d on d.DATE = f.Date 
where YEAR = 2009
group by Manufacturer_Name ,YEAR
order by sales desc

union all

select top 2 Manufacturer_Name, sum(TotalPrice)[sales] from DIM_MANUFACTURER r inner join DIM_MODEL m on r.IDManufacturer = m.IDManufacturer 
inner join FACT_TRANSACTIONS f on f.IDModel = f.IDModel
inner join DIM_DATE d on d.DATE = f.Date 
where YEAR = 2010
group by Manufacturer_Name ,YEAR
order by sales desc)a
group by Manufacturer_Name , sales
order by sales





--Q8--END
--Q9--BEGIN

select distinct Manufacturer_Name from FACT_TRANSACTIONS f inner join DIM_MODEL m on f.IDModel = m.IDModel 
inner join  DIM_MANUFACTURER r  on  m.IDManufacturer = r.IDManufacturer inner join DIM_DATE d on f.Date = d.DATE
where YEAR  = 2010 except
select distinct Manufacturer_Name from FACT_TRANSACTIONS f inner join DIM_MODEL m on f.IDModel = m.IDModel 
inner join  DIM_MANUFACTURER r  on  m.IDManufacturer = r.IDManufacturer inner join DIM_DATE d on f.Date = d.DATE
where YEAR = 2009 








--Q9--END

--Q10--BEGIN
select top 100 Customer_Name, TotalPrice, avg_spnd as [Average_spend], avg_qty as [AVQuantity], dt as [year_of_spend], 
case when A.prev_spend = 0 then null else convert(numeric(25,0), (([TotalPrice]-prev_spend)/prev_spend )*100) end [% change in spending] from
(select [Customer_Name], [TotalPrice], avg([TotalPrice]) as avg_spnd, avg([Quantity]) as avg_qty, year as dt, 
lag(avg([TotalPrice]), 1,0) over(PARTITION by [Customer_Name] order by (year)) as prev_spend from DIM_CUSTOMER c 
inner join FACT_TRANSACTIONS f on c.IDCustomer = f.IDCustomer inner join DIM_DATE d on f.Date = d.DATE
group by [Customer_Name], year, [TotalPrice])A
order by avg_spnd desc



--Q10--END
	