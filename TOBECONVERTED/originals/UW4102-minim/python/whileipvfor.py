term=2                  	
verschil=1	    	# arbitraire beginwaarde voor het verschil
while abs(verschil) > 0.001: 	
    verschil=1/(1+term**2)-term 
    term+=verschil      # de volgende term is de huidige term plus het verschil
print(term)         		