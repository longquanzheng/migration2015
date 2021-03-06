#!/usr/local/bin/python
#------------------------------------------------------
print "Content-Type: text/html\n\n";
print "<!DOCTYPE html>"
#----------------------------------------------
#### Programmed by Youn Shik Park

import cgi, cgitb, os, string, random, datetime, glob, locale
from string import split,join
form = cgi.FieldStorage()
cgitb.enable()

def isFloat(string):
  try:
    ret = float(string)
  except:
    ret = 0
  return ret


def isInt(string):
  try:
    ret = int(string)
  except:
    ret = 0
  return ret

def isStr(string):
  try:
    ret = str(string);
  except:
    ret = 0
  return ret


#----S input----------------------------------------------------------------------------------------------------
ystime = isStr(form.getvalue('ystime'))
numWSD = isInt(form.getvalue('numWSD'))
path = './tmp/' + ystime + '/'
simDir = glob.glob(path + 'sim_*')
status = isInt(len(simDir))
status = status + 1
mkSimDir = 'mkdir ' + path + 'sim_' + isStr('%03i'%status)
os.system(mkSimDir)
cpInp = 'cp ' + path + 'inp/*.* ' + path + 'sim_' + isStr('%03i'%status) + '/.'
os.system(cpInp)
pathSim = path + 'sim_' + isStr('%03i'%status) + '/'
cpPcp = 'cp ' + path + 'cligen/pcp.txt ' + pathSim + '/.'
os.system(cpPcp)

#--myOptPar.pys
cpOptFile = 'cp ' + path + 'myOptPar.pys ' + pathSim + '.'
os.system(cpOptFile)

#print '<li>', ystime, numWSD, status

#----BMP set 1, excluding URBAN BMP (all bmp tables excluding urban)
BMPset_1 = [0.0] * 6
for i in range(1,6) :
  BMPset_1[i] = [0.0] * numWSD
  for j in range(1,numWSD) :
    BMPset_1[i][j] = [0.0] * 7
    for k in range(1,7) :
      tmpVal = isStr(form.getvalue('BMP_' + isStr(i) + '_' + isStr('%02i' % isInt(j)) + isStr(k)))
      if ( tmpVal == 'None' or tmpVal == '' ) :
        BMPset_1[i][j][k] = '%.4f' % isFloat(0.0)
      else :
        BMPset_1[i][j][k] = '%.4f' % isFloat(tmpVal)

#---BMP set2, Urban Concentration, UrbnCnon, "Urban" sheet, Table 1 (static data)
BMPset_2 = [0.0] * 5
for i in range(1,5) :
  BMPset_2[i] = [0.0] * 10
  for j in range(1,10) :
    tmpVal = isStr(form.getvalue('UrbnConc_' + isStr(i) + isStr(j)))
    if ( tmpVal == 'None' or tmpVal == '' ) :
      BMPset_2[i][j] = '%.4f' % isFloat(0.0)
    else :
      BMPset_2[i][j] = '%.4f' % isFloat(tmpVal)
 
#----BMP set3, Urban BMP, "Urban" sheet: Table 2a, 3.2a, 3.3a, 3.4a, 3.5a (urbanMap)
BMPset_3 = [0.0] * 6
for i in range(1,6) :
  BMPset_3[i] = [0.0] * numWSD 
  for j in range(1,numWSD) :
    BMPset_3[i][j] = [0.0] * 10
    for k in range(1,10) :
      tmpVal = isStr(form.getvalue('UrbanBMP_' + isStr(i) + '_' + isStr('%02i' % isInt(j)) + isStr(k)))
      if ( tmpVal == 'None' or tmpVal == '' ) :
        BMPset_3[i][j][k] = '%.4f' % isFloat(0.0)
      else :
        BMPset_3[i][j][k] = '%.4f' % isFloat(tmpVal)
