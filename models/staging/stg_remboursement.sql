-- stg_remboursement
select
    id_remboursement,
    dt_remboursement,
    mt_rembourse,
    mt_capital_paye,
    mt_interet_paye,
    cd_mode_remboursement,
    id_pret
from {{ ref('_stg_remboursement_deduplicated') }}
where rn = 1
  and id_remboursement is not null
  and id_pret is not null
  and cd_mode_remboursement is not null
  and dt_remboursement is not null
  and mt_rembourse is not null
  and mt_capital_paye is not null
  and mt_interet_paye is not null
