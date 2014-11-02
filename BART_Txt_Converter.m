%EPrime Output Processing Script by Yang Ding
%Purpose: This script walks through the output TXT files and creates the corresponding onset files that may be used in SPM for ONSET purposes.
%Currently, it is specifically designed to walk through one experiment
%called BART

%Date: 2014-10-09

%

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
listKeywords{1} = 'FixationScreen.OnsetTime';
%OnsetTime.
listKeywords{2} = 'FixationScreen.OffsetTime';
%ROJitter
listKeywords{3} = 'MakeChoice.OnsetTime';
%JitterDuratino
listKeywords{4} = 'MakeChoice.Key1';
%MakeChoice.RT
listKeywords{5} = 'CurrentWager';
%MakeCHoice.RESP
listKeywords{6} =  'Outcome';
%TotalRewardAttrib
listKeywords{7} = 'TotRewardAttrib';
%Inflation Number
listKeywords{8} = 'InflationNumber';
%BalloonNumber
listKeywords{9} = 'BalloonNumber';
%CurrentWager
listKeywords{10} = 'MakeChoice.RT';
%newCurrentWager
listKeywords{11} ='MakeChoice.RESP';

listKeywords{12} = 'ROJitter.Duration';

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

listKeywords{30} = 'LogFrame';
listKeywords{31}= 'ITI.OnsetDelay';

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
    arrayOutputBuffer = [];
    
    %Initialize Buffer row number.
    intBufferRow= 0;
    
    %Initialize CSV row, block numbers and various buffers.
    intCSVRow= 0;
    intBlock= 0;
    intBlockOnsetTime = 0;
    arrayCSVBuffer = [];
    
    %While not at the end of the file
    while ~feof(fid)
        
        %Increase Line Count
        intLineNumber = intLineNumber + 1;
        
        %This convert the input text into a list.
        strCurrentLine=fgetl(fid);
        
        %Loop through all the keywords one at a time.
        for intCurrentKeyword = 1 : size(listKeywords,2)
            %Check if contain current list of keywords:
            intKeywordPosition{intCurrentKeyword} = strfind(strCurrentLine, listKeywords{intCurrentKeyword});
            
            %If contain one of the keywords,
            if ~isempty(intKeywordPosition{intCurrentKeyword})
                
                %Check Keyword reflect frame order. 
                if ~isempty(strfind(strCurrentLine, 'LogFrame Start'))
                    %Initialize BUFFER:
                    arrayOutputBuffer = [];
                    intBufferRow= 0;
                    
                    %Store previous onset time to ensure that DEDUPLICATION
                    %process works. 
                    intPreviousOnsetTime = intBlockOnsetTime;
                    
                    %Reinitializae current block onset time. 
                    intBlockOnsetTime=0;
                    %Increase block counter. 
                    intBlock= intBlock+ 1;
                
                    
                    
               %Recognize these lines as record breakers and fix them
               %accordingly.
                elseif  ~isempty(strfind(strCurrentLine, 'MakeChoice.Key1')) || ~isempty(strfind(strCurrentLine, 'ITI.OnsetDelay'))
                    %Terminate earlier block
                    arrayCSVBuffer{intBlock,1} = arrayOutputBuffer;
                    arrayCSVBuffer{intBlock,2} = intBlockOnsetTime;

                    %Initialize new block
                    %Initialize BUFFER:
                    arrayOutputBuffer = [];
                    intBufferRow= 0;
                    
                    %Store previous onset time to ensure that DEDUPLICATION
                    %process works. 
                    intPreviousOnsetTime = intBlockOnsetTime;
                    
                    %Reinitializae current block onset time. 
                    intBlockOnsetTime=0;
                    %Increase block counter. 
                    intBlock= intBlock+ 1;


                elseif ~isempty(strfind(strCurrentLine, 'LogFrame End'))  
