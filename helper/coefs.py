from scipy.integrate import quad
import matplotlib.pyplot as plt
import numpy as np
import random

def f(x):
    return np.exp(14.397021935*(1-x) - 11.73)

a = 0
b = 1
last = 0
table = []

for i in range(0, 100):
    print(i)
    a, b = b, 1 - quad(f, 0, i/99)[0]
    print(b)
    last = a-b
    table.append(b)

print(sum(table))

# print("Tentative d'avoir 99 pièces")

results = []
for n in range(10**8):
    rnd = random.random()
    i = 0
    while rnd <= table[i]:
        i = i+1
        if i == 99:
            break
    results.append(i)

# results.sort()

plt.hist(results, 200)
plt.show()

# print(count)

# print(np.array(table))
