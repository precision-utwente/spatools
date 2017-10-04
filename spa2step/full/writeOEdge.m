function [out1, out2] = writeOEdge(curveref,orient,c,fid)

%     fprintf(fid,'#%i = VERTEX_POINT(''NONE'',#%i);\n',c,beginpointref);
%     fprintf(fid,'#%i = VERTEX_POINT(''NONE'',#%i);\n',c+1,endpointref);
%     fprintf(fid,'#%i = EDGE_CURVE(''NONE'',#%i,#%i,#%i,.T.);\n',c,beginpointref,endpointref,curveref);
    
    if orient == true
        orient_flag = '.T.';
    else
        orient_flag = '.F.';
    end

    fprintf(fid,'#%i = ORIENTED_EDGE(''NONE'',*,*,#%i,%s);\n',c,curveref,orient_flag);

    out1 = c; %oriented edge, for later referencing
    out2 = c; %counter, for increasing line number in next call
    
end