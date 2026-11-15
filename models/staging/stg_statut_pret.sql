
-- stg_statut_pret
select cd_statut_pret, lib_statut_pret
from {{ref('_stg_statut_pret_deduplicated')}}
where rn = 1
    and cd_statut_pret is not null
    and lib_statut_pret is not null
