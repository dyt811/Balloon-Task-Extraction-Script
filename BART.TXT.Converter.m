%EPrime Output Processing Script by Yang Ding
%Purpose: This script walks through the output TXT files and creates the corresponding onset files that may be used in SPM for ONSET purposes. 
%Date: 2014-10-09

clc;
clear;
indexFailedCase = 0;
failedFolder = [];


%Enter here the working directory (that contains all script files)
dataDir = Function_GetFolder('Select Your Default Data Directory','/Users/Stephane/Documents/MRI_Data_SRD/Protocole_Inhibition_Suicide/');

%Enter Data Directory
cd (dataDir);

%Enter the script directory.
scriptDir = Function_GetFolder('Select Your Default Script Direcotry',fileparts(mfilename('fullpath')));

%scriptDir = mfilename('fullpath');
addpath(scriptDir);

%Store list of files:
fileList = ls('*.txt');

% File Loop in folder that fulfill the criteria
%For each file in FileList, Do these:

[nb_subjects List] = Function_ReadList('List_Subjects.txt');


	%List of subjects name read in a txt file
	fid=fopen('BART-Recode','r'); %ENTER TEXT FILE NAME
 
	%This convert the input text into a list.
	InputText=textscan(fid,'%s');

	%This extract the variable from inputText
	Intro=InputText{1};

	%Transpose into into horizontal vector/list
	List=transpose(Intro);
 
            %Notify end user.
            disp('Here are the subjects that I will process:')
            %Display the list
            disp(List);
 
%             %check how many subjects we got.
%             nb_subjects=length(List);

%Notify end user.
disp('Here are number of subjects I will process based on earlier list:')
disp(nb_subjects);
 

	% Check file ends

	% Line Loop, through the entire task.
		
		%Store LINE number to each entries (Column 1 Output). 
		
		
		%Check if this line contain: 
			%RTTime.
			%OnsetTime.	
			%BalloonVertSiize:
			%BalloonHorizSiize:
			%MakeChoice.RT	
			%MakeCHoice.RESP
			%.Key1
			%Inflation Number
			%BalloonNumber
			%newBalloonHorizoSize
			%newBalloonVertSize
		
		%WaitScanner.RTTime: 188867
	