%                     
%                     %Check for duplicaiton blocks:
%                     if intBlockOnsetTime == intPreviousOnsetTime && intPreviousOnsetTime ~= 0
%                         %if duplication in onset time exist, overwrite
%                         %previous output. 
%                         intBlock= intBlock-1;
%                         %Empty previous values
%                         arrayCSVBuffer{intBlockCounter,1}=[];
%                         arrayCSVBuffer{intBlockCounter,2}=[];
%                     end
%                     
                    %Copy all contents of Buffer to CSV Row.                    
                    arrayCSVBuffer{intBlock,1} = arrayOutputBuffer;
                    arrayCSVBuffer{intBlock,2} = intBlockOnsetTime;
                %Only process the line if it does not contain LogFrame
                %information.
                else
                    
                    
                    %Increase CSVRowCounter
                    intBufferRow= intBufferRow+ 1;

                    %Display current line.
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
                    
                    %Additionally, log BlockOnsetTime if this block is
                    %about OnsetTime.
                    if ~isempty(strfind(strCurrentLine, 'OnsetTime')) && intBlockOnsetTime == 0
                        intBlockOnsetTime = str2num(cellRawOutput{1}{2});
                    end
                    
                    
                    %Write to matrix                                  
                    
                    %OUTPUT1: Line number.
                    arrayOutputBuffer{intBufferRow,1} = intLineNumber;
                    
                    %OUTPUT2: context
                    arrayOutputBuffer{intBufferRow,2} = cellStringOutput{1,1}{1};
                    
                    %OUTPUT3: measurement type
                    %ONE : , ONE .
                    if size(cellRawOutput{1},1) == 2 && size(cellStringOutput{1},1) == 2
                        %First string is the CONTEX, output to Column 3.
                        arrayOutputBuffer{intBufferRow,3} = cellStringOutput{1}{2};
                        arrayOutputBuffer{intBufferRow,4} = cellRawOutput{1}{2};
                        arrayOutputBuffer{intBufferRow,5} = intBlockOnsetTime;
                        %ONE :, NO .
                    elseif size(cellRawOutput{1},1) == 2 && size(cellStringOutput{1},1) == 1
                        arrayOutputBuffer{intBufferRow,3} = [];
                        arrayOutputBuffer{intBufferRow,4} = cellRawOutput{1}{2};
                        arrayOutputBuffer{intBufferRow,5} = intBlockOnsetTime;
                        %TWO :, ONE .
                    elseif size(cellRawOutput{1},1) == 3 && size(cellStringOutput{1},1) == 1
                        arrayOutputBuffer{intBufferRow,3} = cellRawOutput{1}{2};
                        arrayOutputBuffer{intBufferRow,4} = cellRawOutput{1}{3};
                        arrayOutputBuffer{intBufferRow,5} = intBlockOnsetTime;                        
                    else
                        warndlg('Unhandled Branching Conditions Cases for String Input!')
                    end
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
    if ~isempty(arrayCSVBuffer)
        %Resort arrays based on the actual ONSET time.
        arraySortedCSVBuffer = sortrows (arrayCSVBuffer,2);
        
        %Initialize CSVOutput
        arrayCSVOutput=[];
        intCSVOutputBlock= 1;
        intPreviousCSVBufferBlock=1;
        
        %Going to loop through the buffer and clean out duplicate by not
        %copying them to the Output.
        for intCSVBufferBlock= 1 : size(arraySortedCSVBuffer,1)
            %If duplication is expeirenced
            if arraySortedCSVBuffer {intCSVBufferBlock,2}== arraySortedCSVBuffer{intPreviousCSVBufferBlock,2} && intCSVBufferBlock ~= 1
                %Overwrite the previous block. 
                intCSVOutputBlock = intCSVOutputBlock-1;
            end
            
            arrayCSVOutput {intCSVOutputBlock,1} =  arraySortedCSVBuffer {intCSVBufferBlock,1};
            arrayCSVOutput {intCSVOutputBlock,2} =  arraySortedCSVBuffer {intCSVBufferBlock,2};

            %Increase output row counter            
            intCSVOutputBlock= intCSVOutputBlock+1;                   
            
            %Keep track of previous BufferBlock number.
            intPreviousCSVBufferBlock= intCSVBufferBlock;
        end
        
        %This function loops through all the cellarray.
        for intArrayCurrentBlock = 1 : size(arrayCSVOutput,1)
            %Copy Each row
            for intArrayCurrentRow = 1: size (arrayCSVOutput{intArrayCurrentBlock,1}, 1)
                
                %Increase row count 
                intCSVRow = intCSVRow + 1;
                %Copy each column
                for intArrayCurrentColumn = 1: 4
                    arrayCSV{intCSVRow,intArrayCurrentColumn} = arrayCSVOutput{intArrayCurrentBlock,1}{intArrayCurrentRow, intArrayCurrentColumn};
                end
                
            end
            
        end
        
        
        
        %Write this subject:
        xlswrite(strFileName,arrayCSV)
    else
        disp('No Valid Data Found to be Exported. The input file is accepted but does not contain data that matched extraction criteria.')
    end
end


% Check file ends



%Store LINE number to each entries (Column 1 Output).



%WaitScanner.RTTime: 188867

