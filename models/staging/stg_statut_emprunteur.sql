
-- stg_statut_emprunteur
select cd_statut_emprunteur, lib_statut_emprunteur
from {{ref('_stg_statut_emprunteur_deduplicated')}} 
where rn = 1
    and cd_statut_emprunteur is not null
    and lib_statut_emprunteur is not null

 