#----E input----------------------------------------------------------------------------------------------------
#-------------S BMPs.txt----------------------------------------------------------------------------------------
try:
  BMPsFile = open(pathSim + 'BMPs.txt','w')

  BMPsFile.write('\tN\tP\tBOD\tSediment\tAppliedArea\tBMP\n')
  for i in range(1,numWSD) :
    BMPsFile.write(isStr(BMPset_1[1][i][1]) + '\t')
    BMPsFile.write(isStr(BMPset_1[1][i][2]) + '\t')
    BMPsFile.write(isStr(BMPset_1[1][i][3]) + '\t')
    BMPsFile.write(isStr(BMPset_1[1][i][4]) + '\t')
    BMPsFile.write(isStr(BMPset_1[1][i][6]) + '\t')
    BMPsFile.write(isStr(isInt(isFloat(BMPset_1[1][i][5]))) + '\n')
  BMPsFile.write('\n')

  BMPsFile.write('\tN\tP\tBOD\tSediment\tAppliedArea\tBMP\n')
  for i in range(1,numWSD) :
    BMPsFile.write(isStr(BMPset_1[2][i][1]) + '\t')
    BMPsFile.write(isStr(BMPset_1[2][i][2]) + '\t')
    BMPsFile.write(isStr(BMPset_1[2][i][3]) + '\t')
    BMPsFile.write(isStr(BMPset_1[2][i][4]) + '\t')
    BMPsFile.write(isStr(BMPset_1[2][i][6]) + '\t')
    BMPsFile.write(isStr(isInt(isFloat(BMPset_1[2][i][5]))) + '\n')
  BMPsFile.write('\n')

  BMPsFile.write('\tN\tP\tBOD\tSediment\tAppliedArea\tBMP\n')
  for i in range(1,numWSD) :
    BMPsFile.write(isStr(BMPset_1[3][i][1]) + '\t')
    BMPsFile.write(isStr(BMPset_1[3][i][2]) + '\t')
    BMPsFile.write(isStr(BMPset_1[3][i][3]) + '\t')
    BMPsFile.write(isStr(BMPset_1[3][i][4]) + '\t')
    BMPsFile.write(isStr(BMPset_1[3][i][6]) + '\t')
    BMPsFile.write(isStr(isInt(isFloat(BMPset_1[3][i][5]))) + '\n')
  BMPsFile.write('\n')

  BMPsFile.write('\tN\tP\tBOD\tSediment\tAppliedArea\tBMP\n')
  for i in range(1,numWSD) :
    BMPsFile.write(isStr(BMPset_1[4][i][1]) + '\t')
    BMPsFile.write(isStr(BMPset_1[4][i][2]) + '\t')
    BMPsFile.write(isStr(BMPset_1[4][i][3]) + '\t')
    BMPsFile.write(isStr(BMPset_1[4][i][4]) + '\t')
    BMPsFile.write(isStr(BMPset_1[4][i][6]) + '\t')
    BMPsFile.write(isStr(isInt(isFloat(BMPset_1[4][i][5]))) + '\n')
  BMPsFile.write('\n')

  BMPsFile.write('\tN\tP\tBOD\tSediment\tAppliedArea\tBMP\n')
  for i in range(1,numWSD) :
    BMPsFile.write(isStr(BMPset_1[5][i][1]) + '\t')
    BMPsFile.write(isStr(BMPset_1[5][i][2]) + '\t')
    BMPsFile.write(isStr(BMPset_1[5][i][3]) + '\t')
    BMPsFile.write(isStr(BMPset_1[5][i][4]) + '\t')
    BMPsFile.write(isStr(BMPset_1[5][i][6]) + '\t')
    BMPsFile.write(isStr(isInt(isFloat(BMPset_1[5][i][5]))) + '\n')

  BMPsFile.write('------------ Followings are BMPs for Urban-------------------------------------------------\n')

  for i in range(1,5) :
    for j in range(1,10) :
      BMPsFile.write(isStr(BMPset_2[i][j]) + '\t')
    BMPsFile.write('\n')
  BMPsFile.write('\n')

  for i in range(1,numWSD) :
    for j in range(1,10) :
      BMPsFile.write(isStr(BMPset_3[1][i][j]) + '\t')
    BMPsFile.write('\n')
  BMPsFile.write('\n')

  for i in range(1,numWSD) :
    for j in range(1,10) :
      BMPsFile.write(isStr(BMPset_3[2][i][j]) + '\t')
    BMPsFile.write('\n')
  BMPsFile.write('\n')

  for i in range(1,numWSD) :
    for j in range(1,10) :
      BMPsFile.write(isStr(BMPset_3[3][i][j]) + '\t')
    BMPsFile.write('\n')
  BMPsFile.write('\n')

  for i in range(1,numWSD) :
    for j in range(1,10) :
      BMPsFile.write(isStr(BMPset_3[4][i][j]) + '\t')
    BMPsFile.write('\n')
  BMPsFile.write('\n')

  for i in range(1,numWSD) :
    for j in range(1,10) :
      BMPsFile.write(isStr(BMPset_3[5][i][j]) + '\t')
    BMPsFile.write('\n')
  BMPsFile.write('\n')

  BMPsFile.close()
