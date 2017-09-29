function [out1, out2] = writeFace(boundref,surfaceref,c,fid)

    fprintf(fid,'#%i = ADVANCED_FACE(''NONE'',(#%i),#%i,.T.);\n',...
        c,boundref,surfaceref);
%     fprintf(fid,'#%i = OPEN_SHELL(''NONE'',(#%i));\n',c+1,c);
%     fprintf(fid,'#%i = SHELL_BASED_SURFACE_MODEL('''',(#%i));\n',c+2,c+1);
%     fprintf(fid,...
% '#%i = MANIFOLD_SURFACE_SHAPE_REPRESENTATION(''%s'',(#%i,#%i),#%i);\n',...
% c+3,filen,c+2,axisref,geomrepresref);
    
%     out2 = c+3; %counter, for increasing line number in next call
    out1 = c; %advanced face number, for later referencing
    out2 = c; %counter, for increasing line number in next call

end