with cleaned_periodicite_remboursement as 
(
select nullif(trim(cd_periodicite_remboursement), '') as cd_periodicite_remboursement, 
       nullif(trim(regexp_replace(initcap(lb_periodicite_remboursement), '\\s+', ' ')), '') as lib_periodicite_remboursement 
from {{source('bronze', 'TB_PERIODICITE_REMBOURSEMENT')}}
)

select *, 
    row_number() over (
        partition by cd_periodicite_remboursement 
        order by lib_periodicite_remboursement
        ) as rn
from cleaned_periodicite_remboursement
