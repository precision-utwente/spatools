function [out1, out2] = writeBSCurve(deg,cpointsref,beginvertexref,endvertexref,c,fid)
    
    cpointslist = sprintf(' #%i,',cpointsref);
    cpointslist(1) = []; %remove first space
    cpointslist(end) = []; %remove last comma
    
    fprintf(fid,...
'#%i = B_SPLINE_CURVE_WITH_KNOTS('''',%i,(%s),.UNSPECIFIED.,.F.,.F.,(%i,%i),(0.000,1.000),.UNSPECIFIED.);\n',...
        c,deg,cpointslist,deg+1,deg+1);
    
    fprintf(fid,'#%i = EDGE_CURVE(''NONE'',#%i,#%i,#%i,.T.);\n',c+1,beginvertexref,endvertexref,c);
    
    out1 = c+1; %edge curve number, for later referencing
    out2 = c+1; %counter, for increasing line number in next call

end