function [] = spacar2step()
clear R_p VY_p R_q VY_q

t=1;
N_cut = 1;
IDs.filename = 'topsol';
spacar(0,IDs.filename);

%% MARK READ SPAVISUAL DAT DATA
VisNrs = [];
VisData  =[];
%% Get settings from DAT/SPV-file _________________________________________
filename = IDs.filename;
fstrm = readSPAVISUALfile(filename, 'dat');
% convert to cell array of strings, each cell contains a single line
nlines = numel(fstrm);
%comment_tokens = '%#;';
pattern = '\s*([a-zA-Z]+)\s*(.*)';

for i=1:nlines
    % remove any comments from fstrm{i}
    tokens = regexpi(fstrm{i}{1},pattern,'tokens');
    if strcmp(tokens{1}{1},'BEAMPROPS')
       tokens2 = regexpi(fstrm{i+1}{1},pattern,'tokens');
       if strcmp(tokens2{1}{1},'CROSSDIM')  
       %beam numbers
       VisNrs = [VisNrs str2num(tokens{1}{2})];
       %dimensions
       tokens2 = regexpi(fstrm{i+1}{1},pattern,'tokens');
       dim =  str2num(tokens2{1}{2});
       VisData(size(VisData,1)+1:size(VisData,1)+length(str2num(tokens{1}{2})),2) = dim(1);
       VisData(size(VisData,1)-length(VisNrs)+1:size(VisData,1),3) = dim(2);
       end
    end
end

x =  getfrsbf(strcat(filename,'.sbd'),'x',1);
ln =  getfrsbf(strcat(filename,'.sbd'),'ln');
lnp =  getfrsbf(strcat(filename,'.sbd'),'lnp');
for i=1:length(VisNrs)
   nodes =  ln(VisNrs(i),[1 3]);
   P_node = x(lnp(nodes(1),1:3));
   Q_node = x(lnp(nodes(2),1:3));
   VisData(i,1) = norm(Q_node-P_node);
end

%%start stepwriter
fileID = fopen([IDs.filename '.step'],'w');

fprintf(fileID,'ISO-10303-21; \n');
fprintf(fileID,'HEADER;\nFILE_DESCRIPTION (( ''STEP AP214'' ),''1'' );\n');
fprintf(fileID, ['FILE_NAME (''', IDs.filename, '.STEP'',''' ,date ''',( '''' ),( '''' ),''SwSTEP 2.0'',''SolidWorks 2015'','''' );\n']);
fprintf(fileID,'FILE_SCHEMA (( ''AUTOMOTIVE_DESIGN'' )); \n');
fprintf(fileID,'ENDSEC;\n\n');
fprintf(fileID,'DATA;\n\n');
fprintf(fileID,'\n');

%print first ini rules
[IDs.NAMED_UNIT, count ] = writeline(fileID, '( LENGTH_UNIT ( ) NAMED_UNIT ( * ) SI_UNIT ( .MILLI., .METRE. ) )' ,1 );
[IDs.SI_UNIT, count ] = writeline(fileID, '( NAMED_UNIT ( * ) SI_UNIT ( $, .STERADIAN. ) SOLIDs.ANGLE_UNIT ( ) )' ,count );
[IDs.PLANE_ANGLE_UNIT, count ] = writeline(fileID, '( NAMED_UNIT ( * ) PLANE_ANGLE_UNIT ( ) SI_UNIT ( $, .RADIAN. ) )' ,count );
[IDs.UNCERTAINTY, count ] = writeline(fileID, ['UNCERTAINTY_MEASURE_WITH_UNIT (LENGTH_MEASURE( 1.000000000000000100E-0010 ), #', num2str(IDs.NAMED_UNIT)  ,', ''distance_accuracy_value'', ''NONE'')'] ,count );
[IDs.GEOMETRIC, count ] = writeline(fileID, ['( GEOMETRIC_REPRESENTATION_CONTEXT ( 3 ) GLOBAL_UNCERTAINTY_ASSIGNED_CONTEXT ( ( #', num2str(IDs.UNCERTAINTY) ,') ) GLOBAL_UNIT_ASSIGNED_CONTEXT ( ( #', num2str(IDs.NAMED_UNIT),' , #', num2str(IDs.PLANE_ANGLE_UNIT),' , #', num2str(IDs.SI_UNIT) ') ) REPRESENTATION_CONTEXT ( ''NONE'', ''WORKASPACE'' ) )'],count);



%%
%spacar dat
x = getfrsbf([IDs.filename,'.sbd'],'x', t);
ln =  getfrsbf([IDs.filename,'.sbd'],'ln');         %ln
lnp =  getfrsbf([IDs.filename,'.sbd'],'lnp');       %lnp
rxyzp = getfrsbf([IDs.filename,'.sbd'],'rxyz');     %rxyz
shearCoef = getfrsbf([IDs.filename,'.sbd'],'stif'); %shearCoef

