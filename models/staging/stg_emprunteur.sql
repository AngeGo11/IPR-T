
-- stg_emprunteur
select id_emprunteur, lib_civilite_emprunteur, lib_nom_emprunteur, lib_prenom_emprunteur, dt_naissance_emprunteur, lib_email_emprunteur, cd_postal_emprunteur, cd_type_emprunteur, cd_statut_emprunteur
from {{ref('_stg_emprunteur_deduplicated')}}
where rn = 1
    and id_emprunteur is not null
    and lib_nom_emprunteur is not null
    and lib_prenom_emprunteur is not null
    and cd_type_emprunteur is not null
    and cd_statut_emprunteur is not null
