
select cd_type_pret, lib_type_pret
from {{ref('_stg_type_pret_deduplicated')}} 
where rn = 1
    and cd_type_pret is not null
    and lib_type_pret is not null
