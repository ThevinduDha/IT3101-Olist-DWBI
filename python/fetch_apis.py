import requests
import json
import os

api_dir = r"C:\OlistDW\landing\api"
# Adding a User-Agent prevents APIs from blocking the request as a bot
headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}

# 1. IBGE API (States to Regions)
print("Fetching IBGE Regions...")
res_ibge = requests.get("https://servicodados.ibge.gov.br/api/v1/localidades/estados", headers=headers)
if res_ibge.status_code == 200:
    with open(rf"{api_dir}\states_regions.json", 'w') as f:
        json.dump(res_ibge.json(), f)
else:
    print(f"Failed IBGE: {res_ibge.status_code}")

# 2. Nager.Date (Holidays for Brazil 2017 & 2018)
print("Fetching Brazilian Holidays...")
holidays = []
for year in [2017, 2018]:
    res = requests.get(f"https://date.nager.at/api/v3/PublicHolidays/{year}/BR", headers=headers)
    if res.status_code == 200:
        holidays.extend(res.json())
with open(rf"{api_dir}\holidays.json", 'w') as f:
    json.dump(holidays, f)

# 3. Central Bank of Brazil (SGS) - USD to BRL rate
print("Fetching USD/BRL Exchange Rates...")
sgs_url = "https://api.bcb.gov.br/dados/serie/bcdata.sgs.10813/dados?formato=json&dataInicial=01/01/2017&dataFinal=31/12/2018"
res_sgs = requests.get(sgs_url, headers=headers)
if res_sgs.status_code == 200:
    with open(rf"{api_dir}\usd_brl_rates.json", 'w') as f:
        json.dump(res_sgs.json(), f)
else:
    print(f"Failed SGS. API returned status: {res_sgs.status_code}")

print("API script execution finished.")