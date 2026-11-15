with cleaned_statut_pret as 
(
select nullif(trim(cd_statut_pret), '') as cd_statut_pret, 
       nullif(trim(regexp_replace(initcap(lb_statut_pret), '\\s+', ' ')), '') as lib_statut_pret 
from {{source('bronze', 'TB_STATUT_PRET')}}
)

select *, 
    row_number() over (
        partition by cd_statut_pret 
        order by lib_statut_pret
        ) as rn
from cleaned_statut_pret