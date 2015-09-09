import os
import sys
import numpy



#----------------------------------------------------------------
if __name__ == '__main__':

	
	#Read Dictionary
	D = {}
	#with open('dictionary','r') as f:
	#	for line in f:
	#		elements = line.rstrip().split('\t')
	#		D[elements[0]] = elements[1]


	#Read Class file
	mylist = []
	with open('classes','r') as f:
		for line in f:
			line = line.rstrip()
			try:
				cat = int(line)
				if (cat == 911):
					descr = line
					mylist.append((line,descr))
			except ValueError:
				if line in D:
					descr = D[line]
				else:
					descr = line
				mylist.append((line,descr))

	
	#Write Categories
	with open('categories','w') as f:
		for item in mylist:
			left,right = item
			f.write(left + '\t' + right + '\n')
