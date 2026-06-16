# Startwaarden F0 en F1
vorigeterm = 0
huidigeterm = 1
# Bereken van F2 tot en met F10
for i in range(9):
    print(vorigeterm, end=" ") # Print F0 tot en met F8
    vorigeterm, huidigeterm = huidigeterm, vorigeterm+huidigeterm
print(vorigeterm, huidigeterm, end=" ") # Print F9 en F10
