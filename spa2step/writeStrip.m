function [out1, out2] = writeStrip(blt,blb,brt,brb,ci,fid)

    %% -- coordinates
    % coordinates, based on the four long edges of the strip
    [clt, c] = writeCoordinate(blt,ci,fid);
    [clb, c] = writeCoordinate(blb,c+1,fid);
    [crt, c] = writeCoordinate(brt,c+1,fid);
    [crb, c] = writeCoordinate(brb,c+1,fid);

    %% -- vertices
    % 4 vertices (corners points of strip) -- top surface
    [v1t, c] = writeVertex(clt(1),c+1,fid);
    [v2t, c] = writeVertex(clt(4),c+1,fid);
    [v3t, c] = writeVertex(crt(4),c+1,fid);
    [v4t, c] = writeVertex(crt(1),c+1,fid);

    % 4 vertices (corners points of strip) -- bottom surface
    [v1b, c] = writeVertex(clb(1),c+1,fid);
    [v2b, c] = writeVertex(clb(4),c+1,fid);
    [v3b, c] = writeVertex(crb(4),c+1,fid);
    [v4b, c] = writeVertex(crb(1),c+1,fid);

    %% -- curves
    % 4 bspline curves (two straight, two curved) with edge curves -- top surf
    [ec1t, c] = writeBSCurve(3,clt,v1t,v2t,c+1,fid);
    [ec2t, c] = writeBSCurve(1,[clt(4) crt(4)],v2t,v3t,c+1,fid);
    [ec3t, c] = writeBSCurve(3,crt,v3t,v4t,c+1,fid);
    [ec4t, c] = writeBSCurve(1,[crt(1) clt(1)],v4t,v1t,c+1,fid);

    % 4 bspline curves (two straight, two curved) with edge curves -- bottom su
    [ec1b, c] = writeBSCurve(3,clb,v1b,v2b,c+1,fid);
    [ec2b, c] = writeBSCurve(1,[clb(4) crb(4)],v2b,v3b,c+1,fid);
    [ec3b, c] = writeBSCurve(3,crb,v3b,v4b,c+1,fid);
    [ec4b, c] = writeBSCurve(1,[crb(1) clb(1)],v4b,v1b,c+1,fid);

    % 4 side curves (with length equal to thickness)
    [ec1s, c] = writeBSCurve(1,[clb(1) clt(1)],v1b,v1t,c+1,fid);
    [ec2s, c] = writeBSCurve(1,[clb(4) clt(4)],v2b,v2t,c+1,fid);
    [ec3s, c] = writeBSCurve(1,[crb(4) crt(4)],v3b,v3t,c+1,fid);
    [ec4s, c] = writeBSCurve(1,[crb(1) crt(1)],v4b,v4t,c+1,fid);

    %% -- top strip surface
    % oriented edges
    [oe1t, c] = writeOEdge(ec1t,1,c+1,fid);
    [oe2t, c] = writeOEdge(ec2t,1,c+1,fid);
    [oe3t, c] = writeOEdge(ec3t,1,c+1,fid);
    [oe4t, c] = writeOEdge(ec4t,1,c+1,fid);

    [fb1t, c] = writeEdgeLoop(oe1t,oe2t,oe3t,oe4t,c+1,fid);

    [s1t, c] = writeBSSurface(clt,crt,c+1,fid);
    [f1, c] = writeFace(fb1t,s1t,c+1,fid);

    %% -- bottom strip surface
    [oe1b, c] = writeOEdge(ec1b,1,c+1,fid);
    [oe2b, c] = writeOEdge(ec2b,1,c+1,fid);
    [oe3b, c] = writeOEdge(ec3b,1,c+1,fid);
    [oe4b, c] = writeOEdge(ec4b,1,c+1,fid);

    [fb1b, c] = writeEdgeLoop(oe1b,oe2b,oe3b,oe4b,c+1,fid);

    [s1b, c] = writeBSSurface(clb,crb,c+1,fid);
    [f2, c] = writeFace(fb1b,s1b,c+1,fid);

    %% -- bottom side surface
    [oe1s1, c] = writeOEdge(ec1s,1,c+1,fid);
    [oe2s1, c] = writeOEdge(ec4t,0,c+1,fid);
    [oe3s1, c] = writeOEdge(ec4s,0,c+1,fid);
    [oe4s1, c] = writeOEdge(ec4b,1,c+1,fid);

    [fb1s, c] = writeEdgeLoop(oe1s1,oe2s1,oe3s1,oe4s1,c+1,fid);

    [s1s, c] = writeFlatSurface([clb(1) clt(1)],[crb(1) crt(1)],c+1,fid);
    [f3, c] = writeFace(fb1s,s1s,c+1,fid);

    %% -- top side surface
    [oe1s2, c] = writeOEdge(ec2s,1,c+1,fid);
    [oe2s2, c] = writeOEdge(ec2t,1,c+1,fid);
    [oe3s2, c] = writeOEdge(ec3s,0,c+1,fid);
    [oe4s2, c] = writeOEdge(ec2b,0,c+1,fid);

    [fb2s, c] = writeEdgeLoop(oe1s2,oe2s2,oe3s2,oe4s2,c+1,fid);

    [s2s, c] = writeFlatSurface([clb(4) clt(4)],[crb(4) crt(4)],c+1,fid);
    [f4, c] = writeFace(fb2s,s2s,c+1,fid);

    %% -- left side surface
    [oe1s3, c] = writeOEdge(ec1s,1,c+1,fid);
    [oe2s3, c] = writeOEdge(ec1t,1,c+1,fid);
    [oe3s3, c] = writeOEdge(ec2s,0,c+1,fid);
    [oe4s3, c] = writeOEdge(ec1b,0,c+1,fid);

    [fb3s, c] = writeEdgeLoop(oe1s3,oe2s3,oe3s3,oe4s3,c+1,fid);

    [s3s, c] = writeBSSurface(clb,clt,c+1,fid);
    [f5, c] = writeFace(fb3s,s3s,c+1,fid);

    %% -- right side surface
    [oe1s4, c] = writeOEdge(ec4s,1,c+1,fid);
    [oe2s4, c] = writeOEdge(ec3t,0,c+1,fid);
    [oe3s4, c] = writeOEdge(ec3s,0,c+1,fid);
    [oe4s4, c] = writeOEdge(ec3b,1,c+1,fid);

    [fb4s, c] = writeEdgeLoop(oe1s4,oe2s4,oe3s4,oe4s4,c+1,fid);

    [s4s, c] = writeBSSurface(crb,crt,c+1,fid);
    [f6, c] = writeFace(fb4s,s4s,c+1,fid);
    
    %% -- join faces
    [m, c] = writeSolid(f1,f2,f3,f4,f5,f6,c+1,fid);
    
    out1 = m; %manifold number
    out2 = c; %counter
    
end