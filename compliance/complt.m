function [CMglob CMloc] = complt(filename,ntr,nrot);
% Calculate the compliance matrix in global directions and in body-fixed 
% local directions.
% Calling syntax: [CMglob CMloc] = complt(filename,ntr,nrot)
% Input: 
%   filename: string with the filename, without extension, of the file 
%             where the data can be found
%   ntr:      node number of the translational node
%   nrot:     node number of the rotational node
% Output: 
%   CMglob: 6 x 6 x n compliance matrix in global directions
%   CMloc:  6 x 6 x n compliance matrix in local directions

if (nargin ~= 3)
  disp('complt needs 3 input arguments');
  CMglob=zeros(6,6,1);
  CMloc=zeros(6,6,1);
  return;
end;
% read total number of steps from the file
tdef     =getfrsbf([filename '.sbd'],'tdef');
CMglob=zeros(6,6,tdef);
CMloc=zeros(6,6,tdef);
lnp     =getfrsbf([filename '.sbd'],'lnp');
nxp     =getfrsbf([filename '.sbd'],'nxp');
nep     =getfrsbf([filename '.sbd'],'nep');
% locate the place of the coordinates of the points where the compliance 
% has to be determined
locv=[lnp(ntr,1:3), lnp(nrot,1:4)];
% test whether the selected coordinates are feasible
for i=1:7
  if locv(i) <= 0
    disp('ERROR: invalid node number');
    return;
  end;
  if locv(i) <= nxp(1) || ...
     (locv(i)>(nxp(1)+nxp(2)) && locv(i) <= (nxp(1)+nxp(2)+nxp(3))) 
    disp('WARNING: constrained node');
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
  K0      =getfrsbf([filename '.sbm'],'k0',tstp);
  G0      =getfrsbf([filename '.sbm'],'g0',tstp);
  CMlambda=DX*((K0+G0)\(DX'));
% Reduce CMlambda to the correct matrices by the lambda matrices
  lambda0=X(locv(4));
  lambda1=X(locv(5));
  lambda2=X(locv(6));
  lambda3=X(locv(7));
  lambdabt=[ -lambda1  lambda0 -lambda3  lambda2
             -lambda2  lambda3  lambda0 -lambda1
             -lambda3 -lambda2  lambda1  lambda0 ];
  lambdat= [ -lambda1  lambda0  lambda3 -lambda2
             -lambda2 -lambda3  lambda0  lambda1
             -lambda3  lambda2 -lambda1  lambda0 ];
  Tglob= [ eye(3)     zeros(3,4)
           zeros(3,3) 2*lambdabt];
  Tloc = [ lambdat*(lambdabt') zeros(3,4)
           zeros(3,3) 2*lambdat];
  CMglob(:,:,tstp)=Tglob*CMlambda*(Tglob');
  CMloc(:,:,tstp)=Tloc*CMlambda*(Tloc');
end;
 
