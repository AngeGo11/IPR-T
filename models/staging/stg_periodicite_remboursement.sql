
select cd_periodicite_remboursement, lib_periodicite_remboursement
from {{ref('_stg_periodicite_remboursement_deduplicated')}} 
where rn = 1
    and cd_periodicite_remboursement is not null
    and lib_periodicite_remboursement is not null
