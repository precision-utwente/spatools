function [MANIFOLD_SOLID_BREP,AXIS2_PLACEMENT_3D_global, count] = coord2stepFF(fileID, P, Q, R, V,  w, t, count )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
V = V./norm(V);
N =  cross((Q-P)/norm(Q-P),V);



%print bottom surface P-side
X1 = P - 0.5.*V*w - 0.5.*N*t;
X2 = P - 0.5.*V*w + 0.5.*N*t;
X3 = P + 0.5.*V*w + 0.5.*N*t;
X4 = P + 0.5.*V*w - 0.5.*N*t;
X = [X1; X2; X3; X4];
[Face(1),AXIS2_PLACEMENT_3D_global, count ] = coord2stepsurf(fileID,count,X );
% 
% %print bottom surface R-side
X1 = R - 0.5.*V*w - 0.5.*N*t;
X2 = R - 0.5.*V*w + 0.5.*N*t;
X3 = R + 0.5.*V*w + 0.5.*N*t;
X4 = R + 0.5.*V*w - 0.5.*N*t;
X = [X1; X2; X3; X4];
[Face(2),~, count ] = coord2stepsurf(fileID,count,X );

%print side surface bottom
angle = acosd(dot(R-Q,P-Q)/(norm(R-Q)*norm(P-Q)));
dir = ((R-Q) + (P-Q)) / norm((R-Q) + (P-Q));
offset = t/sind(angle/2)/2;
save('test.mat')
X1 = P - 0.5.*V*w - 0.5.*N*t;
X2 = P - 0.5.*V*w + 0.5.*N*t;
X3 = Q - 0.5.*V*w + dir*offset;
X4 = R - 0.5.*V*w - 0.5.*N*t;
X5 = R - 0.5.*V*w + 0.5.*N*t;
X6 = Q - 0.5.*V*w - dir*offset;
X = [X1; X2; X3; X4; X5;  X6];
[Face(3),~, count ] = coord2stepsurf(fileID,count,X );

%print side surface top
X1 = P + 0.5.*V*w - 0.5.*N*t;
X2 = P + 0.5.*V*w + 0.5.*N*t;
X3 = Q + 0.5.*V*w + dir*offset;
X4 = R + 0.5.*V*w - 0.5.*N*t;
X5 = R + 0.5.*V*w + 0.5.*N*t;
X6 = Q + 0.5.*V*w - dir*offset;
X = [X1; X2; X3; X4; X5;  X6];
[Face(4),~, count ] = coord2stepsurf(fileID,count,X );

%print bottom P
X1 = P - 0.5.*V*w - 0.5.*N*t;
X2 = P + 0.5.*V*w - 0.5.*N*t;
X3 = Q + 0.5.*V*w - dir*offset;
X4 = Q - 0.5.*V*w - dir*offset;
X = [X1; X2; X3; X4; ];
[Face(5),~, count ] = coord2stepsurf(fileID,count,X );

%print top P
X1 = P - 0.5.*V*w + 0.5.*N*t;
X2 = P + 0.5.*V*w + 0.5.*N*t;
X3 = Q + 0.5.*V*w + dir*offset;
X4 = Q - 0.5.*V*w + dir*offset;
X = [X1; X2; X3; X4; ];
[Face(6),~, count ] = coord2stepsurf(fileID,count,X );

%print bottom R
X1 = R - 0.5.*V*w - 0.5.*N*t;
X2 = R + 0.5.*V*w - 0.5.*N*t;
X3 = Q + 0.5.*V*w + dir*offset;
X4 = Q - 0.5.*V*w + dir*offset;
X = [X1; X2; X3; X4; ];
[Face(7),~, count ] = coord2stepsurf(fileID,count,X );

%print top R
X1 = R - 0.5.*V*w + 0.5.*N*t;
X2 = R + 0.5.*V*w + 0.5.*N*t;
X3 = Q + 0.5.*V*w - dir*offset;
X4 = Q - 0.5.*V*w - dir*offset;
X = [X1; X2; X3; X4; ];
[Face(8),~, count ] = coord2stepsurf(fileID,count,X );
 for i=1:3;
 plot3([X(i,1) X(i+1,1)],[X(i,2) X(i+1,2)],[X(i,3) X(i+1,3)],'r'); hold on;
 end
 plot3([X(end,1) X(1,1)],[X(end,2) X(1,2)],[X(end,3) X(1,3)],'r'); hold on;
%print top surface
% X1 = Q - 0.5.*V*w - 0.5.*N*t;
% X2 = Q - 0.5.*V*w + 0.5.*N*t;
% X3 = Q + 0.5.*V*w - 0.5.*N*t;
% X4 = Q + 0.5.*V*w + 0.5.*N*t;
% X = [X1; X2; X3; X4];
% [Face(2),~, count ] = coord2stepsurf(fileID,count,X );




[CLOSED_SHELL, count ] = writeline(fileID, ['CLOSED_SHELL ( ''NONE'',( #', num2str(Face(1)),' , #',num2str(Face(2)),', #',num2str(Face(3)),' , #',num2str(Face(4)),' , #',num2str(Face(5)),' , #',num2str(Face(6)),' , #',num2str(Face(7)),' , #',num2str(Face(8)),') )'] ,count );
[MANIFOLD_SOLID_BREP, count ] = writeline(fileID, ['MANIFOLD_SOLID_BREP (''Boss-Extrude1'', #',num2str(CLOSED_SHELL),') '] ,count );



end

