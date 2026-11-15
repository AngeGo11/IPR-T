{{config(alias = 'dim_emprunteur')}}

WITH geographic_area AS (

    SELECT
        pc.id_dim_postal_code,
        pc.cd_postal,
        d.cd_department,
        d.department_name,
        r.cd_region,
        r.region_name,
        c.cd_country,
        c.lib_country

    FROM {{ ref('dim_postal_code') }} pc

    INNER JOIN {{ ref('dim_department') }} d
        ON pc.id_dim_department = d.id_dim_department

    INNER JOIN {{ ref('dim_region') }} r
        ON d.id_dim_region = r.id_dim_region

    INNER JOIN {{ ref('dim_country') }} c
        ON r.id_dim_country = c.id_dim_country
),

emprunteur_detail AS (

    SELECT
        e.id_dim_emprunteur,
        e.id_emprunteur,
        e.valid_from,
        e.valid_to,
        e.is_current_version,
        e.lib_civilite_emprunteur,
        e.lib_nom_emprunteur,
        e.lib_prenom_emprunteur,
        e.dt_naissance_emprunteur,
        e.lib_email_emprunteur,

        te.cd_type_emprunteur,
        te.lib_type_emprunteur,

        se.cd_statut_emprunteur,
        se.lib_statut_emprunteur,

        ga.cd_postal,
        ga.cd_department,
        ga.department_name,
        ga.cd_region,
        ga.region_name,
        ga.cd_country,
        ga.lib_country

    FROM {{ ref('dim_emprunteur') }} e

    INNER JOIN {{ ref('dim_type_emprunteur') }} te
        ON e.id_dim_type_emprunteur = te.id_dim_type_emprunteur

    INNER JOIN {{ ref('dim_statut_emprunteur') }} se
        ON e.id_dim_statut_emprunteur = se.id_dim_statut_emprunteur

    LEFT OUTER JOIN geographic_area ga
        ON e.id_dim_postal_code = ga.id_dim_postal_code
)

SELECT *
FROM emprunteur_detail
