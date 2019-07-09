import numpy as np

def gen3D(**kwargs):
    if ('initial' in kwargs):
        initial = kwargs['initial']
    else:
        initial = 0

    if ('final' in kwargs):
        final = kwargs['final']
    else:
        final = 1

    if ('ns' in kwargs):
        ns = kwargs['ns']
    else:
        ns = 100

    if ('mean' in kwargs):
        mean = kwargs['mean']
    else:
        mean = 0.0

    if ('sigma' in kwargs):
        mean = kwargs['sigma']
    else:
        sigma = 0.1**2

    x1_lim , x2_lim = np.linspace(initial,final,ns) , np.linspace(initial,final,ns)
    
    X1 , X2 = np.meshgrid(x1_lim,x2_lim)
    
    Z = np.sin(2*np.pi*X1)*np.sin(2*np.pi*X2)

    E = np.random.normal(mean,sigma,Z.shape)
    T = Z + E

    x = np.array( [X1.ravel(),X2.ravel()] )
    return X1, X2, x, Z, T