except:
  BMPsFile = 0


#-------------E BMPs.txt----------------------------------------------------------------------------------------
#-----------------------------S Copy STEPL Fortran and Run------------------------------------------------------
cpCmd = 'cp ' + path + 'stepl ' + pathSim + '.'
try:
  os.system(cpCmd)
  os.chdir(pathSim)
  #print '<li>', os.getcwd()
  os.system('./stepl')
  os.chdir('../../../')
except:
  print("<!--error-->")
#print '<li>', os.getcwd()
#-----------------------------E Copy STEPL Fortran and Run------------------------------------------------------
#----S Read Result File-----------------------------------------------------------------------------------------
tmpStr = pathSim + 'myRST.csv'
#print '<li>', tmpStr
#print '<li>', pathSim
try:
  rstFile = open(pathSim + 'myRST.csv','r')
  rst = rstFile.readlines()
  rstFile.close()
except:
  rstFile = 0

try:
  rst[0] = rst[0].split(',')
  for i in range(1,len(rst)) :
    rst[i] = rst[i].replace('\r','')
    rst[i] = rst[i].replace('\n','')
    for j in range(4) :
      rst[i] = rst[i].replace('  ',' ')
    rst[i] = rst[i].split(' ')
except:
  print("<!--Error-->")

#for i in range(len(rst)) :
#  print '<li>', rst[i]
#print '<hr>'
#----E Read Result File-----------------------------------------------------------------------------------------

#-------------------------------------------------------S change columns rst >> rst3----------------------------
rst3 = []

try:
  rst3Str = isStr(rst[0][0]) + ',' 
  rst3Str += isStr(rst[0][1]) + ',' + isStr(rst[0][5]) + ',' + isStr(rst[0][9]) + ',' + isStr(rst[0][13]) + ','
  rst3Str += isStr(rst[0][2]) + ',' + isStr(rst[0][6]) + ',' + isStr(rst[0][10]) + ',' + isStr(rst[0][14]) + ','
  rst3Str += isStr(rst[0][3]) + ',' + isStr(rst[0][7]) + ',' + isStr(rst[0][11]) + ',' + isStr(rst[0][15]) + ','
  rst3Str += isStr(rst[0][4]) + ',' + isStr(rst[0][8]) + ',' + isStr(rst[0][12]) + ',' + isStr(rst[0][16])
  rst3.append(rst3Str)

  for i in range(1,len(rst)) :
    rst3Str = isStr(rst[i][1]) + ',' 
    rst3Str += isStr(rst[i][2]) + ',' + isStr(rst[i][6]) + ',' + isStr(rst[i][10]) + ',' + isStr(rst[i][14]) + ','
    rst3Str += isStr(rst[i][3]) + ',' + isStr(rst[i][7]) + ',' + isStr(rst[i][11]) + ',' + isStr(rst[i][15]) + ','
    rst3Str += isStr(rst[i][4]) + ',' + isStr(rst[i][8]) + ',' + isStr(rst[i][12]) + ',' + isStr(rst[i][16]) + ','
    rst3Str += isStr(rst[i][5]) + ',' + isStr(rst[i][9]) + ',' + isStr(rst[i][13]) + ',' + isStr(rst[i][17]) 
    rst3.append(rst3Str)
  #  print '<li>', rst[i][0], rst[i][1], rst[i][3]
  #  print '<li>----', rst3[i] 
    rst3[0] = rst3[0].replace('  ','')
