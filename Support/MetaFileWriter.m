function [Result] = DataFileWriter(FileNamePath,value)
% File writer for meta data 

j= savejson('',value,FileNamePath);

Result = 1;

