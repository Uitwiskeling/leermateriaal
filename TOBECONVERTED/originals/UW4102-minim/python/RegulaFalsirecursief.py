# importeer math voor e en voor logaritmen
import math
#startwaarden van de iteratie
a=1/math.e
b=1
#invoeren van de hulpfuncties
def functie(x):
    return math.log(x)+x
def breuk(x,y):
    return (x*functie(y)-y*functie(x))/(functie(y)-functie(x))
#invoeren van de hoofdfunctie
def regulafalsi(x,y):
    m=breuk(x,y)
    if abs(functie(m))<0.001:
        return m
    elif functie(m)*functie(x):
        return regulafalsi(x,m)
    else:
        return regulafalsi(m,y)
print('De nulwaarde is bij benadering',str(regulafalsi(a,b)))
