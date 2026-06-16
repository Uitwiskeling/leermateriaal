########################################################
# Hier worden de nodige bibliotheekprogramma's geladen #
#######################################################
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

########################################################
# Hier wordt een csv-bestand omgezet in een dataframe. #
########################################################
overlijdens=pd.read_csv("overlijdensperdag.csv", sep=';')
print(overlijdens)

########################################################
# Spreidingsdiagram van het aantal overlijdens per dag #
########################################################
plt.plot(overlijdens['Dag'], overlijdens['Overlijdens'],'.', markersize=2)
plt.title('Aantal overlijdens per dag sinds januari 1992')
plt.xlabel('Dagnummer')
plt.xticks(np.arange(0, 12000, step=2000),rotation='vertical')
plt.ylabel('Aantal overlijdens')
plt.show()