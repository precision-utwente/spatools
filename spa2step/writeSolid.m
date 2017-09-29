function [out1, out2] = writeSolid(f1,f2,f3,f4,f5,f6,c,fid)

    fprintf(fid,'#%i = CLOSED_SHELL(''NONE'',(#%i,#%i,#%i,#%i,#%i,#%i));\n',...
        c,f1,f2,f3,f4,f5,f6);
    fprintf(fid,'#%i = MANIFOLD_SOLID_BREP('''',#%i);\n',...
        c+1,c);
       
    out1 = c+1; %manifold number, for referencing later on
    out2 = c+1; %counter, for increasing line number in next call
    
end