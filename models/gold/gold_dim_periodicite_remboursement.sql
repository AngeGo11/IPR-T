{{ config(alias='dim_periodicite_remboursement') }}

SELECT
    id_dim_periodicite_remboursement,
    cd_periodicite_remboursement,
    lib_periodicite_remboursement
FROM {{ ref('dim_periodicite_remboursement') }}
