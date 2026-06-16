########################################################
# Hier worden de nodige bibliotheekprogramma's geladen #
########################################################
import pandas as pd

########################################################
# Hier wordt een csv-bestand omgezet in een dataframe. #
########################################################
geboortes=pd.read_csv("geboortesperdag.csv")
print(geboortes)