function [out1, out2] = writeVertex(pointref,c,fid)

    fprintf(fid,'#%i = VERTEX_POINT(''NONE'',#%i);\n',c,pointref);

    out1 = c; %vertex number, for later referencing
    out2 = c; %counter, for increasing line number in next call

end