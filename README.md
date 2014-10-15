Balloon-Task-Extraction-Script
==============================


A Simple Matlab script to extract Balloon Task written in E-Basic.

For BART, all the task related information are SAVED in “.txt” file. The edat2 files are relatively useless. Do not bother to play with EDAT2.file.

2014-10-15
Download everything from this repo at https://github.com/dyt811/Balloon-Task-Extraction-Script/
Add everything within the folder to Matlab Path.
Run BART_Txt_Converter.m
PASTE the path to the .txt files generated from the E-Prime.
Note the file has to start like 'BART-Recode' in order to be automatically processed. 

-RTTime is typically the time from the beginning of the experiment to until when a input was received. 

-WaitScanner: This screen where we wait for fMRI trigger input. Its RTTime signifies the start of the experiment.

-FixationScreen: The cross where participant stared at it. There are multiple repeats of this at the beginning.

-ROJitter: Random jitter where the participant CANNOT RESPOND. It is there to induce a separation between RESPONSE and FEEDBACK stage.

-BalloonNumber: which ballon trial it is currently.

-BalloonVert/Horiz Size: Size of the balloon at each turne.

-MakeChoice: the KEY phase that a decision is made. 
--.RESP records the actual response made at that particular incidence. 3 is for inflation. 4 is for cashout.
--.Key1 records the most important parameters together as: RT, Response recevied and time stamp of response.

-newBalloonHorizSize

-newBalloonVertSize

-newBalloonVertSize
  

