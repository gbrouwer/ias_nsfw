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
		myclass = classes[c]
		myclass = classes[c]
		print 'Running on class: ' + myclass


		#Find All Files
		filelist = []
		for root, dirs, files in os.walk('/home/ubuntu/databases/mynet/train/' + myclass):
			for filename in files:
				filefull = root + '/' + filename
				filelist.append(filefull)
		filelist = filelist[::50]
		filelist = filelist[4:5]


		#Save Filelist
		with open(myclass,'w') as f:
			f.write(str(len(filelist)) + '\n')
			for thisfile in filelist:
				f.write(thisfile + '\n')


		#Run Torch Command
		cmdstr = 'th lowlevel.lua -model model_10.t7 -category ' + myclass
		os.system(cmdstr)



		#Read Resulting Matrix
		count = 0
		with open('a1l1','r') as f:
			for i in range(20):
				line = f.readline()
				line = line.rstrip()
				if 'torch.CudaStorage' in line:
					count = count + 1
					nElements = int(f.readline().rstrip())
					data = f.readline()
				
					#Transform
					data = data.split(' ')
					data = [float(datum) for datum in data]
					a1l1 = numpy.array(data)


		#Reshape
		a1l1 = numpy.reshape(a1l1,(10,48,55,55))



		#Read Resulting Matrix
		count = 0
		with open('a2l1','r') as f:
			for i in range(20):
				line = f.readline()
				line = line.rstrip()
				if 'torch.CudaStorage' in line:
					count = count + 1
					nElements = int(f.readline().rstrip())
					data = f.readline()
				
					#Transform
					data = data.split(' ')
					data = [float(datum) for datum in data]
					a2l1 = numpy.array(data)


		#Reshape
		a2l1 = numpy.reshape(a2l1,(10,48,55,55))



		#Clean up
		os.system('rm a1l1')
		os.system('rm a2l1')
		os.system('rm ' + myclass)
	
	

		#Store full matrix
		scipy.io.savemat('lowlevel/' + myclass + '.mat', {'filelist':filelist,'a1l1':a1l1,'a2l1':a2l1})