except:
  print("<!--error-->")
#-------------------------------------------------------E change columns rst >> rst3----------------------------

#------------------------------------------S Plot---------------------------------------------------------------
#for i in range(1,len(rst)) :
#  print '<li>', rst[i][2], '::', rst[i][3], '::', rst[i][4], '::', rst[i][5]
#print '<hr>'

#for i in range(1,len(rst)) :
#  print '<li>', rst[i][10], '::', rst[i][11], '::', rst[i][12], '::', rst[i][13]
#print '<hr>'

#for i in range(1,len(rst)) :
#  print '<li>', rst[i][14], '::', rst[i][15], '::', rst[i][16], '::', rst[i][17]
#print '<hr>'

Narr = []
Parr = []
Barr = []
Sarr = []

try:
  for i in range(1,len(rst)) :
    N_Str1 = 'W' + isStr(i) + '\\n(' + isStr('%.2f'%isFloat(rst[i][14])) + ')\t' + isStr('%.2f'%isFloat(rst[i][2])) + '\t' + isStr('%.2f'%isFloat(rst[i][10]))
    P_Str1 = 'W' + isStr(i) + '\\n(' + isStr('%.2f'%isFloat(rst[i][15])) + ')\t' + isStr('%.2f'%isFloat(rst[i][3])) + '\t' + isStr('%.2f'%isFloat(rst[i][11]))
    B_Str1 = 'W' + isStr(i) + '\\n(' + isStr('%.2f'%isFloat(rst[i][16])) + ')\t' + isStr('%.2f'%isFloat(rst[i][4])) + '\t' + isStr('%.2f'%isFloat(rst[i][12]))
    S_Str1 = 'W' + isStr(i) + '\\n(' + isStr('%.2f'%isFloat(rst[i][17])) + ')\t' + isStr('%.2f'%isFloat(rst[i][5])) + '\t' + isStr('%.2f'%isFloat(rst[i][13]))
    Narr.append(N_Str1)
    Parr.append(P_Str1)
    Barr.append(B_Str1)
    Sarr.append(S_Str1)
except:
  print("<!--error-->")

try:
  #---last line -> total
  N_Str2 = Narr[-1].split('(')
  Narr[-1] = 'Total\\n(' + N_Str2[1]
  P_Str2 = Parr[-1].split('(')
  Parr[-1] = 'Total\\n(' + P_Str2[1]
  B_Str2 = Barr[-1].split('(')
  Barr[-1] = 'Total\\n(' + B_Str2[1]
  S_Str2 = Sarr[-1].split('(')
  Sarr[-1] = 'Total\\n(' + S_Str2[1]
except:
  print("<!--error-->")


#----dat files
def datFile(pathSim,myArr,myName) :
  if ( myName == 'B' ) :
    headerName = 'BOD'
  else :
    headerName = myName
  
  #print '<li>', len(myArr)

  myDat = open(pathSim + myName + 'gnu.dat','w')
  myDat.write('Watershed\t' + headerName + '_Load_(no_BMP)\t' + headerName + '_Load_(with_BMP)\n')
  if ( len(myArr) < 3 ) :
    myDat.write(myArr[-1] + '\n')
  else :
    for i in range(len(myArr)) :
      myDat.write(myArr[i] + '\n')
  myDat.close()

