{{ config(
    materialized = 'incremental', 
    unique_key = ['rejection_id']
) }}


select {{ dbt_utils.generate_surrogate_key(['cd_statut_pret', 'lib_statut_pret',  'rn']) }} as rejection_id,
    convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,

    case
        when cd_statut_pret is null then 'missing statut_pret code'
        when lib_statut_pret is null then 'missing statut_pret description'
        when rn > 1 then 'deduplicate key'
    end as rejected_reason,
    cd_statut_pret,
    lib_statut_pret
    
from {{ref('_stg_statut_pret_deduplicated')}}
where rn > 1
or cd_statut_pret is null 
or lib_statut_pret is null
