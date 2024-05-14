{{ config(metrialized='view') }}

select 
    cast(country_region_code as string) as country_region_code, 
    cast(country_region as string) as country_region,

    cast(symptom_infection as FLOAT64) as symptom_infection,
    cast(symptom_itch as FLOAT64) as symptom_itch,
    cast(symptom_pain as FLOAT64) as symptom_pain,
    cast(symptom_skin_rash as FLOAT64) as symptom_skin_rash,
    cast(symptom_allergy as FLOAT64) as symptom_allergy
from {{source('staging', 'daily_symptomes')}}