datFile(pathSim,Narr,'N')
datFile(pathSim,Parr,'P')
datFile(pathSim,Barr,'B')
datFile(pathSim,Sarr,'S')


#----script files
def sctFile(pathSim,myName) :
  #----define min & max
  maxVal = 0
  myDatFile = open(pathSim + myName + 'gnu.dat','r')
  myDat = myDatFile.readlines()
  myDatFile.close()
  for i in range(1,len(myDat)) :        # first line is header
    if ( 2 < len(myDat[i]) ) :
      tmpDat = myDat[i].replace('\r','')
      tmpDat = tmpDat.replace('\n','')
      tmpDat = tmpDat.split('\t')
      tmpDat[1] = float(tmpDat[1])
      tmpDat[2] = float(tmpDat[2])
      if ( maxVal <= tmpDat[1] ) :
        maxVal = tmpDat[1]
      if ( maxVal <= tmpDat[2] ) :
        maxVal = tmpDat[2]
      maxVal = maxVal * 1.2
  maxVal = '%.2f'%maxVal
  sctArr = [''] * 40
  sctArr[1] = 'set key top left\n'
  sctArr[2] = 'set terminal jpeg font "Helvetica,10"\n'
  sctArr[4] = 'set xtics border in scale 1,0.5 nomirror rotate by 0  offset character 0, 0.5, -2\n'
  sctArr[6] = 'set yrange[0.00:' + str(maxVal) + ']\n'
  #sctArr[6] = 'set autoscale y\n'
  sctArr[8] = 'set autoscale y2\n'
  sctArr[10] = 'set output "' + pathSim + myName + '_bar.jpg"\n'
  sctArr[12] = 'set xlabel "Watershed (Reduction, %)"\n'
  if ( myName == 'S' ) :
    sctArr[14] = 'set ylabel "Annual Loads (tons)"\n'
  else :
    sctArr[14] = 'set ylabel "Annual Loads (lbs)"\n'
  #sctArr[16] = 'set y2label "Total Annual Loads (lbs)"\n'
  sctArr[18] = 'set style data histogram\n'
  sctArr[20] = 'set style histogram cluster gap 1\n'
  sctArr[22] = 'set style fill solid border -1\n'
  sctArr[24] = 'set boxwidth 0.9\n'
  sctArr[26] = 'plot "' + pathSim + myName + 'gnu.dat' + '" using 2:xtic(1) ti col lt 1, "" u 3 ti col lt 2 \n'

  mySct = open(pathSim + myName + 'gnu.script','w')
  for i in range(len(sctArr)) :
    if ( 2 < len(sctArr[i]) ) :
      mySct.write(sctArr[i])
  mySct.close()    
  gnuplotExe = 'gnuplot ' + pathSim + myName + 'gnu.script'
  os.system(gnuplotExe)

sctFile(pathSim,'N')
sctFile(pathSim,'P')
sctFile(pathSim,'B')
sctFile(pathSim,'S')
#------------------------------------------E Plot---------------------------------------------------------------
#----S Result File to Download----------------------------------------------------------------------------------
#dwDatFile = open(pathSim + 'myRST.csv','r')
#dwDat = dwDatFile.readlines()
#dwDatFile.close()

#for i in range(6) :
#  dwDat[0] = dwDat[0].replace('  ','')

#for i in range(1,len(dwDat)) :
#  dwDat[i] = dwDat[i].replace(' ',',')
try:
  dwFile = open(pathSim + 'AnnualLoads.csv','w')
  for i in range(len(rst3)) :
  #  dwFile.write(dwDat[i][1:])
    dwFile.write(rst3[i] + '\n')

  dwFile.write('\n\n----\n')
  dwFile.write('Unit is "ton/year" for sediment and is "lb/year" for the others.\n')
  dwFile.close()
except:
  dwFile = 0

