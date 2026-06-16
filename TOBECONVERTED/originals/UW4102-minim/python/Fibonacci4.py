# Lijst om de Fibonacci-getallen op te slaan
fibonacci_lijst = [0,1]
# We berekenen de volgende 9 termen
for i in range(9):
    fibonacci_lijst.append(fibonacci_lijst[i]+fibonacci_lijst[i+1])
# Print de lijst van Fibonacci-getallen
print(fibonacci_lijst)
