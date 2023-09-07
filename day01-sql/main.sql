declare @input varchar(max) = '
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
'

drop table if exists #Input

select *
into #Input
from string_split(replace(replace(@input, char(13), ''), char(10), '-'), '-')

declare @value int
declare @currentElveCalories int = 0
declare @elvesProcessed int = 0

drop table if exists #ElveCalories
create table #ElveCalories (
	id int,
	calories int,
);

declare input_cursor cursor for
select value
from #Input

open input_cursor
fetch next from input_cursor into @value -- skip first line bc is empty due to input
fetch next from input_cursor into @value

while @@FETCH_STATUS = 0
begin
	if @value = ''
	begin
		insert into #ElveCalories
			values (@elvesProcessed, @currentElveCalories)
			
		set @elvesProcessed += 1
		set @currentElveCalories = 0
	end
	else
	begin
		set @currentElveCalories += @value
	end

	fetch next from input_cursor into @value
end

close input_cursor
deallocate input_cursor

select max(calories) as [part 1] from #ElveCalories

select sum(calories) as [part 2] from (
	select top 3 *
	from #ElveCalories
	order by calories desc
) t
