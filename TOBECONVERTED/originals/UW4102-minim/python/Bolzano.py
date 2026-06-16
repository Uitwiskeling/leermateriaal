# importeer math voor e en voor logaritmen
import math
#startwaarden van de iteratie
a=1/math.e
b=1
#implementatie van de lus
while abs(a-b)>0.001:
    m=(a+b)/2
    if math.log(m)+m>0:
        b=m
    else:
        a=m
print('De nulwaarde ligt in het interval ]'+str(a)+','+str(b)+'[')
