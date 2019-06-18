# -*- coding: utf-8 -*-


import numpy as np
from keras.models import Sequential, load_model
from keras.layers import Dense
from keras.wrappers.scikit_learn import KerasRegressor
from keras.callbacks import EarlyStopping, ModelCheckpoint
import matplotlib.pyplot as plt
import random
from scipy.integrate import odeint
import scipy.io
import torch
import torch.nn as nn
import torch.nn.functional as F


"""
Step 0: train Keras model
"""

print('Generating Dataset')

#Generating my dataset
entries=10000
x=np.random.randn(entries,1)*np.pi
y=np.sin(x)+(np.random.randn(entries,1)*.1)  #adding som noise into the process
xReal=np.linspace(-np.pi*3,np.pi*3,entries/100)
xReal=np.transpose(np.array([xReal]))
yReal=np.sin(xReal) 



xTrain=x[0:int(np.round(entries*.85)),0]
yTrain=y[0:int(np.round(entries*.85)),0]
x_test=x[int(np.round(entries*.85)):entries,0]
y_test=y[int(np.round(entries*.85)):entries,0]



#Defining my model, all hidden layers are relus, while my output layer is a Tanh
model = Sequential()
model.add(Dense(units=32,activation='relu',input_dim=1))
model.add(Dense(units=32,activation='relu'))
model.add(Dense(units=32,activation='relu'))
model.add(Dense(units=32,activation='relu'))
model.add(Dense(units=1,activation='tanh'))
model.summary()
model.compile(loss='mse',optimizer='Adam')
callbacks = [EarlyStopping(monitor='val_loss', patience=50),
             ModelCheckpoint(filepath='simpleModel.h5', monitor='val_loss', save_best_only=True)] #seting up early stoping


#training my model
model.fit(xTrain,yTrain,epochs=3000,callbacks=callbacks,batch_size=40000,validation_data=(x_test, y_test))

#evaluating my model
yPred=model.predict(xReal)
yPredVal=model.predict(x)
fig, ax = plt.subplots()


ax.scatter(x,y,label='Raw Data')
ax.plot(xReal,yReal,'r',label='Sin wave')

ax.plot(xReal,yPred,'k',linestyle=':',label='Nueral Net')
ax.legend()
fig.savefig('Keras Training',dpi=500)
"""
Step 1: Recreate network in pytorch
"""


def hidden_init(layer):
    fan_in = layer.weight.data.size()[0]
    lim = 1. / np.sqrt(fan_in)
    return (-lim, lim)  

class Actor(nn.Module):
    """Actor (Policy) Model."""

    def __init__(self, state_size, action_size, seed, h):
        """Initialize parameters and build model.
        Params
        ======
            state_size (int): Dimension of each state
            action_size (int): Dimension of each action
            seed (int): Random seed
            fc1_units (int): Number of nodes in first hidden layer
            fc2_units (int): Number of nodes in second hidden layer
        """
        super(Actor, self).__init__()
        self.seed = torch.manual_seed(seed)
        self.fc1 = nn.Linear(state_size, h)
        self.fc2 = nn.Linear(h, h)
        self.fc3 = nn.Linear(h, h)
        self.fc4 = nn.Linear(h, h)
        self.fc5 = nn.Linear(h, action_size)
        self.reset_parameters()

    def reset_parameters(self):
        self.fc1.weight.data.uniform_(*hidden_init(self.fc1))
        self.fc2.weight.data.uniform_(*hidden_init(self.fc2))
        self.fc3.weight.data.uniform_(*hidden_init(self.fc3))
        self.fc4.weight.data.uniform_(*hidden_init(self.fc4))
        self.fc5.weight.data.uniform_(-3e-3, 3e-3)

    def forward(self, state):
        """Build an actor (policy) network that maps states -> actions."""
        x = F.relu(self.fc1(state))
        x = F.relu(self.fc2(x))
        x = F.relu(self.fc3(x))
        x = F.relu(self.fc4(x))

        return F.tanh(self.fc5(x))

net=Actor(1,1,time.time(),32)

"""
Step 2: Import your fkeras model and get weights
"""

model = load_model('simpleModel.h5')
weights=model.get_weights()


"""
Step 3: Assign those weights to your pytorch model
"""

net.fc1.weight.data=torch.from_numpy(np.transpose(weights[0]))
net.fc1.bias.data=torch.from_numpy(weights[1])
net.fc2.weight.data=torch.from_numpy(np.transpose(weights[2]))
net.fc2.bias.data=torch.from_numpy(weights[3])
net.fc3.weight.data=torch.from_numpy(np.transpose(weights[4]))
net.fc3.bias.data=torch.from_numpy(weights[5])
net.fc4.weight.data=torch.from_numpy(np.transpose(weights[6]))
net.fc4.bias.data=torch.from_numpy(weights[7])
net.fc5.weight.data=torch.from_numpy(np.transpose(weights[8]))
net.fc5.bias.data=torch.from_numpy(weights[9])


"""
Step 4: test  and save your pytorch model
"""
pyPredict0=net.forward(torch.from_numpy(xReal).float())

fig1, ax1 = plt.subplots()
ax1.plot(xReal,yReal,'r',label='Sin Wave')
#ax1.scatter(x,y)
ax1.plot(xReal,yPred,label='Keras')
ax1.plot(xReal,pyPredict0.detach().numpy(),'k',linestyle=':',label='PyTorch')
ax1.set_xlabel('Input')
ax1.set_ylabel('Error')
ax1.set_title('PyTorch Vs Keras Vs Real')
ax1.legend(loc='upper left')
fig1.savefig('KerasVsPyTorch',dpi=500)
pyPredict1=net.forward(torch.from_numpy(x).float())

fig2, ax2 = plt.subplots()
ax2.scatter(x,yPredVal-pyPredict1.detach().numpy())

meanError=np.mean(yPredVal-pyPredict1.detach().numpy())
ax2.set_xlabel('Input')
ax2.set_ylabel('Error')
ax2.set_title('Error')
fig2.savefig('Error',dpi=500)

print('Mean Error {}'.format(meanError))
torch.save(net.state_dict(), 'simpleModel.pt')
