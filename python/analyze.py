import sys
import os
import numpy
import scipy.io


#------------------------------------------------------------------------------------
def writeGephi(A,wordlist,filename):

    #Write
    with open(filename + '.gml','w') as f:

        #Header
        f.write('Creator "Gijs Joost Brouwer"\n')
        f.write('graph\n')
        f.write('[\n')


        #Write Vertices
        for i,name in enumerate(wordlist):
            f.write('  node\n')
            f.write('  [\n')
            f.write('    id ' + str(i) + '\n')
            f.write('    label "' + name + '"\n')
            f.write('  ]\n')


        #Write Edges
        for i in range(A.shape[0]):
            for j in range(i+1,A.shape[0]):
                value = A[i,j]
                if (value > 0):
                    f.write('  edge\n')
                    f.write('  [\n')
                    f.write('    source ' + str(i) + '\n')
                    f.write('    target ' + str(j)  + '\n')
                    f.write('    value ' + str(value) + '\n')
                    f.write('  ]\n')

#------------------------------------------------------------------------
if __name__ == '__main__':


	#Read Categories
	categories = []
	with open('../meta/categories','r') as f:
		for line in f:
			elements = line.rstrip().split('\t')
			categories.append(elements[0])



	#Init
	C = numpy.zeros((len(categories),len(categories)))
	A = numpy.zeros((len(categories),3))



	#Read
	for i,category in enumerate(categories):
		print i,category
		with open('../predictions/raw/' + category + '.pred','r') as f:
			for line in f:
				elements = line.rstrip().split(',')
				A[i,2] = A[i,2] + 1
				in1 = categories.index(elements[1])
				in2 = i
				C[in1,in2] = C[in1,in2] + 1
				if (in1 == in2):
					A[i,0] = A[i,0] + 1
				if (category in elements):
					A[i,1] = A[i,1] + 1



	#Store
	writeGephi(C,categories,'brandNet')
	scipy.io.savemat('C.mat', {'C':C})
	scipy.io.savemat('A.mat', {'A':A})	