locale.setlocale(locale.LC_ALL, 'en_US')

try:
  for i in range(len(rst3)) :
    rst3[i] = rst3[i].split(',')
    if ( 0 < i ) :
      for j in range(len(rst3[i])) :
        if ( 0 < j ) :
          rst3[i][j] = isStr(locale.format('%d',isInt(isFloat(rst3[i][j])+0.5),1))
except:
  print("<!--error-->")
#  print '<li>', rst3[i]
#----E Result File to Download----------------------------------------------------------------------------------
#---------------------------S HTML------------------------------------------------------------------------------
print '<html>'
print '<head>'
print '<meta charset="UTF-8"> '
print '  <title>Web-based STEPL</title>'
print '<script>'
print 'function runTable1() {'
#print ' alert( document.table1.ystime.value );'
print ' if (document.table1.numWSD.value*1.0 > 0 ) document.table1.submit(); '
print '}'
print 'function runBMP() {'
#print ' alert( document.table1.ystime.value );'
print ' if (document.table1.numWSD.value*1.0 > 0 ) document.table2.submit(); '
print '}'
print '</script>'
print '</head>'
print '<body>'
print '<br><img style="margin: 0 auto; display:block " src="./img/STEPL_WEB_title.jpg" alt=" " width=400><br>'
print '<form name=main>'
print '  <br><br>'
print '  <table style="margin: 0px auto; width: 1100px" border=1>'
print '  <tr>'
print '    <td style="text-align:center; vertical-align:middle; font-weight:bold">'
print '      Annual Loads Summary'
dwnBtn = '<input type=button style=\'width:240;height:30;cursor:hand\' value=\'Click to Download\''
dwnBtn += ' onClick="javascript:window.open(\'' + pathSim + 'AnnualLoads.csv' + '\');">'
print dwnBtn
print '<input type=button style="width:200;height:30;cursor:hand;float:center;" value="Print"'
print 'onClick="javascript:window.print();"></td> '

print '  </tr></table>'
print '  <table style="margin: 0px auto; width: 1100px" border=1>'

clmArr = [0,1,3,4,5,7,8,9,11,12,13,15,16]
for i in range(len(rst3)) :
  if ( i < 1 ) :							# header
    for j in range(len(clmArr)):
      rst3[i][clmArr[j]] = rst3[i][clmArr[j]].replace('Sediment','S')
      rst3[i][clmArr[j]] = rst3[i][clmArr[j]].replace('Sed','S')
      rst3[i][clmArr[j]] = rst3[i][clmArr[j]].replace('%','')
      rst3[i][clmArr[j]] = rst3[i][clmArr[j]].replace('(','<br>(')
      if ( j == 1 or j == 2 or j == 4 or j ==5 or j == 7 or j == 8 ) :
        rst3[i][clmArr[j]] = rst3[i][clmArr[j]].replace(')',')<br>lbs/year')
      elif ( j == 3 or j == 6 or j == 9 or j == 12 ) :
        rst3[i][clmArr[j]] = rst3[i][clmArr[j]].replace('Reduction','Reduction<br>%')
      else :
        rst3[i][clmArr[j]] = rst3[i][clmArr[j]].replace(')',')<br>tons/year')

  print '    <tr>'
  if ( i == 0 ) :
    opt1 = ' align=center><b><font size=2 face="Times New Roman"'
  else :
    opt1 = ' align=right><font size=2 face="Times New Roman"'
  for j in range(len(clmArr)) :
    if ( j < 1 ) :
      opt2 = ' width=80'
    else :
      opt2 = ' width=85'
    tdStr = '      <td' + opt2 + opt1 + '>' + isStr(rst3[i][clmArr[j]]) + '</td>'
    print tdStr
  print '    </tr>'
print '  </table>'

print '<br><hr><br>'

