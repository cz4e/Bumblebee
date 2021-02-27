#!/usr/bin/env python3

import re
import csv

dict_arr2b = ['predec_left_buf_2b', 'predec_instr_0_2b', 'predec_instr_1_2b', 'predec_instr_2_2b', 'predec_instr_3_2b', 'predec_instr_4_2b', 'predec_instr_5_2b', 'predec_instr_6_2b', 'predec_instr_7_2b']
dict_arr4b = ['predec_left_buf_4b', 'predec_instr_0_4b', 'predec_instr_1_4b', 'predec_instr_2_4b', 'predec_instr_3_4b', 'predec_instr_4_4b', 'predec_instr_5_4b', 'predec_instr_6_4b', 'predec_instr_7_4b']


filename = "./predec.csv"
cross = 'assign predec_cross_instr_nxt = ('

instr0 = []
instr1 = []
instr2 = []
instr3 = []
instr4 = []
instr5 = []
instr6 = []
instr7 = []
with open(filename) as f:
	reader = csv.reader(f)
	header_row = next(reader)
	while reader :
		try:
			line = next(reader)
		except:
			break
		res = 'assign predec_case[' + str(int(line[0]) - 1) + ']\t' + ' = ' + (dict_arr2b[0] + ' & '  if line[1] == '2' else  dict_arr4b[0] + ' & ') \
		    + (dict_arr2b[1] + ' & ' if line[2] == '2' else dict_arr4b[1] + ' & ' if line[2] == '4' else '') + (dict_arr2b[2] + ' & ' if line[3] == '2' else dict_arr4b[2] + ' & ' if line[3] == '4' else '') \
		    + (dict_arr2b[3] + ' & ' if line[4] == '2' else dict_arr4b[3] + ' & ' if line[4] == '4' else '') + (dict_arr2b[4] + ' & ' if line[5] == '2' else dict_arr4b[4] + ' & ' if line[5] == '4' else '') \
		    + (dict_arr2b[5] + ' & ' if line[6] == '2' else dict_arr4b[5] + ' & ' if line[6] == '4' else '') + (dict_arr2b[6] + ' & ' if line[7] == '2' else dict_arr4b[6] + ' & ' if line[7] == '4' else '') \
		    + (dict_arr2b[7] + ' & ' if line[8] == '2' else dict_arr4b[7] + ' & ' if line[8] == '4' else '') + (dict_arr2b[8] if line[9] == '2' else dict_arr4b[8] if line[9] == '4' else '') + ';'
		p1 = ' & ;'
		pa = re.compile(p1)
		res = re.sub(p1, ';', res)
		idx = line[0]
		line = line[1 :-1]
		cnt = 0
		s = []
		res2 = ''
		if line[0] == '2':
			i = 0
			for ch in line[1 : ]:
				if ch == '2':
					s.append([idx, i])
				else:
					if ch == '4' :
						s.append([idx, i, i + 1])
				i = i + 1
		else :
			i = -1
			for ch in line[0 : ]:
				if ch == '2':
					s.append([idx, i])
				else :
					if ch == '4':
						s.append([idx, i, i + 1])
				i = i + 1
		i = 0
		#print(s[0])
		instr0.append(s[0])
		instr1.append(s[1])
		instr2.append(s[2])
		instr3.append(s[3])
		if len(s) > 4:
			instr4.append(s[4])
		if len(s) > 5:
			instr5.append(s[5])
		if len(s) > 6:
			instr6.append(s[6])
		if len(s) > 7:
			instr7.append(s[7])
# print(instr1)
# print(instr2)
# print(instr3)
# print(instr4)
# print(instr5)
len2 = []
len4 = []
for arr in instr0:
	if len(arr) == 2:
		#print(arr[1])
		if not arr[1] in len2:
			len2.append(arr[1])
	else :
		#print(arr[1 : ])
		if not arr[1 : ] in len4:
			len4.append(arr[1 : ])
