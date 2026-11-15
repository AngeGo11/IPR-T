
-- stg_mode_remboursement
select cd_mode_remboursement, lib_mode_remboursement
from {{ref('_stg_mode_remboursement_deduplicated')}} 
where rn = 1
    and cd_mode_remboursement is not null
    and lib_mode_remboursement is not null
