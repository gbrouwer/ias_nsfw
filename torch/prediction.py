import sys
import os
import numpy


#--------------------------------------------------------------------------------
if __name__ == '__main__':


	#Read Classes
	classes = []
	codes = []
	with open('categories','r') as f:
		for line in f:
			line = line.rstrip()
			elements = line.split('\t')
			codes.append(elements[0])
			elements = elements[1].split(',')
			classes.append(elements[0])
			


	#Display class
	if (sys.argv[1] in codes):
		index = codes.index(sys.argv[1])
		print 'Running on class: ' + classes[index]
	else:
		sys.exit('Class not found, aborting')



	#Find All Files
	filelist = []
	for root, dirs, files in os.walk('/home/ubuntu/databases/mynet/val/' + sys.argv[1]):
		for filename in files:
			filefull = root + '/' + filename
			filelist.append(filefull)
	


	#Save Filelist
	with open(sys.argv[1],'w') as f:
		f.write(str(len(filelist)) + '\n')
		for thisfile in filelist:
			f.write(thisfile + '\n')
	

	#Run Torch Command
	cmdstr = 'th prediction.lua -model model_11.t7 -category ' + sys.argv[1]
	os.system(cmdstr)



	#Read Resulting Matrix
	count = 0
	with open('prediction','r') as f:
		for i in range(20):
			line = f.readline()
			line = line.rstrip()
			if 'torch.DoubleStorage' in line:
				count = count + 1
				nElements = int(f.readline().rstrip())
				data = f.readline()
			
				#Transform
				data = data.split(' ')
				data = [float(datum) for datum in data]
				X = numpy.array(data)

	#Reshape
	X = numpy.reshape(X,(len(filelist),213))



	#Find and write
	with open('predictions/' + sys.argv[1] + '.pred','w') as fout:
		for i in range(len(filelist)):
			x = X[i,:]
			fout.write(filelist[i] + ',')
			indices = x.argsort()[-5:][::-1]
			for index in range(4):
				fout.write(classes[indices[index]] + ',')
			fout.write(classes[indices[4]] + '\n')

	#Clean up
	os.system('rm prediction')
	os.system('rm ' + sys.argv[1])
	
