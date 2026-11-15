-- stg_pret
select
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
where rn = 1
  and id_pret is not null
  and id_emprunteur is not null
  and cd_type_pret is not null
  and cd_statut_pret is not null
  and cd_periodicite_remboursement is not null
  and dt_pret is not null
  and mt_pret is not null
  and nb_duree_remboursement is not null
  and tx_interet_pret is not null
