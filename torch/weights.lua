require 'nn'
require 'cudnn'
require 'optim'
require 'torch'
require 'cutorch'
require 'paths'
require 'xlua'
require 'optim'
require 'fbcunn'



--Source Image Loader
dofile('imloader.lua')



--Load Model
model = torch.load(paths.concat('model',arg[2]))



--Build Local Model (Features and Classifier)
features = nn.Concat(2)
features:add(model:get(1):get(1))
features:add(model:get(1):get(2))
classifier = nn.Sequential()
classifier = model:get(2)
localmodel = nn.Sequential():add(features):add(classifier)
localmodel = localmodel:cuda()



--Conv1
conv1l1 = localmodel:get(1):get(1):get(1).weight
conv1l2 = localmodel:get(1):get(1):get(4).weight
conv1l3 = localmodel:get(1):get(1):get(7).weight
conv1l4 = localmodel:get(1):get(1):get(9).weight
conv1l5 = localmodel:get(1):get(1):get(11).weight



--Conv2
conv2l1 = localmodel:get(1):get(2):get(1).weight
conv2l2 = localmodel:get(1):get(2):get(4).weight
conv2l3 = localmodel:get(1):get(2):get(7).weight
conv2l4 = localmodel:get(1):get(2):get(9).weight
conv2l5 = localmodel:get(1):get(2):get(11).weight



--Classifier
classl1 = localmodel:get(2):get(3).weight
classl2 = localmodel:get(2):get(6).weight
classl3 = localmodel:get(2):get(8).weight



--Save and Close
torch.save('weights/conv1l1',conv1l1,'ascii')
torch.save('weights/conv1l2',conv1l2,'ascii')
torch.save('weights/conv1l3',conv1l3,'ascii')
torch.save('weights/conv1l4',conv1l4,'ascii')
torch.save('weights/conv1l5',conv1l5,'ascii')
torch.save('weights/conv2l1',conv2l1,'ascii')
torch.save('weights/conv2l2',conv2l2,'ascii')
torch.save('weights/conv2l3',conv2l3,'ascii')
torch.save('weights/conv2l4',conv2l4,'ascii')
torch.save('weights/conv2l5',conv2l5,'ascii')
torch.save('weights/classl1',classl1,'ascii')
torch.save('weights/classl2',classl2,'ascii')
torch.save('weights/classl3',classl3,'ascii')



--Garbage Collection
collectgarbage()
