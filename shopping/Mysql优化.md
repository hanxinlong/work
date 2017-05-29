# Mysql优化

### mysql语句优化

1. 对查询进行优化，尽量避免全表扫描，首先应考虑 where 及 order by 涉及的列上建立索引。

2. .应尽量避免在 where 子句中使用!=或<>操作符，否则将引擎放弃使用索引而进行全表扫描。

3. 应尽量避免在 where 子句中对字段进行 null 值判断，否则将导致引擎放弃使用索引而进行全表扫描，如：　

   ```mysql
   select id from t where num is null
   ```

   　　可以在num上设置默认值0，确保表中num列没有null值，然后这样查询：

   ```mysql
   select id from t where num=0

   ```

4. 应尽量避免在 where 子句中使用 or 来连接条件，否则将导致引擎放弃使用索引而进行全表扫描，如：

   ```mysql
   select id from t where num=10 or num=20
   #可以这样查询：
   select id from t where num=10
   union all
   select id from t where num=20
   ```

5. 下面的查询也将导致全表扫描：

   ```mysql
   select id from t where name like '%abc%'
   #若要提高效率，可以考虑全文检索
   ```

6. .in 和 not in 也要慎用，否则会导致全表扫描，如：

   ```mysql
   select id from t where num in(1,2,3)

   #对于连续的数值，能用 between 就不要用 in 了：

   select id from t where num between 1 and 3
   ```

7. 应尽量避免在 where 子句中对字段进行表达式操作，这将导致引擎放弃使用索引而进行全表扫描。如：

   ```mysql
   select id from t where num/2=100
   应改为:
   select id from t where num=100*2
   ```

8. 应尽量避免在where子句中对字段进行函数操作，这将导致引擎放弃使用索引而进行全表扫描。如：

   ```mysql
   select id from t where substring(name,1,3)='abc'--name以abc开头的id

   　　select id from t where datediff(day,createdate,'2005-11-30')=0--'2005-11-30'生成的id

   　　应改为:

   　　select id from t where name like 'abc%'

   　　select id from t where createdate>='2005-11-30' and createdate<'2005-12-1'
   ```