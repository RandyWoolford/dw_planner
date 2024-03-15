
 
 with me as (select
 employee_id, concat(first_name,' ',last_name) name from hr.employee )

,e as (select 
 e.employee_id, 
 e.position, 
 concat(e.first_name,' ',e.last_name) name, 
 me.name manager_name,
 e.hire_date, 
 ifnull(e.termination_date,current_date) termination_date ---facilitates the join
 from hr.employee e
inner join me on e.manager_employee_id = me.employee_id
where lower(position) in ('senior lead planner','senior financial planner','lead planner','financial planner'))
, b as ( 
select 
employee_id, 
block_types, 
date_trunc(start_of_week_date,week) week_c,
duration_in_minutes 
from `app.meeting_block` 

)
select
  distinct 
e.name, 
e.position, 
if(block_types in ('planning','onboarding','transition','client'),block_types,'invalid')type,

week_c,
duration_in_minutes

from 
e left join b on e.employee_id = b.employee_id 
where  
date_trunc(week_c,quarter) = date_trunc(current_date,quarter)

order by name, week_c, type asc