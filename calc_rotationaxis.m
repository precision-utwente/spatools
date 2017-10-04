function [p, check] =  calc_rotationaxis(drx,dx)


Ndrx = norm(drx); %magnitude of rotations
udrx = drx./Ndrx;      %unit rotations

UskewT = [0 udrx(3) -udrx(2); -udrx(3) 0 udrx(1); udrx(2) -udrx(1) 0]; %transposed skew semmetric matrix of u
p = UskewT'*dx/Ndrx; %rotation axis

check = norm(dx - cross(p,udrx)*Ndrx);  %should be zero if no twist involved
if check>1e-3
   warning('twist motion involved, no pure rotations')
end



