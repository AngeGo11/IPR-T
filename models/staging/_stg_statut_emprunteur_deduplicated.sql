-- _stg_statut_emprunteur_deduplicated
with cleaned_statut_emprunteur as 
(
select nullif(trim(cd_statut_emprunteur), '') as cd_statut_emprunteur, 
       nullif(trim(regexp_replace(initcap(lb_statut_emprunteur), '\\s+', ' ')), '') as lib_statut_emprunteur 
from {{source('bronze', 'TB_STATUT_EMPRUNTEUR')}}
)

select *, 
    row_number() over (
        partition by cd_statut_emprunteur 
        order by lib_statut_emprunteur
        ) as rn
from cleaned_statut_emprunteur
