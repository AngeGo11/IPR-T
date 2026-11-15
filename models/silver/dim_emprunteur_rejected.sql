SELECT
    e.id_emprunteur,
    e.lib_nom_emprunteur,
    e.lib_prenom_emprunteur,
    e.cd_postal_emprunteur,
    e.cd_type_emprunteur,
    e.cd_statut_emprunteur,
    convert_timezone('Europe/Paris', current_timestamp()) AS rejected_at,
    CASE
        WHEN te.cd_type_emprunteur IS NULL THEN 'unknown type emprunteur'
        WHEN se.cd_statut_emprunteur IS NULL THEN 'unknown statut emprunteur'
        WHEN pc.cd_postal IS NULL THEN 'unknown postal code'
    END AS rejected_reason

FROM {{ref('snap_emprunteur')}} e

LEFT OUTER JOIN {{ref('dim_postal_code')}} pc
    ON e.cd_postal_emprunteur = pc.cd_postal

LEFT OUTER JOIN {{ref('dim_type_emprunteur')}} te
    ON e.cd_type_emprunteur = te.cd_type_emprunteur

LEFT OUTER JOIN {{ref('dim_statut_emprunteur')}} se
    ON e.cd_statut_emprunteur = se.cd_statut_emprunteur

WHERE te.cd_type_emprunteur IS NULL
    OR se.cd_statut_emprunteur IS NULL
    OR (e.cd_postal_emprunteur IS NOT NULL AND pc.cd_postal IS NULL)
