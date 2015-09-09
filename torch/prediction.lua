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



--Evaluation Mode
localmodel:evaluate()



--Read Images
file = torch.DiskFile(arg[4], 'r')
nImages = file:readString('*l')
nImages = tonumber(nImages)
print(nImages)


--Empty Tesnor
Y = torch.Tensor(nImages,213)



--Loop
cutorch.synchronize()
for i=1,nImages do

	--Get Image URL	
	imageURL = file:readString('*l')
	print(imageURL)

	--Read Iamge
	img = testHook({3,256,256},imageURL)

	--Predict
	prediction = localmodel:forward(img:cuda())
	prediction = prediction:float()
	
	--Find Maximum
	x = torch.max(prediction,1)

	--Add to Tensor
	Y[{i,{}}] = x

end



--Save and Close
torch.save('prediction',Y,'ascii')
file:close()
collectgarbage()
