# stel de startwaarde van de iteratie in
benadering = 1.5
stap = 0

def functie(x):
    return x**3-2*x-2
    
def afgeleide(x):
    return 3*x**2-2
    
while abs(functie(benadering)/afgeleide(benadering))>0.0001 and stap<1000:
    stap +=1
    benadering -= functie(benadering)/afgeleide(benadering)

print(str(benadering), 'gevonden na', str(stap), 'stappen')
