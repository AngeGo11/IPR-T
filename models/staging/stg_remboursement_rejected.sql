{{ config(
    materialized = 'incremental',
    unique_key = ['rejection_id']
) }}

select
    {{ dbt_utils.generate_surrogate_key(['id_remboursement', 'id_pret', 'dt_remboursement', 'rn']) }} as rejection_id,
    convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,

    case
        when id_remboursement is null then 'missing remboursement id'
        when id_pret is null then 'missing pret id'
        when cd_mode_remboursement is null then 'missing mode remboursement'
        when dt_remboursement is null then 'invalid or missing date remboursement'
        when mt_rembourse is null then 'invalid or missing montant rembourse'
        when mt_capital_paye is null then 'invalid or missing montant capital'
        when mt_interet_paye is null then 'invalid or missing montant interet'
        when rn > 1 then 'deduplicate key'
    end as rejected_reason,

    id_remboursement,
    dt_remboursement,
    mt_rembourse,
    mt_capital_paye,
    mt_interet_paye,
    cd_mode_remboursement,
    id_pret

from {{ ref('_stg_remboursement_deduplicated') }}
where rn > 1
   or id_remboursement is null
   or id_pret is null
   or cd_mode_remboursement is null
   or dt_remboursement is null
   or mt_rembourse is null
   or mt_capital_paye is null
   or mt_interet_paye is null
