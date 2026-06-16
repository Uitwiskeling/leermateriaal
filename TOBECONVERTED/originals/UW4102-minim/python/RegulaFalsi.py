# importeer math voor e en voor logaritmen
import math
#startwaarden van de iteratie
a=1/math.e
b=1
#hulpvariabele voor de while-lus
stopcriterium=1
#invoeren van de functies
def functie(x):
    return math.log(x)+x
def breuk(x,y):
    return (x*functie(y)-y*functie(x))/(functie(y)-functie(x))
#implementatie van de lus
while stopcriterium>0.001:
    m=breuk(a,b)
    stopcriterium = functie(m)
    if stopcriterium>0:
        b=m
    else:
        a=m
print('De nulwaarde is bij benadering',str(m))
