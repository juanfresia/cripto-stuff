#!/usr/bin/python
#Covered by GPL V2.0
import time
import string
import httplib,sys
from socket import *
import re
import getopt
import urllib
import time
import os

#Cheers to Trompeti, deepbit, Scorpionn, Javier Mendez  and all s21sec crew ;)

print "\n*************************************"
print "*MetaGooFil Ver. 1.4a		    *"
print "*Coded by Christian Martorella      *"
print "*Edge-Security Research             *"
print "*cmartorella@edge-security.com      *"
print "*************************************\n\n"


global word,w,limit,result,extcommand
#Win
##extcommand='c:\extractor\\bin\extract.exe -l libextractor_ole2'
#OSX
extcommand='/opt/local/bin/extract'
#Cygwin
#extcommand='/cygdrive/c/extractor/bin/extract.exe'
extcommand='/usr/bin/extract'

result =[]
global dir
dir = "none"


def usage():
 print "MetaGooFil 1.4\n"
 print "usage: metagoofil options \n"
 print "	-d: domain to search"
 print " 	-f: filetype to download (all,pdf,doc,xls,ppt,odp,ods, etc)"
 print "	-l: limit of results to work with (default 100)"
 print "	-o: output file, html format."
 print "	-t: target directory to download files.\n"
 print "	Example: metagoofil.py -d microsoft.com -l 20 -f all -o micro.html -t micro-files\n"
 sys.exit()


#Mac address extractor#
def get_mac(file,dir):
	 	filename=dir+"/"+file	
		line=open(filename,'r')
		res=""
		for l in line:
			res+=l
		macrex=re.compile('-[0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z]\}')	
		macgetter=macrex.findall(res)
		if macgetter==[]:
			mac=''
		else:
			mac=macgetter[0]
			mac=mac.strip("-")
			mac=mac.strip("}")
			mac=mac[:2]+":"+mac[2:4]+":"+mac[4:6]+":"+mac[6:8]+":"+mac[8:10]+":"+mac[10:12]
		return mac


def howmany(w):
	 h = httplib.HTTP('www.google.com')
	 h.putrequest('GET',"/search?num=100&start=0+hl=en&btnG=B%C3%BAsqueda+en+Google&meta=&q=site%3A"+w+"+filetype%3A"+file)
      	 h.putheader('Host', 'www.google.com')
	 h.putheader('User-agent', 'Internet Explorer 6.0 ')
	 h.endheaders()
	 returncode, returnmsg, headers = h.getreply()
	 data=h.getfile().read()
	 r1 = re.compile('about <b>[0123456789,]*</b> from')
	 result = r1.findall(data)
	 if result ==[]:
	     r1 = re.compile('of <b>[0123456789,]*</b> from')
	     result = r1.findall(data)
	 for x in result:
	 	clean = re.sub(' <b>','',x)
		clean = re.sub('</b> ','',clean)
		clean = re.sub('about','',clean)
		clean = re.sub('from','',clean)
		clean = re.sub(',','',clean)
		clean = re.sub('of','',clean)

	 if len(result) == 0:
		clean = 0
	 return clean



def run(w,i):
	res = []
	h = httplib.HTTP('www.google.com')
	h.putrequest('GET',"/search?num=20&start="+str(i)+"&hl=en&btnG=B%C3%BAsqueda+en+Google&meta=&q=site%3A"+w+"+filetype%3A"+file)
	h.putheader('Host', 'www.google.com')
	h.putheader('User-Agent','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6')
	h.endheaders()
	returncode, returnmsg, headers = h.getreply()
	data=h.getfile().read()
	#r1 = re.compile('\[[A-Z]*\]</b>(<)/font></span> <h2 class=[^>]+><a href="([^"]+)"')
	r1 = re.compile('><a href="([^"]+.'+file+')"')
	res = r1.findall(data)
	return res



