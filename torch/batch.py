import sys
import os
import numpy
import scipy.io

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
			


	#Loop through classes
	T = numpy.zeros((1,214))
	for c,myclass in enumerate(classes):
		print 'Running on class: ' + myclass

		#Find All Files
		filelist = []
		for root, dirs, files in os.walk('/home/ubuntu/databases/mynet/val/' + myclass):
			for filename in files:
				filefull = root + '/' + filename
				filelist.append(filefull)



		#Save Filelist
		with open(myclass,'w') as f:
			f.write(str(len(filelist)) + '\n')
			for thisfile in filelist:
				f.write(thisfile + '\n')



		#Run Torch Command
		cmdstr = 'th prediction.lua -model model_11.t7 -category ' + myclass
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
		C = numpy.zeros((len(filelist),214))
		C[:,:-1] = X
		C[:,-1] = c
		T = numpy.concatenate((T,C))


		print len(classes)
		#Find and write
		with open('predictions/' + myclass + '.pred','w') as fout:
			for i in range(len(filelist)):
				x = X[i,:]
				fout.write(filelist[i] + ',')
				indices = x.argsort()[-5:][::-1]
				for index in range(4):
					fout.write(classes[indices[index]] + ',')
				fout.write(classes[indices[4]] + '\n')

		#Clean up
		os.system('rm prediction')
		os.system('rm ' + myclass)

	#Store full matrix
	scipy.io.savemat('predictions.mat', {'T':T})	
