########################################################
# Hier worden de nodige bibliotheekprogramma's geladen #
########################################################
import matplotlib.pyplot as plt
import pandas as pd

#############################################################
# Hier wordt een csv-bestand omgezet in een data dataframe. #
#############################################################
geboortes=pd.read_csv("geboortesperdag.csv")
print(geboortes)

################################################
# Histogram van de aantallen geboorten per dag #
################################################
geboortes.hist(column='Aantal', grid=True, bins=50, range=(150, 500))
plt.title('De aantallen geboorten per dag in Belgie')
plt.xlabel('Aantal geboorten per dag') 
plt.ylabel('Frequentie sinds begin 1992')
plt.show()
