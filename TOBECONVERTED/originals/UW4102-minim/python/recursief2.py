term=2                  # beginterm
print(term)	        		# print beginterm
for i in range(9):      # start van een lus die 9 keer doorlopen wordt
    term=1/(1+term**2)  # recursievoorschrift
    print(term)         # printen van de huidige term
