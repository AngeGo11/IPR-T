
WITH remboursement_detail AS (
    SELECT
        r.id_remboursement,
        r.id_pret,
        r.dt_remboursement,
        r.mt_rembourse,
        r.mt_capital_paye,
        r.mt_interet_paye,
        r.cd_mode_remboursement,

        -- Informations provenant du prêt
        p.id_emprunteur,
        p.cd_type_pret,
        p.cd_statut_pret,
        p.cd_periodicite_remboursement

    FROM {{ref('stg_remboursement')}} r

    LEFT OUTER JOIN {{ref('stg_pret')}} p
        ON r.id_pret = p.id_pret
),

remboursement_dimensions AS (
    SELECT
        rd.id_remboursement,
        rd.id_pret,
        rd.mt_rembourse,
        rd.mt_capital_paye,
        rd.mt_interet_paye,

        -- Clés techniques des dimensions
        e.id_dim_emprunteur,
        tp.id_dim_type_pret,
        sp.id_dim_statut_pret,
        pr.id_dim_periodicite_remboursement,
        mr.id_dim_mode_remboursement,
        ca.id_dim_calendar

    FROM remboursement_detail rd

    LEFT OUTER JOIN {{ref('dim_emprunteur')}} e
        ON rd.id_emprunteur = e.id_emprunteur
        AND rd.dt_remboursement >= e.valid_from
        AND (rd.dt_remboursement < e.valid_to OR e.valid_to IS NULL)

    LEFT OUTER JOIN {{ref('dim_type_pret')}} tp
        ON rd.cd_type_pret = tp.cd_type_pret

    LEFT OUTER JOIN {{ref('dim_statut_pret')}} sp
        ON rd.cd_statut_pret = sp.cd_statut_pret

    LEFT OUTER JOIN {{ref('dim_periodicite_remboursement')}} pr
        ON rd.cd_periodicite_remboursement =
           pr.cd_periodicite_remboursement

    LEFT OUTER JOIN {{ref('dim_mode_remboursement')}} mr
        ON rd.cd_mode_remboursement =
           mr.cd_mode_remboursement

    LEFT OUTER JOIN {{ref('dim_calendar')}} ca
        ON rd.dt_remboursement = ca.dt_calendar
)

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

FROM remboursement_dimensions
