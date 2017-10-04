function [ID, count ] = writeline(fileID, message ,count )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
ID=count;
fprintf(fileID,['#', num2str(count),' = ', message, ';\n']);
count = count+1;
end