print(len2)
print(len4)

instr0_sch0 = []
instr0_sch1 = []
instr0_sch2 = []

for inst in instr0:
	if len(inst) == 2:
		instr0_sch0.append(int(inst[0]) - 1)
	else :
		if inst[1] == 0:
			instr0_sch1.append(int(inst[0]) - 1)
		else:
			instr0_sch2.append(int(inst[0]) - 1)
print(instr0_sch0)
print(instr0_sch1)
print(instr0_sch2)

instr1_sch0 = []
instr1_sch1 = []
instr1_sch2 = []
instr1_sch3 = []
for inst in instr1:
	if len(inst) == 2:
		if inst[1] == 1:
			instr1_sch0.append(int(inst[0]) - 1)
		else :
			if inst[1] == 2:
				instr1_sch1.append(int(inst[0]) - 1)
	else :
		if inst[1 : ] == [1, 2]:
			instr1_sch2.append(int(inst[0]) - 1)
		else :
			instr1_sch3.append(int(inst[0]) - 1)
#print(instr1_sch0)
#print(instr1_sch1)
#print(instr1_sch2)
#print(instr1_sch3)

instr2_sch0 = []
instr2_sch1 = []
instr2_sch2 = []
instr2_sch3 = []
instr2_sch4 = []
instr2_sch5 = []

for inst in instr2:
	if len(inst) == 2:
		if inst[1] == 2:
			instr2_sch0.append(int(inst[0]) - 1)
		elif inst[1] == 3:
			instr2_sch1.append(int(inst[0]) - 1)
		elif inst[1] == 4:
			instr2_sch2.append(int(inst[0]) - 1)
	elif len(inst) == 3:
		if inst[1 : ] == [2, 3]:
			instr2_sch3.append(int(inst[0]) - 1)
		elif inst[1 : ] == [3, 4]:
			instr2_sch4.append(int(inst[0]) - 1)
		elif inst[1 : ] == [4, 5]:
			instr2_sch5.append(int(inst[0]) - 1)
#print(instr2_sch0)
#print(instr2_sch1)
#print(instr2_sch2)
#print(instr2_sch3)
#print(instr2_sch4)
#print(instr2_sch5)

instr3_sch0 = []
instr3_sch1 = []
instr3_sch2 = []
instr3_sch3 = []
instr3_sch4 = []
instr3_sch5 = []
instr3_sch6 = []
instr3_sch7 = []

for inst in instr3:
	if len(inst) == 2:
		if inst[1] == 3:
			instr3_sch0.append(int(inst[0]) - 1)
		elif inst[1] == 4:
			instr3_sch1.append(int(inst[0]) - 1)
		elif inst[1] == 5:
			instr3_sch2.append(int(inst[0]) - 1)
		elif inst[1] == 6:
			instr3_sch3.append(int(inst[0]) - 1)
	elif len(inst) == 3:
		if inst[1 : ] == [3, 4]:
			instr3_sch4.append(int(inst[0]) - 1)
		elif inst[1 : ] == [4, 5]:
			instr3_sch5.append(int(inst[0]) - 1)
		elif inst[1 : ] == [5, 6]:
			instr3_sch6.append(int(inst[0]) - 1)
		elif inst[1 : ] == [6, 7]:
			instr3_sch7.append(int(inst[0]) - 1)
#print(instr3_sch0)
#print(instr3_sch1)
#print(instr3_sch2)
#print(instr3_sch3)
#print(instr3_sch4)
#print(instr3_sch5)
#print(instr3_sch6)
#print(instr3_sch7)

