-- models/gold/fact_pret.sql

{{config(alias = 'fact_pret')}}

WITH pret_detail AS (

    SELECT
        id_pret,

        id_dim_emprunteur,
        id_dim_type_pret,
        id_dim_statut_pret,
        id_dim_periodicite_remboursement,
        id_dim_calendar,

        nb_duree_remboursement,
        mt_pret,
        tx_interet_pret

    FROM {{ ref('fact_pret') }}

),

pret_gold AS (

    SELECT
        p.id_pret,

        e.id_dim_emprunteur,
        tp.id_dim_type_pret,
        sp.id_dim_statut_pret,
        pr.id_dim_periodicite_remboursement,
        ca.id_dim_calendar,

        p.nb_duree_remboursement,
        p.mt_pret,
        p.tx_interet_pret,

        1 AS nb_pret

    FROM pret_detail p

    LEFT OUTER JOIN {{ ref('dim_emprunteur') }} e
        ON p.id_dim_emprunteur = e.id_dim_emprunteur

    LEFT OUTER JOIN {{ ref('dim_type_pret') }} tp
        ON p.id_dim_type_pret = tp.id_dim_type_pret

    LEFT OUTER JOIN {{ ref('dim_statut_pret') }} sp
        ON p.id_dim_statut_pret = sp.id_dim_statut_pret

    LEFT OUTER JOIN {{ ref('dim_periodicite_remboursement') }} pr
        ON p.id_dim_periodicite_remboursement =
           pr.id_dim_periodicite_remboursement

    LEFT OUTER JOIN {{ ref('dim_calendar') }} ca
        ON p.id_dim_calendar = ca.id_dim_calendar
)

SELECT *
FROM pret_gold