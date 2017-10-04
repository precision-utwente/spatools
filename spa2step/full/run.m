addpath('../sp15st')
%doSpa.m for test file

cs = [0.08/2 0.04 0.0005];
spa2step('strip',[1 2],[cs;cs],1)

% elem = 7:48;
% 
% %lengte
% VisData(1:6,1) = 0.009095019384928;
% VisData(7:18,1) = 0.022778861472866;
% VisData(19:42,1) = 0.014437022684750;
%  
% %breedte
% VisData(1:6,2) = 0.049861;
% VisData(7:18,2) = 0.049861;
% VisData([19 20 25 26 31 32 37 38],2) = 0.008285;
% VisData([21:24 27:30 33:36 39:42],2) = 0.004142;
%  
% VisData(1:6,3) = 0.001993;
% VisData(7:18,3) = 0.002880;
% VisData([19 20 25 26 31 32 37 38],3) = 0.002121;
% VisData([21:24 27:30 33:36 39:42],3) = 0.002121;
% 
% for i=1:26
%     spa2step('vis',elem,VisData,i,1)
% end