Nstr = '<img src="' + pathSim + 'N_bar.jpg" width=400>'
Pstr = '<img src="' + pathSim + 'P_bar.jpg" width=400>'
Bstr = '<img src="' + pathSim + 'B_bar.jpg" width=400>'
Sstr = '<img src="' + pathSim + 'S_bar.jpg" width=400>'

print '<table  style="margin: 0px auto;" border=1>'
print '  <tr>'
print '    <td style="text-align:center; vertical-align:middle;" colspan=2>Graphs</td>'
print '  </tr>'
print '  <tr>'
print '    <td style="text-align:center; vertical-align:middle;">', Nstr, '</td>'
print '    <td style="text-align:center; vertical-align:middle;">', Pstr, '</td>'
print '  </tr>'
print '  <tr>'
print '    <td style="text-align:center; vertical-align:middle;">', Bstr, '</td>'
print '    <td style="text-align:center; vertical-align:middle;">', Sstr, '</td>'
print '  </tr>'
print '</table><br><hr><br>'

print '</form>'

print '<table style="margin: 0px auto; border:0;" >'
print '<tr style="text-align:left"><td>'
print 'Your Log ID is </td><td><span style="color:blue">', ystime , '</span></td></tr>'
print '<tr>'
print '<td>'
print 'Restart STEPL From'
print '</td>'
print '<td>'
print ' <input type=button style=\'width:240px;height:30px;cursor:hand\' value=\'Input Form\''
print ' onClick="runTable1()"> '
print '</td>'
print '<td>'
print ' <input type=button style=\'width:240px;height:30px;cursor:hand\' value=\'BMP Form\''
print ' onClick="runBMP()"> '
print '</td>'
print '</tr></table><br>'

print '<div style="text-align:center; font-size:0.82em; color:grey"><hr>'
print '    Copyright &copy; 2015, Purdue University and Kangwon National University, all rights reserved. <br>'
print '    Purdue University is an equal access/equal opportunity university.<br>'
print '  Contact <a href=mailto:engelb@purdue.edu>Dr. Bernie Engel</a>'
print '  or <a href=mailto:theller@purdue.edu>Larry Theller</a> for more details if you need any help with STEPL WEB. '
print '  <br>'
print '  This implementation of the classic EPA model was designed by Dr. <a href=mailto:ysparkwithyou@gmail.com>Youn Shik Park</a>, Assistant Professor, Kongju National University, South-Korea.'
print '  <br>Programmatic support from US EPA, Illinois-Indiana Sea Grant,  and US Army Corp of Engineers.'
print '</div><br>'

print '<a href="' + pathSim + 'myRST.csv" target=new><span style="color:white">.</span></a>'

print '<form name=table1 method="POST" action="./inputMain.cgi" target="_blank">'
print '<input type=hidden name=numWSD  value='+ str(numWSD-1) + '>'
print '<input type=hidden name=numGLY  value=0>'
print '<input type=hidden name=numSTR  value=0>'
print '<input type=hidden name=rerun value=1>'
print '<input type=hidden name=ystime value=' + str(ystime) + '>'
print '<input type=hidden name=ystimeldc value="noldc">'
print '</form>'

print '<form name=table2 method="POST" action="./inputMain.cgi" target="_blank">'
print '<input type=hidden name=numWSD  value='+ str(numWSD-1) + '>'
print '<input type=hidden name=numGLY  value=0>'
print '<input type=hidden name=numSTR  value=0>'
print '<input type=hidden name=rerun value=2 >'
print '<input type=hidden name=ystime value=' + str(ystime) + '>'
print '<input type=hidden name=ystimeldc value="noldc">'
print '</form>'


print '</body>'
print '</html>'
#---------------------------E HTML------------------------------------------------------------------------------



ch777 = 'chmod 777 ' + isStr(pathSim)
try:
  os.system(ch777)
except:
  print("<!--error-->")

ch777 = 'chmod 777 ' + isStr(pathSim) + '*.*'

try:
  os.system(ch777)
except:
  print("<!--error-->")


