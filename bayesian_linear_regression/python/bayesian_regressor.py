import numpy as np

def kernel(M,*args,**kwargs):

    if ('gaussian' in kwargs):
        if not ('M' in kwargs or 'x' in kwargs):
            return "There's no M or x values!"
        else:
            M = kwargs['M']
            PHI1,PHI2 = kwargs['x']
            PHI1 = PHI1.reshape((PHI1.shape[0]*PHI1.shape[1],1)) 
            PHI2 = PHI2.reshape((PHI2.shape[0]*PHI2.shape[1],1))
            PHI = np.array([PHI1[:,0],PHI2[:,0]] for i in range(M))
            
            # Positioning the gaussians
            var = np.linspace(PHI1[0,0],PHI1[-1:0],int(sqrt(M))) , np.linspace(PHI2[0,0],PHI2[-1:0],int(sqrt(M)))
            var(0),var(1) = np.meshgrid(var(0),var(1)) 
            mu = np.array([,np.linspace(PHI2[0,0],PHI2[-1:0,int(sqrt(M))])

    else:
        return "There's no kernel function!"

return "No parameters given!"
