function ret = mandel(x,y,steps,init_value)

% mandel - a function to generate the Mandelbrot Set.
% Written by Shlomi Fish, 2001
%
% This file is under the public domain.

% Assign some default values to the parameters
% nargin is an internal Matlab variable that specifies how many
% parameters were passed to the function.
if nargin < 1
    x = 100;
end

if nargin < 2
    y = 100;
end

if nargin < 3
    steps = 10;
end

if nargin < 4
    init_value = 0;
end

% Generate the coordinates in the complex plane
[X,Y]=meshgrid(-2:(4/x):2,-2:(4/y):2);
% Combine them into a matrix of complex numbers
Z=X+j*Y;
% Retrieve the dimensions of Z
dims = size(Z);
% The length in the x direction
x_len = dims(1);
% The length in the y direction
y_len = dims(2);
% value is initialized to init_value in every point of the plane
value = ones(x_len,y_len) * init_value;
% In the beginning all points are considered as part of the Mandelbrot
% set. Thus, they are initialized to zero.
ret   = zeros(x_len,y_len);
% The mask which indicates which points have already overflowed, is set
% to zero, to indicate that none have so far.
mask  = zeros(x_len,y_len);
% Perform the check "steps" times
for step=1:steps
    % For every point with a mandel value of "v" and a coordinate of "z"
    % perform  v <- (v ^ 2) + z
    %
    % .* is an element-by-element multiplication of two matrixes of the same size.
    % (regular * indicates matrix multiplication)
    value = (value .* value) + Z;
    % Retrieve the points that overflowed in this iteration
    % An overflowed point has a mandel value with an absolute value greater
    % than 2.
    current_mask = (abs(value) > 2);
    % Update the mask. We use "or" in order to avoid a situation where
    % 1 and 1 become two or so.
    mask = or(mask, current_mask);
    % Upgrade the points in the mask to a greater value in the returned
    % Mandelbrot-map.
    ret = ret + mask;
    % Zero the points that have overflowed, so they will not propagate
    % to infinity.
    value = value .* not(current_mask);
end

% Now ret is ready for prime time so we return it.
