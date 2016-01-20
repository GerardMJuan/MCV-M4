function [u, v] = optic_flow_brox(img1, img2)

% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.

alpha = 30.0 ; % Global smoothness variable.
gamma = 80.0 ; % Global weight for derivatives.

% laplacian pyramid.
im1_hr = img1;
im2_hr = img2;
u = zeros(size((im1_hr))); % Initialization.
v = zeros(size((im1_hr)));

I1 = im1_hr ;
I2 = im2_hr ;

% Computing derivatives.
[Ikx Iky] = imgGrad( I2 ) ;
[Ikx2 Iky2] = imgGrad( I1 ) ;
Ikz = double(I2) - double(I1) ;
Ixz = double(Ikx) - double(Ikx2) ;
Iyz = double(Iky) - double(Iky2) ;

% Calling the processing for a particular resolution.
% Last two arguments are the outer and inner iterations, respectively.
% 1.8 is the omega value for the SOR iteration.
[du, dv] = resolutionProcess_brox( Ikz, Ikx, Iky, Ixz, Iyz, alpha, gamma, 1.8, u, v, 3, 500 ) ;

% Adding up the optical flow.
u = u + du ;
v = v + dv ;


% Resize optical flow to current resolution.
u = imresize( u, [size(im1_hr, 1), size(im1_hr, 2)], 'bilinear' ) ;
v = imresize( v, [size(im1_hr, 1), size(im1_hr, 2)], 'bilinear' ) ;

end
