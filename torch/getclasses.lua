require 'nn'
require 'cunn'
require 'cudnn'
require 'optim'
require 'torch'
require 'cutorch'
require 'paths'
require 'xlua'
require 'optim'





--Load Model
classes = torch.load(paths.concat('model','classes.t7'))
print(classes)



--Save and Close
torch.save('classes',classes,'ascii')





