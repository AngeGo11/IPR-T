
-- _stg_mode_remboursement_deduplicated
with cleaned_mode_remboursement as 
(
select nullif(trim(cd_mode_remboursement), '') as cd_mode_remboursement, 
       nullif(trim(regexp_replace(initcap(lb_mode_remboursement), '\\s+', ' ')), '') as lib_mode_remboursement 
from {{source('bronze', 'TB_MODE_REMBOURSEMENT')}}
)

select *, 
    row_number() over (
        partition by cd_mode_remboursement 
        order by lib_mode_remboursement
        ) as rn
from cleaned_mode_remboursement
