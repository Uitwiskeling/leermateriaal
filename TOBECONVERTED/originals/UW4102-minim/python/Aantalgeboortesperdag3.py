########################################################
# Hier worden de nodige bibliotheekprogramma's geladen #
########################################################
import matplotlib.pyplot as plt
import pandas as pd
import statsmodels.api as sm

#############################################################
# Hier wordt een csv-bestand omgezet in een data dataframe. #
#############################################################
geboortes=pd.read_csv("geboortesperdag.csv")
print(geboortes)

################################################################
# Plotten van een histogram van een selectie van een dataframe #
################################################################
week=['maandag','dinsdag','woensdag','donderdag','vrijdag']
geboortesweek = geboortes.loc[geboortes['Dag'].isin(week)]
geboortesweek.hist(column='Aantal', bins=250, range=(250, 500))
plt.title('De aantallen geboorten op een weekdag in Belgie')
plt.xlabel('Aantal geboorten per dag')
plt.ylabel('Frequentie sinds begin 1992')
plt.show()

#######################################################################
# Gemiddelde en standaardafwijking van geboorten per dag op weekdagen #
#######################################################################
gemiddelde = round(geboortesweek['Aantal'].mean(),1)
print('\n Het gemiddelde is: ', gemiddelde)
standaardafwijking = round(geboortesweek['Aantal'].std(),1)
print('\n De standaardafwijking is: ', standaardafwijking,'\n')

##########################################
# Normaliteitstest met de 68-95-99-regel #
##########################################
a=gemiddelde-2*standaardafwijking
b=gemiddelde+2*standaardafwijking
geboortesinterval=geboortesweek.loc[geboortesweek['Aantal'].between(a,b)]
kans=len(geboortesinterval)/len(geboortesweek)
print('\n De kans om in het centrale interval te liggen is ', kans,'\n')

################################
# Normaliteitstest met qq-plot #
################################
fig = sm.qqplot(geboortesweek['Aantal'], line='r',marker='.')
plt.show()






