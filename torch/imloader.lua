local gm = assert(require 'graphicsmagick')
ffi=require 'ffi'
require 'image'



--Init Sizes
local loadSize   = {3, 256, 256}
local sampleSize = {3, 224, 224}



--Mean and STD
local meanstd = torch.load('model/meanstdCache.t7')
mean = meanstd.mean
std = meanstd.std



--Function to load the image, do 10 crops (center + 4 corners) and their hflips
testHook = function(self, path)

   local oH = sampleSize[2]
   local oW = sampleSize[3];
   local out = torch.Tensor(10, 3, oW, oH)
   local input = gm.Image():load(path, loadSize[3], loadSize[2])

   --Find the smaller dimension, and resize it to 256 (while keeping aspect ratio)
   local iW, iH = input:size()
   if iW < iH then
      input:size(256, 256 * iH / iW);
   else
      input:size(256 * iW / iH, 256);
   end
   iW, iH = input:size();
   local im = input:toTensor('float','RGB','DHW')
   -- mean/std
   for i=1,3 do -- channels
      if mean then im[{{i},{},{}}]:add(-mean[i]) end
      if  std then im[{{i},{},{}}]:div(std[i]) end
   end

   local w1 = math.ceil((iW-oW)/2)
   local h1 = math.ceil((iH-oH)/2)
   out[1] = image.crop(im, w1, h1, w1+oW, h1+oW) -- center patch
   out[2] = image.hflip(out[1])
   h1 = 1; w1 = 1;
   out[3] = image.crop(im, w1, h1, w1+oW, h1+oW)  -- top-left
   out[4] = image.hflip(out[3])
   h1 = 1; w1 = iW-oW;
   out[5] = image.crop(im, w1, h1, w1+oW, h1+oW)  -- top-right
   out[6] = image.hflip(out[5])
   h1 = iH-oH; w1 = 1;
   out[7] = image.crop(im, w1, h1, w1+oW, h1+oW)  -- bottom-left
   out[8] = image.hflip(out[7])
   h1 = iH-oH; w1 = iW-oW;
   out[9] = image.crop(im, w1, h1, w1+oW, h1+oW)  -- bottom-right
   out[10] = image.hflip(out[9])

   return out
end

