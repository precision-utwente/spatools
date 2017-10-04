function spa2step(datafile,elems,geometry,ts,varargin)
    
    % Generate STEP file from SPACAR simulation results (ability to write 
    % deformed rectangular beams to a STEP file).
    % 
    % Input arguments
    % 1: name of sbd file without extension
    % 2: element numbers of elements to be drawn (scalar or vector)
    % 3: rectangular dimensions of element (matrix)
    %       i,1 -> length [m] of element i
    %       i,2 -> width [m] of element i
    %       i,3 -> thickness [m] of element i
    % 4: timestep (scalar)
    % optional 5: set true to include timestep in filename of generated file
    
    if nargin > 5
        error('Too many input arguments.')
    end

    %% -- get data from SPACAR run
    sbdfile = sprintf('%s.sbd',datafile);
    x = getfrsbf(sbdfile,'x',ts);
    ln = getfrsbf(sbdfile,'ln');
    lnp = getfrsbf(sbdfile,'lnp');
    e = getfrsbf(sbdfile,'e',ts);
    le = getfrsbf(sbdfile,'le');
    rxyz = getfrsbf(sbdfile,'rxyz');

    %% -- init STEP file
    if nargin == 5 && varargin{1} == true
        stepfile = sprintf('%s-%i.step',datafile,ts);
    else
        stepfile = sprintf('%s.step',datafile);
    end
    fid = fopen(stepfile,'w');
    
    filedate = '13-Apr-2016';
    [geomref, axisref, c] = writePre(stepfile,filedate,fid);
    
    %% -- loop
    manifolds = zeros(length(elems),1);
    for i = 1:length(elems)

        [xp,xq,Rp,Rq] = compElemCoords('beam',x,ln(elems(i),:),lnp);
        Ri = reshape(rxyz(elems(i),:),3,3);
        Rp = Rp*Ri;
        Rq = Rq*Ri;
        
        e1 = e(le(elems(i),1));
        l = geometry(i,1);
        w = geometry(i,2);
        t = geometry(i,3);
        
        [blt, blb, brt, brb] = calculateEdgeSplines(xp,xq,Rp,Rq,e1,l,w,t);
        [m, c] = writeStrip(blt,blb,brt,brb,c+1,fid);
        manifolds(i) = m;

    end

    %% -- finish up STEP file
    writeFinalShape(manifolds,axisref,geomref,c+1,fid);
    writePost(fid);    

end