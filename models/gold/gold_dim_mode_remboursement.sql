{{ config(alias='dim_mode_remboursement') }}

SELECT
    id_dim_mode_remboursement,
    cd_mode_remboursement,
    lib_mode_remboursement
FROM {{ ref('dim_mode_remboursement') }}
