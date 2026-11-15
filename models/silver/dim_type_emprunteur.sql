select  ROW_NUMBER() OVER (ORDER BY te.cd_type_emprunteur) AS id_dim_type_emprunteur,
te.cd_type_emprunteur, te.lib_type_emprunteur
FROM {{ref('stg_type_emprunteur')}} te 

