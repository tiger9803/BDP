select * from sales_table where year=2021;
select * from population_table;
select * from store_table where year=2021;

select sale.servicecode, round(avg(sale.avg_sales),0) as avg_sales
from (select year, quarter, market, marketname, marketcode, servicecode, servicename, sales/storenumber as avg_sales 
from sales_table where storenumber>0) sale group by sale.servicecode order by avg_sales; //������ ��� ����

select servicecode, avg(closerate) as closerate from store_table group by servicecode order by closerate desc;//������ ��� �����

select sa.servicecode, sa.avg_sales, st.closerate from (select sale.servicecode, round(avg(sale.avg_sales),0) as avg_sales
from (select year, quarter, market, marketname, marketcode, servicecode, servicename, sales/storenumber as avg_sales 
from sales_table where storenumber>0) sale group by sale.servicecode) sa, 
(select servicecode, avg(closerate) as closerate from store_table group by servicecode) st where sa.servicecode=st.servicecode order by avg_sales;//������ ��� ����� �����


select marketcode, avg(population) as population from population_table where year=2021 group by marketcode order by marketcode; //����ڵ庰 ��� �α���

select marketcode, avg(closerate) as closerate from store_table where year=2021 group by marketcode order by closerate desc; //����ڵ庰 �����

select pop.marketcode, pop.population, st.closerate from (select marketcode, avg(population) as population from population_table where year=2021 group by marketcode) pop,
(select marketcode, avg(closerate) as closerate from store_table where year=2021 group by marketcode) st where pop.marketcode=st.marketcode and population>=100 order by population desc;
//����ڵ庰 ��� �����α����� �����


select marketcode, avg(population) as population from population_table where year=2021 and population>=1000 group by marketcode order by population desc; //����ڵ庰 ��� �α���(1000�� �̻�)
select marketcode,servicecode,servicename, avg(closerate) as closerate from store_table where year=2021 group by marketcode,servicecode,servicename order by closerate desc;//����ڵ�� ������ ��� �����


select servicecode,servicename, avg(closerate) as closerate from
(select st.servicecode,st.servicename, st.closerate from (select marketcode, avg(population) as population from population_table where year=2021 and population>=1000 group by marketcode) pop, 
(select marketcode,servicecode,servicename, avg(closerate) as closerate from store_table where year=2021 group by marketcode,servicecode,servicename) st
where st.marketcode=pop.marketcode)
group by servicecode,servicename order by closerate desc; //�α���1000�� �̻��� ����� ������ ��� �����

select sa.servicecode,sa.servicename, round(avg(sa.avg_sales),0) as sales, round(avg(pop.population),0) from
(select marketcode, avg(population) as population from population_table where year=2021 and population>=1000 group by marketcode) pop,
(select marketcode, sale.servicecode,sale.servicename, round(avg(sale.avg_sales),0) as avg_sales
from (select year, quarter, market, marketname, marketcode, servicecode, servicename, sales/storenumber as avg_sales 
from sales_table where storenumber>0) sale group by sale.servicecode, marketcode,sale.servicename) sa where pop.marketcode=sa.marketcode group by sa.servicecode, sa.servicename
order by sales desc; //�α���1000�� �̻��� ����� ������ ��� ����










select cl.servicecode, cl.servicename, cl.closerate, sa.sales, sa.population from
(select servicecode,servicename, avg(closerate) as closerate from
(select st.servicecode,st.servicename, st.closerate from (select marketcode, avg(population) as population from population_table where year=2021 and population>=1000 group by marketcode) pop, 
(select marketcode,servicecode,servicename, avg(closerate) as closerate from store_table where year=2021 group by marketcode,servicecode,servicename) st
where st.marketcode=pop.marketcode)
group by servicecode,servicename) cl,
(select sa.servicecode,sa.servicename, round(avg(sa.avg_sales),0) as sales, round(avg(pop.population),0) as population from
(select marketcode, avg(population) as population from population_table where year=2021 and population>=1000 group by marketcode) pop,
(select marketcode, sale.servicecode,sale.servicename, round(avg(sale.avg_sales),0) as avg_sales
from (select year, quarter, market, marketname, marketcode, servicecode, servicename, sales/storenumber as avg_sales 
from sales_table where storenumber>0) sale group by sale.servicecode, marketcode,sale.servicename) sa where pop.marketcode=sa.marketcode group by sa.servicecode, sa.servicename) sa
where cl.servicecode=sa.servicecode order by sa.servicecode; //�α��� 1000�� �̻��� ���� ������ ��� ����� ��� �����





select cl.servicecode, cl.servicename, cl.closerate, sa.sales, sa.population 
from pop_high_close_store_group cl, pop_high_store_sales sa
where cl.servicecode=sa.servicecode order by sa.servicecode;//1000�� �̻��� ��� �� ������ ��� �����, ����, �α�
create table pop_high_close_sales_pop as select cl.servicecode, cl.servicename, cl.closerate, sa.sales, sa.population 
from pop_high_close_store_group cl, pop_high_store_sales sa
where cl.servicecode=sa.servicecode order by sa.servicecode;

select servicecode,servicename, avg(closerate) as closerate 
from pop_high_close_store
group by servicecode,servicename; //1000�� �̻��� ��� �� ������ ��� �����
create table pop_high_close_store_group as select servicecode,servicename, avg(closerate) as closerate 
from pop_high_close_store
group by servicecode,servicename;

select marketcode, avg(population) as population from population_table where year=2021 and population>=1000 group by marketcode; //1000�� �̻��� ����� �����ڵ�� �α�
create table population_1000_high as select marketcode, avg(population) as population from population_table where year=2021 and population>=1000 group by marketcode;

select marketcode,servicecode,servicename, avg(closerate) as closerate from store_table where year=2021 group by marketcode,servicecode,servicename; //������ ��� �����
create table closerate_store as select marketcode,servicecode,servicename, avg(closerate) as closerate from store_table where year=2021 group by marketcode,servicecode,servicename;

select st.servicecode,st.servicename, st.closerate from population_1000_high pop,  closerate_store st where st.marketcode=pop.marketcode; //1000�� �̻��� ���� ������ �����
create table pop_high_close_store as select st.servicecode,st.servicename, st.closerate from population_1000_high pop,  closerate_store st where st.marketcode=pop.marketcode;



select sa.servicecode,sa.servicename, round(avg(sa.avg_sales),0) as sales, round(avg(pop.population),0) as population 
from population_1000_high pop, store_sales_group sa 
where pop.marketcode=sa.marketcode group by sa.servicecode, sa.servicename;
//1000�� �̻��� ��� �� ������ ��� ����� �α�
create table pop_high_store_sales as select sa.servicecode,sa.servicename, round(avg(sa.avg_sales),0) as sales, round(avg(pop.population),0) as population 
from population_1000_high pop, store_sales_group sa 
where pop.marketcode=sa.marketcode group by sa.servicecode, sa.servicename;

select marketcode, servicecode, servicename, sales/storenumber as avg_sales from sales_table where storenumber>0;//������ ��� ����
create table store_sales as select marketcode, servicecode, servicename, sales/storenumber as avg_sales from sales_table where storenumber>0;

select marketcode, sale.servicecode,sale.servicename, round(avg(sale.avg_sales),0) as avg_sales from store_sales sale group by sale.servicecode, marketcode,sale.servicename order by avg_sales;//������ ��� ���� �׷�ȭ
create table store_sales_group as select marketcode, sale.servicecode,sale.servicename, round(avg(sale.avg_sales),0) as avg_sales from store_sales sale group by sale.servicecode, marketcode,sale.servicename;