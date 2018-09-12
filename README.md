# YK Router

## Introduction

This is an implementation of the YK routing algorithm in MATLAB for automatic routing of routes between abstract circuit blocks.
To break cycles in our graph we used Tarjan's algorithm.

## Instructions
Copy all the .m files in the working path of the MATLAB directory

Open pdaproject.m and run it. This is the main YK script. 

To select your circuit file, modify the first line of the code as follows.

fileID = fopen('\yourfilepath\yourfilename.txt');             