instr4_sch0 = []
instr4_sch1 = []
instr4_sch2 = []
instr4_sch3 = []
instr4_sch4 = []
instr4_sch5 = []
instr4_sch6 = []
for inst in instr4:
	if len(inst) == 2:
		if inst[1] == 4:
			instr4_sch0.append(int(inst[0]) - 1)
		elif inst[1] == 5:
			instr4_sch1.append(int(inst[0]) - 1)
		elif inst[1] == 6:
			instr4_sch2.append(int(inst[0]) - 1)
		elif inst[1] == 7:
			instr4_sch3.append(int(inst[0]) - 1)
	elif len(inst) == 3:
		if inst[1: ] == [4, 5]:
			instr4_sch4.append(int(inst[0]) - 1)
		elif inst[1: ] == [5, 6]:
			instr4_sch5.append(int(inst[0]) - 1)
		elif inst[1: ] == [6, 7]:
			instr4_sch6.append(int(inst[0]) - 1)
#print(instr4_sch0)
#print(instr4_sch1)
#print(instr4_sch2)
#print(instr4_sch3)
#print(instr4_sch4)
#print(instr4_sch5)
#print(instr4_sch6)

instr5_sch0 = []
instr5_sch1 = []
instr5_sch2 = []
instr5_sch3 = []
instr5_sch4 = []
for inst in instr5:
	if len(inst) == 2:
		if inst[1] == 5:
			instr5_sch0.append(int(inst[0]) - 1)
		elif inst[1] == 6:
			instr5_sch1.append(int(inst[0]) - 1)
		elif inst[1] == 7:
			instr5_sch2.append(int(inst[0]) - 1)
	elif len(inst) == 3:
		if inst[1 : ] == [5, 6]:
			instr5_sch3.append(int(inst[0]) - 1)
		elif inst[1 : ] == [6, 7]:
			instr5_sch4.append(int(inst[0]) - 1)
#print(instr5_sch0)
#print(instr5_sch1)
#print(instr5_sch2)
#print(instr5_sch3)
#print(instr5_sch4)

instr6_sch0 = []
instr6_sch1 = []
instr6_sch2 = []
for inst in instr6:
	if len(inst) == 2:
		if inst[1] == 6:
			instr6_sch0.append(int(inst[0]) - 1)
		elif inst[1] == 7:
			instr6_sch1.append(int(inst[0]) - 1)
	elif len(inst) == 3:
		if inst[1 : ] == [6, 7]:
			instr6_sch2.append(int(inst[0]) - 1)
# print(instr6_sch0)
# print(instr6_sch1)
# print(instr6_sch2)

instr7_sch0 = []
for inst in instr7:
	if len(inst) == 2:
		if inst[1] == 7:
			instr7_sch0.append(int(inst[0]) - 1)
# print(instr7_sch0)
# 	# print(line)
#		if line[0] == '2':
#			for ch in line[3: ]: 
#				if cnt < 4:
#					if(ch == '2' or ch == '4'):
#						cnt = cnt + 1;
#					else :
#						pass
#				else :
#					#if ch != '0':
#					s.append(ch)
#		else :
#			for ch in line[3 : ]:
#				if cnt < 4:
#					if(ch == '2' or ch == '4'):
#						cnt = cnt + 1;
#					else :
#						pass
#				else :
#					#if ch != '0':
#					s.append(ch)
#		if len(s) == 1:
#			if s[0] == '4':
#				# res2 = res2 + 'predec_case[' + str(int(idx) - 1) + '] | '
#				print(str(int(idx) - 1) + ' ' + str(s))
#		else :
#			if len(s) == 2:
#				if s == ['0', '4']:
#					# res2 = res2 + 'predec_case[' + str(int(idx) - 1) + '] | '
#					print(str(int(idx) - 1) + ' ' + str(s))
		# print(res2)
		# print(idx + ' ' + str(s))
		# cross = cross + ('predec_case[' + str(int(line[0]) - 1) + ']' + ' | ' if line[9] == '4' else '') 
		# print(res)
		# print(cross)
		#	Offset 0
		# offset_0_instr_0 = ('wire predec_offset_0_instr_0_2b = ' \	
		#					+ ())
