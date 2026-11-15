{{ config(
    materialized = 'incremental',
    unique_key = ['rejection_id']
) }}

select
    {{ dbt_utils.generate_surrogate_key(['id_emprunteur', 'lib_nom_emprunteur', 'lib_prenom_emprunteur', 'cd_type_emprunteur', 'cd_statut_emprunteur', 'rn']) }} as rejection_id,
    convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,

    case
        WHEN id_emprunteur IS NULL THEN 'missing emprunteur id'
        WHEN lib_nom_emprunteur IS NULL THEN 'missing nom emprunteur'
        WHEN lib_prenom_emprunteur IS NULL THEN 'missing prenom emprunteur'
        WHEN cd_type_emprunteur IS NULL THEN 'missing type emprunteur'
        WHEN cd_statut_emprunteur IS NULL THEN 'missing statut emprunteur'
        WHEN rn > 1 THEN 'deduplicate key'
    end as rejected_reason,

    id_emprunteur,
    lib_civilite_emprunteur,
    lib_nom_emprunteur,
    lib_prenom_emprunteur,
    dt_naissance_emprunteur,
    lib_email_emprunteur,
    cd_postal_emprunteur,
    cd_type_emprunteur,
    cd_statut_emprunteur

from {{ ref('_stg_emprunteur_deduplicated') }}
where rn > 1
    OR id_emprunteur IS NULL
    OR lib_nom_emprunteur IS NULL 
    OR lib_prenom_emprunteur IS NULL
    OR cd_type_emprunteur IS NULL
    OR cd_statut_emprunteur IS NULL
