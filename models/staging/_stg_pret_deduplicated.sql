-- _stg_pret_deduplicated
with cleaned_pret as (
    select
        nullif(trim(id_pret), '') as id_pret,

        coalesce(
            -- 'DD/MM/YYYY' accepte '02/04/16' et donne l'an 0016 : l'année courte doit passer avant
            case when regexp_like(trim(dt_pret), '\\d{2}/\\d{2}/\\d{2}')
                then try_to_date(trim(dt_pret), 'DD/MM/YY') end,
            try_to_date(trim(dt_pret), 'YYYY-MM-DD'),
            try_to_date(trim(dt_pret), 'DD/MM/YYYY'),
            try_to_date(trim(dt_pret), 'DD-MM-YYYY'),
            try_to_date(trim(dt_pret), 'DD.MM.YYYY'),
            try_to_date(trim(dt_pret), 'DD/MM/YY')
        ) as dt_pret,

        -- retire € / espaces / caractères parasites, puis , -> .
        nullif(
            replace(
                regexp_replace(trim(mt_pret), '[^0-9,.-]', ''),
                ',',
                '.'
            ),
            ''
        )::numeric(18, 2) as mt_pret,

        nullif(trim(nb_duree_remboursement), '')::integer as nb_duree_remboursement,

        -- retire % / espaces, conserve le taux en pourcentage (ex: 6.28)
        nullif(
            replace(
                regexp_replace(trim(tx_interet_pret), '[^0-9,.-]', ''),
                ',',
                '.'
            ),
            ''
        )::numeric(16, 4) as tx_interet_pret,

        nullif(trim(cd_type_pret), '') as cd_type_pret,
        nullif(trim(id_emprunteur), '') as id_emprunteur,
        nullif(trim(cd_statut_pret), '') as cd_statut_pret,
        nullif(trim(cd_periodicite_remboursement), '') as cd_periodicite_remboursement

    from {{ source('bronze', 'TB_PRET') }}
)

select *,
    row_number() over (
        partition by id_pret
        order by dt_pret, mt_pret, id_emprunteur
    ) as rn
from cleaned_pret
