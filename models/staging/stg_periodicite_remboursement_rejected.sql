{{ config(
    materialized = 'incremental', 
    unique_key = ['rejection_id']
) }}


select {{ dbt_utils.generate_surrogate_key(['cd_periodicite_remboursement', 'lib_periodicite_remboursement',  'rn']) }} as rejection_id,
    convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,

    case
        when cd_periodicite_remboursement is null then 'missing periodicite_remboursement code'
        when lib_periodicite_remboursement is null then 'missing periodicite_remboursement description'
        when rn > 1 then 'deduplicate key'
    end as rejected_reason,
    cd_periodicite_remboursement,
    lib_periodicite_remboursement,
    
from {{ref('_stg_periodicite_remboursement_deduplicated')}}
where rn > 1
or cd_periodicite_remboursement is null 
or lib_periodicite_remboursement is null
