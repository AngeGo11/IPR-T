{{config(alias = 'dim_calendar')}}

with fact_dates as
(
    select id_dim_calendar from {{ref('fact_pret')}}
    union all
    select id_dim_calendar from {{ref('fact_remboursement')}}
),

select_min_max_date as
(
    select min(id_dim_calendar) as min_dt,
           max(id_dim_calendar) as max_dt
    from fact_dates
)

select c.* from {{ref('dim_calendar')}} c
inner join select_min_max_date mmd
on c.id_dim_calendar between mmd.min_dt and mmd.max_dt
