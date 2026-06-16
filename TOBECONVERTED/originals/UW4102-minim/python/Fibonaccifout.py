vorigeterm = 0
huidigeterm = 1
for i in range(9):
    print(vorigeterm, end=" ") 
    #end=" " zorgt ervoor dat alle getallen op 1 lijn geprint worden
    vorigeterm = huidigeterm
    huidigeterm = vorigeterm + huidigeterm
print(vorigeterm, huidigeterm, end=" ")
