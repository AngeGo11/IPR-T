{{ config(
    materialized = 'incremental',
    unique_key = ['rejection_id']
) }}

select
    {{ dbt_utils.generate_surrogate_key(['id_pret', 'id_emprunteur', 'dt_pret', 'rn']) }} as rejection_id,
    convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,

    case
        when id_pret is null then 'missing pret id'
        when id_emprunteur is null then 'missing emprunteur id'
        when cd_type_pret is null then 'missing type pret'
        when cd_statut_pret is null then 'missing statut pret'
        when cd_periodicite_remboursement is null then 'missing periodicite remboursement'
        when dt_pret is null then 'invalid or missing date pret'
        when mt_pret is null then 'invalid or missing montant pret'
        when nb_duree_remboursement is null then 'invalid or missing duree remboursement'
        when tx_interet_pret is null then 'invalid or missing taux interet'
        when rn > 1 then 'deduplicate key'
    end as rejected_reason,

    id_pret,
    dt_pret,
    mt_pret,
    nb_duree_remboursement,
    tx_interet_pret,
    cd_type_pret,
    id_emprunteur,
    cd_statut_pret,
    cd_periodicite_remboursement

from {{ ref('_stg_pret_deduplicated') }}
where rn > 1
   or id_pret is null
   or id_emprunteur is null
   or cd_type_pret is null
   or cd_statut_pret is null
   or cd_periodicite_remboursement is null
   or dt_pret is null
   or mt_pret is null
   or nb_duree_remboursement is null
   or tx_interet_pret is null
