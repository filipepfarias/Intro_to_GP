import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np

from generator import gen3D


X1, X2, Z, T = gen3D()

#Plot

fig = plt.figure()
ax = fig.gca(projection='3d')

# Plot the surface.
surf = ax.plot_surface(X1, X2, T)

plt.show()

