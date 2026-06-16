term=2                  # beginterm
for i in range(7):      # start van een lus die 7 keer doorlopen wordt
    term=1/term**2      # recursievoorschrift
print(term)             # printen van de laatste term