function [OPEN_SHELL, AXIS2_PLACEMENT_3D, count ] = coord2stepsurf(fileID,count,X)
%UNTITLED3 Summary of this function goes here

%adding the surface
looplist = (1:size(X,1))+1;
looplist(end) = 1;
%cartesian points
for i=1:size(X,1)
    [ CARTESIAN_POINT(i), count ] = writeline(fileID, ['CARTESIAN_POINT ( ''NONE'',  ( ', num2str(X(i,1)),',',num2str(X(i,2)),',',num2str(X(i,3)),') )'] ,count );
    [ VERTEX_POINT(i), count ] = writeline(fileID, ['VERTEX_POINT ( ''NONE'', #', num2str( CARTESIAN_POINT(i)), ') '] ,count );
end

%  [ VERTEX_POINT(1), count ] = writeline(fileID, ['VERTEX_POINT ( ''NONE'', #', num2str( CARTESIAN_POINT(2)), ') '] ,count );
%  [ VERTEX_POINT(2), count ] = writeline(fileID, ['VERTEX_POINT ( ''NONE'', #', num2str( CARTESIAN_POINT(1)), ') '] ,count );
%   [ VERTEX_POINT(3), count ] = writeline(fileID, ['VERTEX_POINT ( ''NONE'', #', num2str( CARTESIAN_POINT(3)), ') '] ,count );
%    [ VERTEX_POINT(4), count ] = writeline(fileID, ['VERTEX_POINT ( ''NONE'', #', num2str( CARTESIAN_POINT(4)), ') '] ,count );
 
% fprintf(fileID,'\n');
%directional vertices
for i=1:2
V(i,1:3) = ( X(i,1:3)- X(i+1,1:3))/norm( X(i,1:3)- X(i+1,1:3));
[ DIRECTION(i), count ] = writeline(fileID, ['DIRECTION ( ''NONE'',  ( ', num2str(V(i,1)),',',num2str(V(i,2)),',',num2str(V(i,3)),') )'] ,count );
[ VECTOR(i), count ] = writeline(fileID, ['VECTOR ( ''NONE'', #', num2str( DIRECTION(i)), ',  1000)'] ,count );
[ LINE(i), count ] = writeline(fileID, ['LINE ( ''NONE'', #', num2str( CARTESIAN_POINT(1)), ' , #', num2str( VECTOR(i)),')'] ,count );
end
Vc = cross(V(2,1:3),V(1,1:3));
Vc = Vc/norm(Vc);
[ DIRECTIONc, count ] = writeline(fileID, ['DIRECTION ( ''NONE'',  ( ', num2str(Vc(1)),',',num2str(Vc(2)),',',num2str(Vc(3)), ') )'] ,count );

edge_loop_string = '(#';
for i=1:size(X,1)
[ EDGE_CURVE(i), count ] = writeline(fileID, ['EDGE_CURVE ( ''NONE'', #', num2str( VERTEX_POINT(i)), ' , #', num2str( VERTEX_POINT(looplist(i))), ' , #', num2str( LINE((mod(i,2)==0)+1)),', .T. )'] ,count );
[ ORIENTED_EDGE(i), count ] = writeline(fileID, ['ORIENTED_EDGE ( ''NONE'', *, *, #', num2str( EDGE_CURVE(i)), ',  .F. )'] ,count );
edge_loop_string = [edge_loop_string, num2str(ORIENTED_EDGE(i))];
if i<size(X,1)
edge_loop_string = [edge_loop_string, ' , #'];
end
end

%axis placement 3d
[ AXIS2_PLACEMENT_3D(1), count ] = writeline(fileID, ['AXIS2_PLACEMENT_3D ( ''NONE'', #', num2str( CARTESIAN_POINT(1)), ' , #', num2str( DIRECTION(1)), ' , #', num2str( DIRECTION(2)),' )'] ,count );
[ AXIS2_PLACEMENT_3D(2), count ] = writeline(fileID, ['AXIS2_PLACEMENT_3D ( ''NONE'', #', num2str( CARTESIAN_POINT(1)), ' , #', num2str( DIRECTIONc), ' , #', num2str( DIRECTION(2)),' )'] ,count );

%create surf
[ EDGE_LOOP, count ] = writeline(fileID, ['EDGE_LOOP ( ''NONE'', ', edge_loop_string, ') )'] ,count );
[ FACE_OUTER_BOUND, count ] = writeline(fileID, ['FACE_OUTER_BOUND ( ''NONE'', #', num2str( EDGE_LOOP), ',  .T. )'] ,count );
[ PLANE, count ] = writeline(fileID, ['PLANE ( ''NONE'', #', num2str( AXIS2_PLACEMENT_3D(2)), ' )'] ,count );
[ ADVANCED_FACE, count ] = writeline(fileID, ['ADVANCED_FACE ( ''NONE'',( #', num2str( FACE_OUTER_BOUND), ' ), #', num2str( PLANE), ', .F. )'] ,count );
 [ OPEN_SHELL, count ] = writeline(fileID, ['OPEN_SHELL ( ''NONE'',( #', num2str( ADVANCED_FACE),') )'] ,count );
% [ SHELL_BASED_SURFACE_MODEL, count ] = writeline(fileID, ['SHELL_BASED_SURFACE_MODEL ( ''NONE'',( #', num2str( OPEN_SHELL),') )'] ,count );
% [ MANIFOLD, count ] = writeline(fileID, ['MANIFOLD_SURFACE_SHAPE_REPRESENTATION ( ''testl'',( #', num2str( SHELL_BASED_SURFACE_MODEL),' , #', num2str( AXIS2_PLACEMENT_3D(1)),' ), #5)'] ,count );

