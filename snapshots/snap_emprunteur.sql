{% snapshot snap_emprunteur %}

{{
    config(
        target_schema='silver',
        unique_key='id_emprunteur',
        strategy='check',
        check_cols=[
            'lib_civilite_emprunteur',
            'lib_nom_emprunteur',
            'lib_prenom_emprunteur',
            'dt_naissance_emprunteur',
            'lib_email_emprunteur',
            'cd_postal_emprunteur',
            'cd_type_emprunteur',
            'cd_statut_emprunteur',
        ]
    )
}}

SELECT
    id_emprunteur,
    lib_civilite_emprunteur,
    lib_nom_emprunteur,
    lib_prenom_emprunteur,
    dt_naissance_emprunteur,
    lib_email_emprunteur,
    cd_postal_emprunteur,
    cd_type_emprunteur,
    cd_statut_emprunteur

FROM {{ ref('stg_emprunteur') }}

{% endsnapshot %}