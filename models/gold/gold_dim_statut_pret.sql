{{ config(alias='dim_statut_pret') }}

SELECT
    id_dim_statut_pret,
    cd_statut_pret,
    lib_statut_pret
FROM {{ ref('dim_statut_pret') }}
