import numpy as np

def kernel(M,*args,**kwargs):

    if ('gaussian' in kwargs):


    if ('gaussian' in kwargs):
        if not ('M' in kwargs):
            return "There's no M value!"
        else:
            M = kwargs['M']
    else:
        return "There's no kernel function!"

return "No parameters given!"
