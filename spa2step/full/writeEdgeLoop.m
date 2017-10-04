function [out1, out2] = writeEdgeLoop(e1,e2,e3,e4,c,fid)

    fprintf(fid,'#%i = EDGE_LOOP(''NONE'',(#%i,#%i,#%i,#%i));\n',c,e1,e2,e3,e4);
    fprintf(fid,'#%i = FACE_OUTER_BOUND('''',#%i,.T.);\n',c+1,c);

    out1 = c+1; %face outer bound number, for later referencing
    out2 = c+1; %counter, for increasing line number in next call
    
end