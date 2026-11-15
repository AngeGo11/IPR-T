SELECT
    ROW_NUMBER() OVER (
        ORDER BY cd_mode_remboursement
    ) AS id_dim_mode_remboursement,

    cd_mode_remboursement,
    lib_mode_remboursement

FROM {{ref('stg_mode_remboursement')}}


