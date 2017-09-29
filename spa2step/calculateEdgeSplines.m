function [blt, blb, brt, brb] = calculateEdgeSplines(xp,xq,Rp,Rq,e1,l,w,t)

    xdp = Rp*[1;0;0]*(l+e1);
    xdq = Rq*[1;0;0]*(l+e1);
    
    % position of strip edge - top face
    rplt = xp + w/2*(Rp*[0;1;0]) + t/2*(Rp*[0;0;1]); %p node, left side
    rprt = xp - w/2*(Rp*[0;1;0]) + t/2*(Rp*[0;0;1]); %p node, right side
    rqlt = xq + w/2*(Rq*[0;1;0]) + t/2*(Rq*[0;0;1]); %q node, left side
    rqrt = xq - w/2*(Rq*[0;1;0]) + t/2*(Rq*[0;0;1]); %q node, right side

    % position of strip edge - bottom face
    rplb = xp + w/2*(Rp*[0;1;0]) - t/2*(Rp*[0;0;1]); %p node, left side
    rprb = xp - w/2*(Rp*[0;1;0]) - t/2*(Rp*[0;0;1]); %p node, right side
    rqlb = xq + w/2*(Rq*[0;1;0]) - t/2*(Rq*[0;0;1]); %q node, left side
    rqrb = xq - w/2*(Rq*[0;1;0]) - t/2*(Rq*[0;0;1]); %q node, right side
    
    %% collect Hermite control points
    hlt = [rplt rqlt xdp xdq]'; %for left top spline
    hlb = [rplb rqlb xdp xdq]'; %for left bottom spline
    hrt = [rprt rqrt xdp xdq]'; %for right top spline
    hrb = [rprb rqrb xdp xdq]'; %for right bottom spline

    % convert to Bezier control points
    T = 1/3*[...
        3 0 0 0;
        3 0 1 0;
        0 3 0 -1;
        0 3 0 0];

    blt = T*hlt;
    blb = T*hlb;
    brt = T*hrt;
    brb = T*hrb;

end