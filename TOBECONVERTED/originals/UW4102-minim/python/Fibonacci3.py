# Lijst om de Fibonacci-getallen op te slaan
fibonacci_lijst = []
# Startwaarden voor de Fibonacci-reeks
a, b = 0, 1
# Genereer de eerste 10 Fibonacci-getallen
for i in range(11):
    fibonacci_lijst.append(a)
    a, b = b, a + b
# Print de lijst van Fibonacci-getallen
print(fibonacci_lijst)
