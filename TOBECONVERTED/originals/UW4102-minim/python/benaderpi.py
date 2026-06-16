# voer een variabele in die de partieelsommen onthoudt
partieelsom = 0
for i in range(2000):
    partieelsom += 4 * (-1)**i/(2*i+1)
print(partieelsom)
