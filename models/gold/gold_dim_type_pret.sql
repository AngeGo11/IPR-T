{{ config(alias='dim_type_pret') }}

SELECT
    id_dim_type_pret,
    cd_type_pret,
    lib_type_pret
FROM {{ ref('dim_type_pret') }}
