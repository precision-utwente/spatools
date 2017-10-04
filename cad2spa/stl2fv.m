function [F,V] = stl2fv(stlfilename)

% (© MMA 2009) STL2FV Read a STL-file for use as a patch.
% [F,V] = STL2FV(STLFILENAME) reads STL-file 'STLFILENAME.STL'
% and returns array of faces F and array of vertices V.
%
% Original source: CAD2MATDEMO.M by Don Riley:
% http://www.mathworks.com/matlabcentral/fileexchange/3642

if ~exist([stlfilename '.stl'],'file')
    error(['File ' stlfilename '.stl not found.'])

else
    
% Read the CAD data file:
fid=fopen(([stlfilename '.stl']), 'r');             % Open the file, assumes STL ASCII format.
CAD_object_name = sscanf(fgetl(fid), '%*s %s');     % CAD object name.
vnum = 0;                                           % Initial vertex counter.
report_num = 0;                                     % Initial vertex report counter.
VColor = [0 0 1]';                                  % Initial VColor, defaults to Blue.

while feof(fid) == 0                                % If not End Of File.
    tline = fgetl(fid);                             % Read a line of data from file.
    fword = sscanf(tline, '%s ');                   % Convert the line to a character string.

    % Check for color
    if strncmpi(fword, 'c',1) == 1;             	% Check the line for a "C"olor.
       VColor = sscanf(tline, '%*s %f %f %f');  	% If so, get the RGB color data of the face.
    end

    if strncmpi(fword, 'v',1) == 1;                 % Check the line for a "V"ertex.
        vnum = vnum + 1;                            % If so, add to counter.
        report_num = report_num + 1;                % If so, add to report counter.
        
        if vnum==1;                                 % At first vertex, report.
            disp(['Reading "' stlfilename '" vertex number: ' int2str(vnum) '...']);
        end
        if report_num> 999;                         % When passing 1000 vertices, report.
            disp(['Reading "' stlfilename '" vertex number: ' int2str(vnum) '...']);
            report_num = 0;                         % Reset report number.
        end

        V(:,vnum) = sscanf(tline, '%*s %f %f %f');  % Read XYZ data of the vertex.
        C(:,vnum) = VColor;                         % color for each vertex.
    end                                         
    
end

fclose(fid);

disp(['Reading "' stlfilename '" vertices done.']);
disp(['Total number of vertices of "' stlfilename '": ' int2str(vnum) '.']);

% Build face list; The vertices are in order, so just number them.
fnum = vnum/3;                                      % Number of faces, vnum is number of vertices.  STL is triangles.
flist = 1:vnum;                                     % Face list of vertices, all in order.
F = reshape(flist,3,fnum);                          % Make a "3 by fnum" matrix of face list data.

% Return the faces and vertices for direct use in patch:
F = F';
V = V';
C = C';

end