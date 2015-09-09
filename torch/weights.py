import sys
import os
import numpy
import scipy.io


#--------------------------------------------------------------------------------
if __name__ == '__main__':


	#Run Torch Command
	cmdstr = 'th weights.lua -model model_10.t7'
	os.system(cmdstr)



	#Read Conv1l1
	count = 0
	with open('weights/conv1l1','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(48,3,11,11))
	scipy.io.savemat('weights/conv1l1.mat', {'conv1l1':X})	



	#Read Conv1l2
	count = 0
	with open('weights/conv1l2','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(128,48,5,5))
	scipy.io.savemat('weights/conv1l2.mat', {'conv1l2':X})



	#Read Conv1l3
	count = 0
	with open('weights/conv1l3','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(192,128,3,3))
	scipy.io.savemat('weights/conv1l3.mat', {'conv1l3':X})



	#Read Conv1l4
	count = 0
	with open('weights/conv1l4','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(192,192,3,3))
	scipy.io.savemat('weights/conv1l4.mat', {'conv1l4':X})	


	#Read Conv1l5
	count = 0
	with open('weights/conv1l5','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(128,192,3,3))
	scipy.io.savemat('weights/conv1l5.mat', {'conv1l5':X})		



	#Read Conv1l1
	count = 0
	with open('weights/conv2l1','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(48,3,11,11))
	scipy.io.savemat('weights/conv2l1.mat', {'conv2l1':X})	



	#Read Conv1l2
	count = 0
	with open('weights/conv2l2','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(128,48,5,5))
	scipy.io.savemat('weights/conv2l2.mat', {'conv2l2':X})



	#Read Conv1l3
	count = 0
	with open('weights/conv2l3','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(192,128,3,3))
	scipy.io.savemat('weights/conv2l3.mat', {'conv2l3':X})



	#Read Conv1l4
	count = 0
	with open('weights/conv2l4','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(192,192,3,3))
	scipy.io.savemat('weights/conv2l4.mat', {'conv2l4':X})	


	#Read Conv1l5
	count = 0
	with open('weights/conv2l5','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(128,192,3,3))
	scipy.io.savemat('weights/conv2l5.mat', {'conv2l5':X})	





	#Read Class1
	count = 0
	with open('weights/classl1','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(4096,9216))
	scipy.io.savemat('weights/classl1.mat', {'classl1':X})	



	#Read Class1
	count = 0
	with open('weights/classl2','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(4096,4096))
	scipy.io.savemat('weights/classl2.mat', {'classl2':X})	



	#Read Class1
	count = 0
	with open('weights/classl3','r') as f:
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
				X = numpy.array(data)

	#Reshape and save
	X = numpy.reshape(X,(4096,213))
	scipy.io.savemat('weights/classl3.mat', {'classl3':X})	

