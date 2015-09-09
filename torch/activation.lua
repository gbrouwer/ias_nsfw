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
L1 = torch.Tensor(nImages,4096)
L2 = torch.Tensor(nImages,4096)
L3 = torch.Tensor(nImages,213)



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


	--Activity Patterns	
	A1 = localmodel:get(2):get(3).output
	A2 = localmodel:get(2):get(6).output
	A3 = localmodel:get(2):get(8).output
	A1 = A1:float()
	A2 = A2:float()
	A3 = A3:float()


	--Find Maximum
	A1 = torch.max(A1,1)
	A2 = torch.max(A2,1)
	A3 = torch.max(A3,1)	


	--Add to Tensor
	L1[{i,{}}] = A1
	L2[{i,{}}] = A2
	L3[{i,{}}] = A3

end



--Save and Close
torch.save('L1',L1,'ascii')
torch.save('L2',L2,'ascii')
torch.save('L3',L3,'ascii')
file:close()
collectgarbage()
