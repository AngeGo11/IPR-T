-- type_pret
with cleaned_type_pret as 
(
select nullif(trim(cd_type_pret), '') as cd_type_pret, 
       nullif(trim(regexp_replace(initcap(lb_type_pret), '\\s+', ' ')), '') as lib_type_pret 
from {{source('bronze', 'TB_TYPE_PRET')}}
)

select *, 
    row_number() over (
        partition by cd_type_pret 
        order by lib_type_pret
        ) as rn
from cleaned_type_pret