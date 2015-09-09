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
	for c,myclass in enumerate(classes):

		#Init and get class
		T1 = numpy.zeros((1,4097))
		T2 = numpy.zeros((1,4097))
		T3 = numpy.zeros((1,214))
		myclass = classes[c]
		print 'Running on class: ' + myclass


		#Find All Files
		filelist = []
		for root, dirs, files in os.walk('/home/ubuntu/databases/mynet/train/' + myclass):
			for filename in files:
				filefull = root + '/' + filename
				filelist.append(filefull)



		#Save Filelist
		with open(myclass,'w') as f:
			f.write(str(len(filelist)) + '\n')
			for thisfile in filelist:
				f.write(thisfile + '\n')


		#Run Torch Command
		cmdstr = 'th activation.lua -model model_11.t7 -category ' + myclass
		os.system(cmdstr)



		#Read Resulting Matrix
		count = 0
		with open('L1','r') as f:
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
		X = numpy.reshape(X,(len(filelist),4096))
		C = numpy.zeros((len(filelist),4097))
		C[:,:-1] = X
		C[:,-1] = c
		T1 = numpy.concatenate((T1,C))



		#Read Resulting Matrix
		count = 0
		with open('L2','r') as f:
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
		X = numpy.reshape(X,(len(filelist),4096))
		C = numpy.zeros((len(filelist),4097))
		C[:,:-1] = X
		C[:,-1] = c
		T2 = numpy.concatenate((T2,C))



		#Read Resulting Matrix
		count = 0
		with open('L3','r') as f:
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
		T3 = numpy.concatenate((T3,C))



		#Clean up
		os.system('rm L1')
		os.system('rm L2')
		os.system('rm L3')
		os.system('rm ' + myclass)
	
	
		#Store full matrix
		scipy.io.savemat('activations/' + myclass + '.mat', {'filelist':filelist,'T1':T1,'T2':T2,'T3':T3})	
