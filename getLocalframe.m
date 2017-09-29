function [rxyz] = getLocalframe(xp,xq,varargin)

    %xp: initial coordinates of trans node p
    %xq: initial coordinates of trans node q
    %ey_input (optional): initial local y-axis, as a vector resolved in global frame 
    %note that xp, xq and ey_input are all available in the dat file
    
    %This follows the exact SPACAR 2015 implementation.
    % Created by M. Nijenhuis, 2016
    
    % -----------------------------------------------------------------
    
    %ensure column vectors
    xp = xp(:);
    xq = xq(:);
    
    eps_th = 0.00001;
    
    % get ex
    ex = xq - xp;
    rl0 = norm(ex);
    
    if rl0 < eps_th
        error('element length smaller than threshold')
    end
    
    ex = ex/rl0;
    
    % get ey
    
    % if no ey specified
    if nargin == 2
        ey = zeros(3,1);
        [~, exmini] = min(abs(ex));
        ey(exmini) = 1.0;
    else
        ey_input = varargin{1};
        ey = ey_input(:)/norm(ey_input); %(:) to ensure column vector
    end

    ex_proj = dot(ey,ex);
    noemer = sqrt(1-ex_proj^2);
    
    if noemer < eps_th
        error('ey is close to parallel to ex')
    end
    
    ey = (ey-ex_proj*ex)/noemer;
    ez = cross(ex,ey);
    rxyz = [ex,ey,ez];
    
end