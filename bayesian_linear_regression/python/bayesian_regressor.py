import numpy as np

def kernel(**kwargs):

    if ('gaussian' in kwargs):
        if not ('M' in kwargs):
            return "There's no M value!"
        else:
            M = kwargs['M']

            