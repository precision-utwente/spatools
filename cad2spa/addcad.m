function [ handles ] = addcad(axis,handles )
% Mark Naves
% 4-10-2017
%Just an example how to add cad data to spavisual
%
%In visualization part of dat-file: USERPLOT addcad
%Function requires stl2fv.m
%
%Check correct stl settings before saving. in save as => select .stl =>
%options => output as ASCII, unit as meters

%%
%remember cad data to improve speed
persistent F V

%time step
t = axis.Parent.Children(29).Value;

%only load cad-data if not yet available
if isempty(F)   
    [F,V] = stl2fv('stl-file');
end

%transform cad-data (in example rotate it)
theta=180;
R = [1 0 0;0 cosd(theta) -sind(theta);0 sind(theta) cosd(theta)];    
VR(:,1:3)=V(:,1:3)*R;

%plot cad data
patch('Faces', F, 'Vertices', VR,'FaceColor' ,[0.9 0.1 0.1],'EdgeColor','none');
end

