%EPrime Output Processing Script by Yang Ding
%Purpose: This script walks through the output TXT files and creates the corresponding onset files that may be used in SPM for ONSET purposes. 
%Date: 2014-10-09

clc;
clear;
indexFailedCase = 0;
failedFolder = [];

%Add dependencies of the Mat Lab Functional Library.
%addpath([fileparts(mfilename('fullpath')),'\FunLib']);
%addpath(pwd,'\FunLib']);

%Enter here the working directory (that contains all script files)
strDataDir = Function_GetFolder('Select Your Default Data Directory','C:\Github\Balloon-Task-Extraction-Script');

%Enter Data Directory
cd (strDataDir);

%Enter the script directory by automatically defaulting to the current
%folder the script resides. 
%strScriptDir = Function_GetFolder('Select Your Default Script Direcotry',fileparts(mfilename('fullpath')));

%strScriptDir = mfilename('fullpath');
%addpath(strScriptDir);

%Store list of files:
structFileList = dir('BART-Recode*.txt');


%Check if this line contain:  (order does not matter, it will check
%eveyrthing. More efficient implementation would use TREE branching, but
%sigh, not enough time. 
    %RT / RTTime
    listKeywords{1} = '.RT';
    %OnsetTime.	
    listKeywords{2} = '.OnsetTime';
    %ROJitter
    listKeywords{3} = 'ROJitterDur';
    %JitterDuratino
    listKeywords{4} = 'JitterDuration';
    %MakeChoice.RT	
    listKeywords{5} = 'CurrentWager';
    %MakeCHoice.RESP
    listKeywords{6} = 'MakeChoice.RESP';
    %TotalRewardAttrib
    listKeywords{7} = 'TotRewardAttrib';
    %Inflation Number
    listKeywords{8} = 'InflationNumber';
    %BalloonNumber
    listKeywords{9} = 'BalloonNumber';
    %CurrentWager
    listKeywords{10} = 'Outcome';
    %newCurrentWager
    listKeywords{11} = '.OffsetTime';
    
    listKeywords{12} = 'MakeChoice.RTTime';
    
    listKeywords{13} = 'FeedbackWait.OnsetTime';
    listKeywords{14} = 'FeedbackWait.OffsetTime';
    listKeywords{15} = 'FeedbackWait.Duration';
    
    listKeywords{16} = 'FeedbackWin.OnsetTime';
    listKeywords{17} = 'FeedbackWin.Offset';
    listKeywords{18} = 'FeedbackWin.Duration';
    
    listKeywords{19} = 'FeedbackExplode.OnsetTime';
	listKeywords{20} = 'FeedbackExplode.Offset';
	listKeywords{21} = 'FeedbackExplode.Duration';
    
    listKeywords{22} = 'FeedbackLose.OnsetTime';
	listKeywords{23} = 'FeedbackLose.Offset';
	listKeywords{24} = 'FeedbackLose.Duration';
    
    listKeywords{25} = 'ITI.OnsetTime';
    listKeywords{26} = 'ITI.OffsetTime';
    listKeywords{27} = 'ITI.Duration';
    
    listKeywords{28} = 'ROJitter.OnsetTime';
    listKeywords{29} = 'ROJitter.OffsetTime';
    listKeywords{30} = 'ROJitter.Duration';
    
    listKeywords{31} = 'FixationScreen.OnsetTime';
	listKeywords{32} = 'FixationScreen.OffsetTime';
  

%Find number of subjects that I will have to loop through
intSubjectCount = size(structFileList, 1);

% File Loop in folder that fulfill the criteria
%For each file in FileList, Do these:
for intCurrentSubject = 1 : intSubjectCount
   
    
	%List of subjects name read in a txt file
	fid = fopen(structFileList(intCurrentSubject).name, 'r');
    % Line Loop, through the entire task.
    % Doe an end of file check first. 
    
    %Initialize parameters after each new subject acquisition. 
    intLineNumber = 0;
    %Initialize array to empty after each export.
    arrayCSVOutput = [];
    %Initialize CSV row number. 
    intCSVRowCounter = 0;
    
    %While not at the end of the file
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
                %The output may have TWO or THREE cells. 
                
                %TWO CELLS SCENERIO
                %FIRST Cell being the CONTEXT.
                %SECOND Cell benig the MEASUREMENT.
                
                %THREE CELLS SCENERIO
                %FIRST Cell being the CONTEXT.
                %SECOND Cell benig the TYPE of AMOUNT. %Second Part is WAGE?TOTAL?
                %THIRD Cell being the AMOUNT.  %Third Part is the actual amount. 
                                
                %Take FIRST CELL output and further process it with the "."delimiter
                cellStringOutput = textscan(cellRawOutput{1,1}{1},'%s', 'delimiter', '.');
                %This may results in multiple cells. 
                %FIRST CELL: the CONTEX
                %TYPE of MEASUREMENT at the CONTEX
                
                %Write to matrix
                
                %OUTPUT1: Line number. 
                arrayCSVOutput{intCSVRowCounter,1} = intLineNumber;
                
                %OUTPUT2: context
                arrayCSVOutput{intCSVRowCounter,2} = cellStringOutput{1,1}{1};
                
                %OUTPUT3: measurement type                
                %ONE : , ONE .
                if size(cellRawOutput{1},1) == 2 && size(cellStringOutput{1},1) == 2 
                    %First string is the CONTEX, output to Column 3.
                    arrayCSVOutput{intCSVRowCounter,3} = cellStringOutput{1}{2};
                    arrayCSVOutput{intCSVRowCounter,4} = cellRawOutput{1}{2};
                %ONE :, NO .
                elseif size(cellRawOutput{1},1) == 2 && size(cellStringOutput{1},1) == 1 
                    arrayCSVOutput{intCSVRowCounter,3} = [];
                    arrayCSVOutput{intCSVRowCounter,4} = cellRawOutput{1}{2};
                %TWO :, ONE . 
                elseif size(cellRawOutput{1},1) == 3 && size(cellStringOutput{1},1) == 1                                         
                    arrayCSVOutput{intCSVRowCounter,3} = cellRawOutput{1}{2};
                    arrayCSVOutput{intCSVRowCounter,4} = cellRawOutput{1}{3};                                        
                else
                    warndlg('Unhandled Branching Conditions Cases!')
                end             
                
                
            end
        end
    end
    
    [strFilePath,strFileName,strFileExt] = fileparts(structFileList(intCurrentSubject).name);
    
    %Check for file existence, delete if needed. 
    if exist([strFileName,'.xls'],'file') == 2
        delete([strFileName,'.xls'])
    end
    
    %Only output CSV if the file is correct
    if ~isempty(arrayCSVOutput)
        %Write this subject:        
        xlswrite(strFileName,arrayCSVOutput)
    else
        disp('No Valid Data Found to be Exported. The input file is accepted but does not contain data that matched extraction criteria.')
    end
end


	% Check file ends

	
		
		%Store LINE number to each entries (Column 1 Output). 
		
		
		
		%WaitScanner.RTTime: 188867
	
