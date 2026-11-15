
-- _stg_emprunteur_deduplicated
with cleaned_emprunteur as 
(
select nullif(trim(id_emprunteur), '') as id_emprunteur, 
       CASE
            WHEN trim(lb_civilite_emprunteur)
            IN ('N/A', 'NULL', '-', '')
            THEN NULL
            ELSE TRIM(lb_civilite_emprunteur)
        END AS lib_civilite_emprunteur,
       nullif(trim(lb_nom_emprunteur), '') as lib_nom_emprunteur,
       nullif(trim(lb_prenom_emprunteur), '') as lib_prenom_emprunteur,
       coalesce(
        try_to_date(replace(trim(dt_naissance_emprunteur), '/', '-'), 'YYYY-MM-DD'),
        try_to_date(replace(trim(dt_naissance_emprunteur), '/', '-'), 'DD-MM-YYYY'),
        try_to_date(replace(trim(dt_naissance_emprunteur), '/', '-'), 'MM-DD-YYYY') 
    ) as dt_naissance_emprunteur,
       CASE
            WHEN trim(lb_email_emprunteur)
            IN ('N/A', 'NULL', '-', '')
            THEN NULL
            ELSE TRIM(lb_email_emprunteur)
       END AS lib_email_emprunteur,        
       CASE
            WHEN trim(cd_postal_emprunteur)
            IN ('N/A', 'NULL', '-', '')
            THEN NULL
            ELSE TRIM(cd_postal_emprunteur)
        END AS cd_postal_emprunteur,
       nullif(trim(cd_type_emprunteur), '') as cd_type_emprunteur,
       nullif(trim(cd_statut_emprunteur), '') as cd_statut_emprunteur   
from {{source('bronze', 'TB_EMPRUNTEUR')}}
)

select *, 
    row_number() over (
        partition by id_emprunteur 
        order by lib_nom_emprunteur, lib_prenom_emprunteur
        ) as rn
from cleaned_emprunteur
