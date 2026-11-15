{{ config(
    materialized = 'incremental', 
    unique_key = ['rejection_id']
) }}
-- stg_mode_remboursement_rejected
select {{ dbt_utils.generate_surrogate_key(['cd_mode_remboursement', 'lib_mode_remboursement',  'rn']) }} as rejection_id,
    convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,

    case
        when cd_mode_remboursement is null then 'missing mode_remboursement code'
        when lib_mode_remboursement is null then 'missing mode_remboursement description'
        when rn > 1 then 'deduplicate key'
    end as rejected_reason,
    cd_mode_remboursement,
    lib_mode_remboursement,
    
from {{ref('_stg_mode_remboursement_deduplicated')}}
where rn > 1
or cd_mode_remboursement is null 
or lib_mode_remboursement is null
