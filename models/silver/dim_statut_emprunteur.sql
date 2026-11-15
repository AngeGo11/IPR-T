
SELECT
    ROW_NUMBER() OVER (
        ORDER BY cd_statut_emprunteur
    ) AS id_dim_statut_emprunteur,

    cd_statut_emprunteur,
    lib_statut_emprunteur

FROM {{ref('stg_statut_emprunteur')}}

