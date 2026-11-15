-- _stg_remboursement_deduplicated
with cleaned_remboursement as (
    select
        nullif(trim(id_remboursement), '') as id_remboursement,

        coalesce(
            -- 'DD/MM/YYYY' accepte '02/04/16' et donne l'an 0016 : l'année courte doit passer avant
            case when regexp_like(trim(dt_remboursement), '\\d{2}/\\d{2}/\\d{2}')
                then try_to_date(trim(dt_remboursement), 'DD/MM/YY') end,
            try_to_date(trim(dt_remboursement), 'YYYY-MM-DD'),
            try_to_date(trim(dt_remboursement), 'DD/MM/YYYY'),
            try_to_date(trim(dt_remboursement), 'DD-MM-YYYY'),
            try_to_date(trim(dt_remboursement), 'DD.MM.YYYY'),
            try_to_date(trim(dt_remboursement), 'DD/MM/YY')
        ) as dt_remboursement,

       
        nullif(
            replace(
                regexp_replace(trim(mt_rembourse), '[^0-9,.-]', ''),
                ',',
                '.'
            ),
            ''
        )::numeric(16, 2) as mt_rembourse,

        nullif(
            replace(
                regexp_replace(trim(mt_capital_paye), '[^0-9,.-]', ''),
                ',',
                '.'
            ),
            ''
        )::numeric(16, 2) as mt_capital_paye,

        nullif(
            replace(
                regexp_replace(trim(mt_interet_paye), '[^0-9,.-]', ''),
                ',',
                '.'
            ),
            ''
        )::numeric(16, 2) as mt_interet_paye,

        nullif(trim(cd_mode_remboursement), '') as cd_mode_remboursement,
        nullif(trim(id_pret), '') as id_pret

    from {{source('bronze', 'TB_REMBOURSEMENT')}}
)

select *,
    row_number() over (
        partition by id_remboursement
        order by dt_remboursement
    ) as rn
from cleaned_remboursement
