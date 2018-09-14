def dataset_generator(init, end, sample, mean, var, function):
    """
    Return X,Y,t being:
    x input
    y deterministic output
    t data with noise
    """
    import numpy as np
    sample = int(sample)
    x = (np.array([np.linspace(init,end,sample)])).T
    y = (function(x))
    e = (np.array([np.random.normal(mean,var,sample)])).T
    t = y + e

    return x,y,t,e

def linear_regressor(x,t,function,m):
    """
    Return the model trained
    """
    m += m
    import numpy as np
    phi = np.zeros((len(x),m))

    for i in range(len(x)):
        for j in range(m):
            phi[i][j] = function(x[i],j)

    w = ((np.linalg.inv(phi.T@phi))@phi.T)@t

    y_pred = w.T@phi.T

    return y_pred,w
