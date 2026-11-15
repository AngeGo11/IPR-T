-- models/gold/fact_remboursement.sql

{{config(alias = 'fact_remboursement')}}

WITH remboursement_detail AS (

    SELECT
        id_remboursement,
        id_pret,

        id_dim_emprunteur,
        id_dim_type_pret,
        id_dim_statut_pret,
        id_dim_periodicite_remboursement,
        id_dim_mode_remboursement,
        id_dim_calendar,

        mt_rembourse,
        mt_capital_paye,
        mt_interet_paye

    FROM {{ ref('fact_remboursement') }}

),

remboursement_gold AS (

    SELECT
        r.id_remboursement,
        r.id_pret,

        e.id_dim_emprunteur,
        tp.id_dim_type_pret,
        sp.id_dim_statut_pret,
        pr.id_dim_periodicite_remboursement,
        mr.id_dim_mode_remboursement,
        ca.id_dim_calendar,

        r.mt_rembourse,
        r.mt_capital_paye,
        r.mt_interet_paye,

        1 AS nb_remboursement

    FROM remboursement_detail r

    LEFT OUTER JOIN {{ ref('dim_emprunteur') }} e
        ON r.id_dim_emprunteur = e.id_dim_emprunteur

    LEFT OUTER JOIN {{ ref('dim_type_pret') }} tp
        ON r.id_dim_type_pret = tp.id_dim_type_pret

    LEFT OUTER JOIN {{ ref('dim_statut_pret') }} sp
        ON r.id_dim_statut_pret = sp.id_dim_statut_pret

    LEFT OUTER JOIN {{ ref('dim_periodicite_remboursement') }} pr
        ON r.id_dim_periodicite_remboursement =
           pr.id_dim_periodicite_remboursement

    LEFT OUTER JOIN {{ ref('dim_mode_remboursement') }} mr
        ON r.id_dim_mode_remboursement =
           mr.id_dim_mode_remboursement

    LEFT OUTER JOIN {{ ref('dim_calendar') }} ca
        ON r.id_dim_calendar = ca.id_dim_calendar
)

SELECT *
FROM remboursement_gold