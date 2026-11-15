
-- stg_type_emprunteur
select cd_type_emprunteur, lib_type_emprunteur
from {{ref('_stg_type_emprunteur_deduplicated')}} 
where rn = 1
    and cd_type_emprunteur is not null
    and lib_type_emprunteur is not null
