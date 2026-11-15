{{
config(
    materialized = 'incremental', 
    unique_key = ['rejection_id']
) }}

-- stg_type_emprunteur_rejected
select {{ dbt_utils.generate_surrogate_key(['cd_type_emprunteur', 'lib_type_emprunteur',  'rn']) }} as rejection_id,
    convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,

    case
        when cd_type_emprunteur is null then 'missing type_emprunteur code'
        when lib_type_emprunteur is null then 'missing type_emprunteur description'
        when rn > 1 then 'deduplicate key'
    end as rejected_reason,
    cd_type_emprunteur,
    lib_type_emprunteur,
    
from {{ref('_stg_type_emprunteur_deduplicated')}}
where rn > 1
or cd_type_emprunteur is null 
or lib_type_emprunteur is null
