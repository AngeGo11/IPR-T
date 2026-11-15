
WITH pret_detail AS (

    SELECT
        p.id_pret,
        p.dt_pret,
        p.mt_pret,
        p.nb_duree_remboursement,
        p.tx_interet_pret,

        -- Clés métier
        p.id_emprunteur,
        p.cd_type_pret,
        p.cd_statut_pret,
        p.cd_periodicite_remboursement

    FROM {{ref('stg_pret')}} p

),

pret_dimensions AS (

    SELECT
        pd.id_pret,
        pd.mt_pret,
        pd.nb_duree_remboursement,
        pd.tx_interet_pret,

        -- Clés techniques des dimensions
        e.id_dim_emprunteur,
        tp.id_dim_type_pret,
        sp.id_dim_statut_pret,
        pr.id_dim_periodicite_remboursement,
        ca.id_dim_calendar

    FROM pret_detail pd

    -- Dimension emprunteur
    LEFT OUTER JOIN {{ref('dim_emprunteur')}} e
        ON pd.id_emprunteur = e.id_emprunteur
        AND pd.dt_pret >= e.valid_from
        AND (pd.dt_pret < e.valid_to OR e.valid_to IS NULL)

    -- Dimension type de prêt
    LEFT OUTER JOIN {{ref('dim_type_pret')}} tp
        ON pd.cd_type_pret = tp.cd_type_pret

    -- Dimension statut du prêt
    LEFT OUTER JOIN {{ref('dim_statut_pret')}} sp
        ON pd.cd_statut_pret = sp.cd_statut_pret

    -- Dimension périodicité
    LEFT OUTER JOIN {{ref('dim_periodicite_remboursement')}} pr
        ON pd.cd_periodicite_remboursement =
           pr.cd_periodicite_remboursement

    -- Dimension date
    LEFT OUTER JOIN {{ref('dim_calendar')}} ca
        ON pd.dt_pret = ca.dt_calendar

)

SELECT
    id_pret,

    -- Clés étrangères dimensionnelles
    id_dim_emprunteur,
    id_dim_type_pret,
    id_dim_statut_pret,
    id_dim_periodicite_remboursement,
    id_dim_calendar,

    -- Mesures
    nb_duree_remboursement,
    mt_pret,
    tx_interet_pret

FROM pret_dimensions
       