with distinct_postal_code as (
    select distinct code_postal, code_department
    from {{ref('stg_file_zone_geographique')}}
),

deduplicated_postal_code as (
    select code_postal, code_department,
        row_number() over (
            partition by code_postal
            order by case when code_postal like code_department || '%' then 0 else 1 end,
                     code_department
        ) as rn
    from distinct_postal_code
)

select
    row_number() over (order by code_postal) as id_dim_postal_code,
    code_postal as cd_postal,
    d.id_dim_department
from deduplicated_postal_code pc
inner join {{ref('dim_department')}} d
    on pc.code_department = d.cd_department
where pc.rn = 1
