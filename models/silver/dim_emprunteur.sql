SELECT
    ROW_NUMBER() OVER (
        ORDER BY e.dbt_scd_id
    ) AS id_dim_emprunteur,

    CASE
        WHEN ROW_NUMBER() OVER (PARTITION BY e.id_emprunteur ORDER BY e.dbt_valid_from) = 1
            THEN '1900-01-01'::timestamp
        ELSE e.dbt_valid_from
    END AS valid_from,
    e.dbt_valid_to AS valid_to,
    CASE WHEN e.dbt_valid_to IS NULL THEN 1 ELSE 0 END AS is_current_version,

    e.id_emprunteur,
    e.lib_civilite_emprunteur,
    e.lib_nom_emprunteur,
    e.lib_prenom_emprunteur,
    e.dt_naissance_emprunteur,
    e.lib_email_emprunteur,

    pc.id_dim_postal_code,
    te.id_dim_type_emprunteur,
    se.id_dim_statut_emprunteur

FROM {{ref('snap_emprunteur')}} e

LEFT OUTER JOIN {{ref('dim_postal_code')}} pc
    ON e.cd_postal_emprunteur = pc.cd_postal

LEFT OUTER JOIN {{ref('dim_type_emprunteur')}} te
    ON e.cd_type_emprunteur = te.cd_type_emprunteur

LEFT OUTER JOIN {{ref('dim_statut_emprunteur')}} se
    ON e.cd_statut_emprunteur = se.cd_statut_emprunteur

-- code postal absent autorisé ; code postal renseigné mais inconnu = rejet
WHERE te.cd_type_emprunteur IS NOT NULL
    AND se.cd_statut_emprunteur IS NOT NULL
    AND (e.cd_postal_emprunteur IS NULL OR pc.cd_postal IS NOT NULL)
