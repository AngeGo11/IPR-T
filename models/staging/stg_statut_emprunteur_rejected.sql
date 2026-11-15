{{
config(
    materialized = 'incremental', 
    unique_key = ['rejection_id']
) }}



-- stg_statut_emprunteur_rejected
select {{ dbt_utils.generate_surrogate_key(['cd_statut_emprunteur', 'lib_statut_emprunteur',  'rn']) }} as rejection_id,
    convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,

    case
        when cd_statut_emprunteur is null then 'missing statut_emprunteur code'
        when lib_statut_emprunteur is null then 'missing statut_emprunteur description'
        when rn > 1 then 'deduplicate key'
    end as rejected_reason,
    cd_statut_emprunteur,
    lib_statut_emprunteur,
    
from {{ref('_stg_statut_emprunteur_deduplicated')}}
where rn > 1
or cd_statut_emprunteur is null 
or lib_statut_emprunteur is null
