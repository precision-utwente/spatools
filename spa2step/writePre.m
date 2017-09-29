function [geomref, axisref, lastline] = writePre(stepfile,filedate,fid)

    precode1 = fileread('step-pre1.txt');
    precode2 = fileread('step-pre2.txt');

    fprintf(fid,'%s\n',precode1);
    
    fprintf(fid,...
'FILE_NAME (''%s'',''%s'',(''''),(''''),''SwSTEP 2.0'',''SolidWorks 2015'','''');\n',...
    stepfile,filedate);
    
    fprintf(fid,'%s\n',precode2);
    
    geomref = 5; %from step-pre.txt
    axisref = 6; %from step-pre.txt
    lastline = 9; %from step-pre.txt

end