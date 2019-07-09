import numpy as np

def kernel(x1,x2,**kwargs):

    if ('gaussian' in kwargs):
        from scipy.spatial.distance import cdist

        D = x1.shape[1]
        return (1/(2*np.pi)**D * np.exp(-0.5*cdist(x1,x2)))

    else:
        return "There's no kernel function!"

    return "No parameters given!"

def design_matrix(x,M,kernel):

    P = np.array([x.T for i in range(M)])
    return P

