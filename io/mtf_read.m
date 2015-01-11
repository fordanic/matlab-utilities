function transform = mtf_read(fileName)
% MTF_READ Reads as Insight Transform (.mtf) file
%
% transform = mtf_read(fileName)
% 
% INPUT ARGUMENTS
% fileName          - Name of file to read
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% transform         - Read transform

% Copyright (c) 2011 Daniel Forsberg
% danne.forsberg@outlook.com
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

if(exist('filename','var')==0)
    [fileName, pathname] = uigetfile('*.mtf', 'Read mtf-file');
    fileName = [pathname fileName];
end

fid=fopen(fileName,'rb');
if(fid<0)
    fprintf('could not open file %s\n',fileName);
    return
end

transform.Filename=fileName;
str=fgetl(fid);
while(str~=-1)    
    s=find(str==':',1,'first');
    if strcmp(str(1),'#')
        str=fgetl(fid);
        continue
    end
    if(~isempty(s))
        type=str(1:s-1); 
        data=str(s+1:end);
        while(type(end)==' '); type=type(1:end-1); end
        while(data(1)==' '); data=data(2:end); end
    else
        type=''; data=str;
    end
    
    switch(lower(type))
        case 'transform'
            transform.Transform=data;
        case 'parameters'
            transform.Parameters=sscanf(data, '%f')';
        case 'fixedparameters'
            transform.FixedParameters=data;
        otherwise
            warning('Unknown parameter set')
    end
    str=fgetl(fid);
end

fclose(fid);
