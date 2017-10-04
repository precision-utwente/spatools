function [out1, out2] = writeCoordinate(cpoints,c,fid)
    
    n_points = size(cpoints,1);
    pointrefs = zeros(n_points,1);
    
    for i=1:n_points
        
        cpoint = cpoints(i,:)*1000;
        fprintf(fid,'#%i = CARTESIAN_POINT('''',(%f,%f,%f));\n',...
        c+i-1,cpoint(1),cpoint(2),cpoint(3));
        
        pointrefs(i) = c+i-1;
    end
    
    out1 = pointrefs; %cartesian point numbers, for later referencing
    out2 = pointrefs(n_points); %counter, for increasing line number in next call

end