for i=1:length(VisNrs)
    w_leafspring(i) = 1000*VisData(i,2);
    [xp,xq,Rp,Rq,L] = compElemCoords('beam',x,ln(VisNrs(i),:),lnp); %get nodal information
    Rip = getRotMtx(rxyzp(VisNrs(i),:),1);                          %transform to euler angels
    Rp = Rp*Rip;
    Rq = Rq*Rip;
    
    %calculate intermediate points on beeam (elastic)
    %first two beam points
    %p node
    [r,vx,vy,vz] = elasticLine(0,xp,xq,Rp,Rq,L,shearCoef(VisNrs(i),5:6),3);
    R_p(1:3,(i-1)*N_cut+1) = 1000.*r; %position
    Vx_p(1:3,(i-1)*N_cut+1) = vx; %normal vector (y)
    Vy_p(1:3,(i-1)*N_cut+1) = vy*w_leafspring(i); %normal vector (y)
    Vz_p(1:3,(i-1)*N_cut+1) = vz; %normal vector (y)
    %q node
    [r,~,vy,vz] = elasticLine((2-1)/N_cut,xp,xq,Rp,Rq,L,shearCoef(VisNrs(i),5:6),3);
    R_q(1:3,(i-1)*N_cut+1) = 1000.*r; %position
    Vx_q(1:3,(i-1)*N_cut+1) = vx; %normal vector (y)
    Vy_q(1:3,(i-1)*N_cut+1) = vy.*w_leafspring(i); %normal vector (y)
    Vz_q(1:3,(i-1)*N_cut+1) = vz; %normal vector (y)
    %remaining beam points
    for s=3:N_cut+1
        [r,~,vy,vz] = elasticLine((s-1)/N_cut,xp,xq,Rp,Rq,L,shearCoef(FlexElemNrs(i),5:6),3);
        %p node
        R_p(1:3,(i-1)*N_cut+s-1) =  R_q(1:3,(i-1)*N_cut+s-2);
        Vx_p(1:3,(i-1)*N_cut+s-1) =  Vx_q(1:3,(i-1)*N_cut+s-2);
        Vy_p(1:3,(i-1)*N_cut+s-1) =  Vy_q(1:3,(i-1)*N_cut+s-2);
        Vz_p(1:3,(i-1)*N_cut+s-1) =  Vz_q(1:3,(i-1)*N_cut+s-2);
        %q node
        R_q(1:3,(i-1)*N_cut+s-1) = 1000.*r;
        Vx_q(1:3,(i-1)*N_cut+s-1) = vx;
        Vy_q(1:3,(i-1)*N_cut+s-1) = vy.*w_leafspring(i);
        Vz_q(1:3,(i-1)*N_cut+s-1) = vz;
    end
end

Shape = [];
for i=1:size(R_q,2)

%[Body(i),IDs.AXIS2_PLACEMENT_3D_global, count] = coord2stepbody(fileID,R_p(:,i)', R_q(:,i)', Vx_p(:,i)',Vx_q(:,i)',Vy_p(:,i)',Vy_q(:,i)',Vz_p(:,i)',Vz_q(:,i)',  w_leafspring(ceil(i/N_cut)), t_leafspring(ceil(i/N_cut)), count );
%[Body(i),IDs.AXIS2_PLACEMENT_3D_global, count] = coord2stepbody(fileID,R_p(:,i)', R_q(:,i)', (Vy_p(:,i)'+Vy_q(:,i)')./2, w_leafspring(ceil(i/N_cut)), t_leafspring(ceil(i/N_cut)), count );
%[Body(i),IDs.AXIS2_PLACEMENT_3D_global, count] = coord2stepFF(fileID,R_p(:,i)', R_q(:,i)',  R_q(:,i+1)',Vy_q(:,i)', w_leafspring(ceil(i/N_cut)), t_leafspring(ceil(i/N_cut)), count );

%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
V = (Vy_p(:,i)'+Vy_q(:,i)')./2;
V = V./norm(V);
N =  cross((R_q(:,i)'-R_p(:,i)')/norm(R_q(:,i)'-R_p(:,i)'),V);


%print bottom surface P-side
X1 = R_p(:,i)' - 0.5.*V*w_leafspring(ceil(i/N_cut)) ;
X2 = R_q(:,i)' - 0.5.*V*w_leafspring(ceil(i/N_cut)) ;
X3 = R_q(:,i)' + 0.5.*V*w_leafspring(ceil(i/N_cut)) ;
X4 = R_p(:,i)' + 0.5.*V*w_leafspring(ceil(i/N_cut));
X = [X1; X2; X3; X4];
[Face(i),AXIS2_PLACEMENT_3D_global, count ] = coord2stepsurf(fileID,count,X );


% Shape = [Shape, ' #', num2str(Body(i))];
% if i~=size(R_q,2)
%     Shape = [Shape, ' , '];
% end
Shape = [Shape, ' #', num2str(Face(i))];
if i~=size(R_q,2)
    Shape = [Shape, ' , '];
end
end

 [ SHELL_BASED_SURFACE_MODEL, count ] = writeline(fileID, ['SHELL_BASED_SURFACE_MODEL ( ''NONE'',(', num2str( Shape),') )'] ,count );
 [ MANIFOLD, count ] = writeline(fileID, ['MANIFOLD_SURFACE_SHAPE_REPRESENTATION ( ''testl'',( #', num2str( SHELL_BASED_SURFACE_MODEL),' , #', num2str( AXIS2_PLACEMENT_3D_global),' ), #5)'] ,count );



%[ADVANCED_BREP_SHAPE_REPRESENTATION, count ] = writeline(fileID, ['ADVANCED_BREP_SHAPE_REPRESENTATION (''test_volume'',(' Shape,' , #',num2str(IDs.AXIS2_PLACEMENT_3D_global(1)),'), #',num2str(IDs.GEOMETRIC) ,')'] ,count );

fprintf(fileID,'\n');
fprintf(fileID,'\nENDSEC;\n');
fprintf(fileID,'END-ISO-10303-21;');

fclose(fileID);
