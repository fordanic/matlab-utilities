function Z = ba_interp3(F, X, Y, Z, method)
% Fast nearest, bi-linear and bi-cubic interpolation for image data
%
% Usage:
% ------
%     Z = ba_interp3(F, X, Y, Z, [method])
%
% where method is one off nearest, linear, or cubic.
%
% F    is a WxHxD Image.
% X, Y, Z are I_1 x ... x I_n matrices with the x, y and z coordinates to
%      interpolate.
%
% Notes:
% ------
% This method handles the border by repeating the closest values to the point accessed. 
% This is different from matlabs border handling.
%
% Licence:
% --------
% GPL
% (c) 2008 Brian Amberg
% http://www.brian-amberg.de/

  error('ERROR: The mex file was not compiled. Use  $ mex -O ba_interp3.cpp      to compile it');
end
