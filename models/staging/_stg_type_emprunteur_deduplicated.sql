
-- _stg_type_emprunteur_deduplicated
with cleaned_type_emprunteur as 
(
select nullif(trim(cd_type_emprunteur), '') as cd_type_emprunteur, 
       nullif(trim(regexp_replace(initcap(lb_type_emprunteur), '\\s+', ' ')), '') as lib_type_emprunteur 
from {{source('bronze', 'TB_TYPE_EMPRUNTEUR')}}
)

select *, 
    row_number() over (
        partition by cd_type_emprunteur 
        order by lib_type_emprunteur
        ) as rn
from cleaned_type_emprunteur
