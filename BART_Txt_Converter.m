%EPrime Output Processing Script by Yang Ding
%Purpose: This script walks through the output TXT files and creates the corresponding onset files that may be used in SPM for ONSET purposes. 
%Date: 2014-10-09

clc;
clear;
indexFailedCase = 0;
failedFolder = [];

%Add dependencies of the Mat Lab Functional Library.
addpath([pwd,'/FunLib']);

%Enter here the working directory (that contains all script files)
strDataDir = Function_GetFolder('Select Your Default Data Directory','C:\Github\Balloon-Task-Extraction-Script');

%Enter Data Directory
cd (strDataDir);

%Enter the script directory by automatically defaulting to the current
%folder the script resides. 
strScriptDir = Function_GetFolder('Select Your Default Script Direcotry',fileparts(mfilename('fullpath')));

%strScriptDir = mfilename('fullpath');
addpath(strScriptDir);

%Store list of files:
structFileList = dir('BART-Recode*.txt');


%Check if this line contain: 
    %RTTime.
    listKeywords{1} = 'RTTime';
    %OnsetTime.	
    listKeywords{2} = 'OnsetTime';
    %BalloonVertSize:
    listKeywords{3} = 'BalloonVertSize';
    %BalloonHorizSize:
    listKeywords{4} = 'BalloonHorizSize';
    %MakeChoice.RT	
    listKeywords{5} = 'MakeChoice.RT';
    %MakeCHoice.RESP
    listKeywords{6} = 'MakeCHoice.RESP';
    %.Key1
    listKeywords{7} = '.Key1';
    %Inflation Number
    listKeywords{8} = 'Inflation Number';
    %BalloonNumber
    listKeywords{9} = 'BalloonNumber';
    %newBalloonHorizoSize
    listKeywords{10} = 'newBalloonHorizoSize';
    %newBalloonVertSize
    listKeywords{11} = 'newBalloonVertSize';

%Find number of subjects that I will have to loop through
intSubjectCount = size(structFileList, 1);
intCSVRowCounter = 0
% File Loop in folder that fulfill the criteria
%For each file in FileList, Do these:
for intCurrentSubject = 1 : intSubjectCount
   
	%List of subjects name read in a txt file
	fid=fopen(structFileList(1).name, 'r')
    % Line Loop, through the entire task.
    % Doe an end of file check first. 
    
    %Initialize LineNumber
    intLineNumber = 0
    while ~feof(fid)
        
        %Increase Line Count
        intLineNumber = intLineNumber + 1;
        %This convert the input text into a list.
        strCurrentLine=fgetl(fid);

        %Loop through all the keywords
        for intCurrentKeyword = 1 : size(listKeywords,2)
            %Check if contain current list of keywords:
            intKeywordPosition{intCurrentKeyword} = strfind(strCurrentLine, listKeywords{intCurrentKeyword});
            %If contain
            if ~isempty(intKeywordPosition{intCurrentKeyword})
                intCSVRowCounter = intCSVRowCounter + 1;
                disp(strCurrentLine)
                
                %Read file and use : as delimiter
                cellRawOutput = textscan(strCurrentLine,'%s', 'delimiter', ':');
                
                %String One use : as delimiter
                cellStringOutput = textscan(cellRawOutput{1,1}{1},'%s', 'delimiter', '.');
                
                %Write to matrix
                arrayCSVOutput{intCSVRowCounter,1} = intLineNumber;
                arrayCSVOutput{intCSVRowCounter,2} = cellStringOutput{1,1}{1};
                if size(cellStringOutput{1,1},1) == 2 
                    arrayCSVOutput{intCSVRowCounter,3} = cellStringOutput{1,1}{2};
                else
                    arrayCSVOutput{intCSVRowCounter,3} = 'unknown';
                end             
                arrayCSVOutput{intCSVRowCounter,4} = cellRawOutput{1,1}{2};
                
            end
        end
    end
    
    [strFilePath,strFileName,strFileExt] = fileparts(structFileList(1).name);
    
    %Write this subject:
    xlswrite(strFileName,arrayCSVOutput)
 
end


	% Check file ends

	
		
		%Store LINE number to each entries (Column 1 Output). 
		
		
		
		%WaitScanner.RTTime: 188867
	
