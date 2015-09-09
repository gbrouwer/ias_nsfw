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
cA1L1 = torch.Tensor(55,55)
cA2L1 = torch.Tensor(55,55)



--Loop
cutorch.synchronize()
for i=1,1 do--nImages do


	--Get Image URL	
	imageURL = file:readString('*l')
	print(imageURL)


	--Read Iamge
	img = testHook({3,256,256},imageURL)


	--Predict
	prediction = localmodel:forward(img:cuda())


	--GPU1
	a1l1 = localmodel:get(1):get(1):get(1).output
	--a1l2 = localmodel:get(1):get(1):get(4).output
	--a1l3 = localmodel:get(1):get(1):get(7).output
	--a1l4 = localmodel:get(1):get(1):get(9).output
	--a1l5 = localmodel:get(1):get(1):get(11).output

	--GPU1
	a2l1 = localmodel:get(1):get(2):get(1).output
	--a2l2 = localmodel:get(1):get(2):get(4).output
	--a2l3 = localmodel:get(1):get(2):get(7).output
	--a2l4 = localmodel:get(1):get(2):get(9).output
	--a2l5 = localmodel:get(1):get(2):get(11).output


	--To Float
	--a1l1 = a1l1:float()
	--a1l2 = a1l2:float()
	--a1l3 = a1l3:float()
	--a1l4 = a1l4:float()
	--a1l5 = a1l5:float()
	--a2l1 = a2l1:float()
	--a2l2 = a2l2:float()
	--a2l3 = a2l3:float()
	--a2l4 = a2l4:float()
	--a2l5 = a2l5:float()


	--Find Maximum
	--a1l1 = torch.max(a1l1,1)
	--a1l2 = torch.max(a1l2,1)
	--a1l3 = torch.max(a1l3,1)
	--a1l4 = torch.max(a1l4,1)
	--a1l5 = torch.max(a1l5,1)
	--a2l1 = torch.max(a2l1,1)
	--a2l2 = torch.max(a2l2,1)
	--a2l3 = torch.max(a2l3,1)
	--a2l4 = torch.max(a2l4,1)
	--a1l5 = torch.max(a2l5,1)


	--Store
	--print(a1l1)
	--print(a1l1)
	--cA1L1 = a1l1[{1,1,{},{}}]
	--cA2L1 = a2l1[{1,1,{},{}}]

end
--a1l1 = a1l1:float()
--a2l1 = a2l1:float()


--Save and Close
torch.save('a1l1',a1l1,'ascii')
torch.save('a2l1',a2l1,'ascii')
file:close()
collectgarbage()
