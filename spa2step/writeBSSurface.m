function [out1, out2] = writeBSSurface(lcpointsref,rcpointsref,c,fid)

    l = lcpointsref;
    r = rcpointsref;
    
    cpointlist = sprintf('((#%i,#%i),(#%i,#%i),(#%i,#%i),(#%i,#%i))',...
        l(1),r(1),l(2),r(2),l(3),r(3),l(4),r(4));
    
    fprintf(fid,...
'#%i = B_SPLINE_SURFACE_WITH_KNOTS('''',3,1,%s,.UNSPECIFIED.,.F.,.F.,.F.,(4,4),(2,2),(0.000,1.000),(0.000,1.000),.UNSPECIFIED.);\n',...
c,cpointlist);

    out1 = c; %surface number, for later referencing
    out2 = c; %counter, for increasing line number in next call
end
