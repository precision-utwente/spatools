function [CMglob CMloc] = complt2(filename,ntr,nrot);
% Calculate the compliance matrix in global directions and in body-fixed 
% local directions.
% Calling syntax: [CMglob CMloc] = complt2(filename,ntr,nrot)
% Input: 
%   filename: string with the filename, without extension, of the file 
%             where the data can be found
%   ntr:      node number of the translational node
%   nrot:     node number of the rotational node
% Output: 
%   CMglob: 3 x 3 x n compliance matrix in global directions
%   CMloc:  3 x 3 x n compliance matrix in local directions

if (nargin ~= 3)
  disp('complt needs 3 input arguments');
  CMglob=zeros(3,3,1);
  CMloc=zeros(3,3,1);
  return;
end;
% read total number of steps from the file
tdef     =getfrsbf([filename '.sbd'],'tdef');
CMglob=zeros(3,3,tdef);
CMloc=zeros(3,3,tdef);
lnp     =getfrsbf([filename '.sbd'],'lnp');
nxp     =getfrsbf([filename '.sbd'],'nxp');
nep     =getfrsbf([filename '.sbd'],'nep');
% locate the place of the coordinates of the points where the compliance 
% has to be determined
locv=[lnp(ntr,1:2), lnp(nrot,1)];
% test whether the selected coordinates are feasible
for i=1:3
  if locv(i) <= 0
    disp('ERROR: invalid node number');
    return;
  end;
  if locv(i) <= nxp(1) || ...
     (locv(i)>(nxp(1)+nxp(2)) && locv(i) <= (nxp(1)+nxp(2)+nxp(3))) 
%     disp('WARNING: constrained node');
  end;
end;
% search for the right degrees of freedom
locdof=[nxp(3)+(1:nxp(4)), nxp(3)+nxp(4)+nep(3)+(1:nep(4))];
% start loop over the time steps
for tstp=1:tdef
% get data from files
  DX      =getfrsbf([filename '.sbd'],'dx',tstp);
  X       =getfrsbf([filename '.sbd'],'x',tstp);
% reduce DX to the rows needed
  DX=DX(locv,locdof);
  K0    =getfrsbf([filename '.sbm'],'k0',tstp);
  G0    =getfrsbf([filename '.sbm'],'g0',tstp);
  CMglob(:,:,tstp)=DX*((K0+G0)\(DX'));
% Calculate the local compliance matrix
  phi=X(locv(3));
  Tloc = [ cos(phi) -sin(phi) 0
           sin(phi)  cos(phi) 0
             0         0      1 ];
  CMloc(:,:,tstp)=Tloc*CMglob(:,:,tstp)*(Tloc');
end;
 
