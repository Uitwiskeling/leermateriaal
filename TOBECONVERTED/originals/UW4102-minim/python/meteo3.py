########################################
# Invoer van de bibliotheekprogramma's #
########################################
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

########################################################
# Hier wordt een csv-bestand omgezet in een dataframe. #
########################################################
metingen=pd.read_csv("openmeteonantwerpen.csv") 
print(metingen)

############################################################
# Gemiddelde en standaardafwijking van de temperatuurkolom #
############################################################
gemiddelde = metingen['temperatuur'].mean()                                                 
print('\n Het gemiddelde van de temperatuur sinds 1940 is: ', gemiddelde)
standaardafwijking = metingen['temperatuur'].std()
print('\n De standaardafwijking van de temperatuur sinds 1940 is: ', standaardafwijking,'\n') 

###############################################################
# Spreidingsdiagram van de temperatuur in functie van de tijd #
###############################################################
plt.plot(metingen['dagnummer'], metingen['temperatuur'],'.', markersize=1)
plt.title('Gemiddelde dagtemperaturen sinds 1940')
plt.xlabel('tijd')
plt.xticks(np.arange(0, 31000, step=5000), rotation=90)
plt.ylabel('temperatuur in graden Celcius')
m, b = np.polyfit(metingen['dagnummer'], metingen['temperatuur'],1)                                     
print('Vergelijking van de best passende rechte: ',m,' x + ',b,' =y ')                              
t = np.arange(0, 30000, 100)                                                                             
plt.plot(t, m*t+b, 'b',linewidth=2) # argument 'b' voor de blauwe kleur
plt.show()