def test(argv):
	global limit
	global file
	limit=20
	down ='a'
	if len(sys.argv) < 11:
		usage()
	try :
		opts, args = getopt.getopt(argv,"l:d:f:o:t:")
	except getopt.GetoptError:
		usage()
	for opt,arg in opts:
		if opt == '-l':
			limit = int(arg)
        	elif opt == '-d':
            		word = str(arg)
        	elif opt == '-f':
            		file = str(arg)
        	elif opt == '-o':
            		ofile = str(arg)
		elif opt =='-t':
			dir = str(arg)
	if dir == 'none':
		dir = word
	if file != 'all':
		all=[file]
	else:
		all=['pdf','doc','xls','ppt','sdw','mdb','sdc','odp','ods']
	try:
		fil = open(ofile,'w')
	except:
		print "Failed"
	test=extcommand.split(" ")[0]
	if os.path.isfile(test):
		print "[+] Command extract found, proceeding with leeching"
	else:
		print "Command extract not found, please check and change the location"
		sys.exit()
	date= time.strftime("%a, %d %b %Y %H:%M:%S +0000", time.gmtime())
	fil.write("<style type=\"text\/css\"><!--BODY{font-family:sans-serif;}--></style>")
	fil.write("<center><b>Meta<font color=\"#0000cc\">G</font><font color=\"#ff0000\">o</font><font color=\"#ffff00\">o</font>fil</b> results page for:</center>")
	fil.write("<center><b>"+word+"</b></center>")
	fil.write("<center>"+date+"</center>")
	fil.write("<center><a href=\"http://www.edge-security.com\">By Edge-Security</a></center>")
	fil.write("<hr>")
	fil.write('<a href="#users">Results: Go directly to resuls.</a>')
	authors=[]
	pathos=[]
	for fi in all:
		file = fi
		print "[+] Searching in " + word + " for: " + file
		total = int(howmany(word))
		print "[+] Total results in google: "+ str(total)
		if total == 0:
			pass
		else:
			cant = 0
			fil.write("<hr>")
			fil.write("<strong><u>Searching in " + word + " for: " + file+" files.</u></strong><br><br>")
			if total < limit:
				limit=total
			print "[+] Limit: ",int(limit)
			result=[]
			while cant < limit:
				print "[+] Searching results: " + str(cant) +"\r"
				res = run(word,cant)
				for x in res:
					if result.count(x) == 0:
						if x.count('http')!=0:
							result.append(x)
						else:
							pass
				cant+=20
			fil.write("<strong>Total available files: "+str(total)+" </strong><br>")
			t=0
			if os.path.exists(dir):
				print "[+] Directory "+	dir + " already exist, reusing it"
			else:
				os.mkdir(dir)
			cantidad_todo=len(result)
			contador=0
			for x in result:
				contador+=1
				fil.write(x+"<br>")
				try:
					if down == "a"	:
						np = 0
						res=x.split('://')[1]
						res=res.split("/")
						leng=len(res)
						filename=res[leng-1]
						try:
							print "\t[ "+str(contador)+"/"+str(cantidad_todo)+" ] "+ x
							if os.path.exists(dir+'/'+filename):
								pass
							else:
								urllib.urlretrieve(x,str(dir)+"/"+str(filename))
						except IOError:
							print "Can't download"
							np = 1
						if np == 0:
							fil.write("<br>Local copy " + "<a href=\""+dir+"/"+filename+'\">Open</a>')
							fil.write("<br><br>Important metadata:")
							command = extcommand +' '+ dir +'/'+'"'+filename+'"'
							try:
								stdin,stderr = os.popen4(command)
							except:
								print "Error executing extract, maybe the binary path is wrong."
								fil.write('<br>')
							mac=get_mac(filename,dir)
							if file == 'pdf':
								fil.write('<pre style=\"background:#C11B17;border:1px solid;\" >')
							elif file == 'doc':
								fil.write('<pre style=\"background:#6698FF;border:1px solid;\">')
							elif file == 'xls':
								fil.write('<pre style=\"background:#437C2C;border:1px solid;\">')
							elif file == 'ppt':
								fil.write('<pre style=\"background:#E56717;border:1px solid;\">')
							else:
								fil.write('<pre style=\"background:#827839;border:1px solid;\">')
							if mac !='':
								fil.write('Mac address:' + mac +'\n' )
							else:
								pass
							for line in stderr.readlines():
								fil.write(line)
								au = re.compile('Author -.*')
								aut= au.findall(line)
								if aut != []:
									author=aut[0].split('- ')[1]
									if authors.count(author) == 0:
										authors.append(author)
								
								au = re.compile('creator -.*')
								aut= au.findall(line)
								if aut != []:
									author=aut[0].split('- ')[1]
									if authors.count(author) == 0:
										authors.append(author)

								last = re.compile('last saved by -.*')
								aut= last.findall(line)
								if aut != []:
									author=aut[0].split('- ')[1]
									if authors.count(author) == 0:
										authors.append(author)
						    		
								rev = re.compile(': Author \'.*\'')
								aut=rev.findall(line)
								if aut != []:
									author=aut[0].split('\'')[1]
									author=string.replace(author,'\'','')
									if authors.count(author) == 0:
										authors.append(author)

								pa= re.compile('worked on .*')
								pat=pa.findall(line)
								if pat !=[]:
									if pathos.count(pat) == 0:
										temp=pat[0].split('\'')[1]
										pathos.append(temp)
								pat=[]	
								pa= re.compile('template -.*')
								pat=pa.findall(line)
								if pat !=[]:
									if pathos.count(pat) == 0:
										temp=pat[0].split('-')[1]
										pathos.append(temp)
							fil.write('</pre>')
							fil.write('<hr>')
						else:
							print "Can't Download "+ x 
							fil.write("<br>Local copy, failed download :(\n")
							fil.write('<hr>')
					else:
						print "====================="
				except KeyboardInterrupt:
						print "Process Interrupted by user\n"
						sys.exit()
				t+=1
			fil.write("<strong>Total results for "+fi+": "+ str(t)+ "</strong><br>")
	fil.write('<hr>')	
	fil.write('<a name="users">')
	fil.write('<br>')
	fil.write('<b><h2>Total authors found (potential users):</h2></b>')
	fil.write('<pre style=\"background:#737ca1;border:1px solid;\">')
	print "\n"
	print "Usernames found:"
	print "================"		
	if authors != []:
		for x in authors:
				fil.write( str(x)+'<br>')
				print str(x)
	else:
		fil.write("0 users found.<br>")
	fil.write('</pre>')
	print "\n"
	print "Paths found:"
	print "============"	
	fil.write('<b><h2>Path Disclosure:</h2></b>')
	fil.write('<pre style=\"background:#c8bbbe;border:1px solid;\">')
	paty=[]
	if pathos != []:
		for x in pathos:
				temp=""
				a=x.split('\\')
				for x in a:
					if x.count('.'):
						pass
					else:
						temp=temp+x+"\\"
				if paty.count(temp):
					pass
				else:
					fil.write(str(temp)+'<br>')
					paty.append(temp)
					print temp
	else:
			 fil.write('0 path found.<br>')
	fil.write('</pre>')
	print "[+] Process finished"

if __name__ == "__main__":
        try: test(sys.argv[1:])
	except KeyboardInterrupt:
		print "Process interrupted by user.."
	except:
		sys.exit()

