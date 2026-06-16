# Importeer math voor de vierkantswortel
import math
for i in range(11):
    getal = (((1+math.sqrt(5))/2)**i - ((1-math.sqrt(5))/2)**i)/math.sqrt(5)
    print(getal)
