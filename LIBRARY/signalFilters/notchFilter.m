function [xf, y] = notchFilter(xf, u, w_0, zeta, h)
% notchFilter is compatible with MATLAB and GNU Octave (www.octave.org).
% This function implements a 2nd-order notch filter using the RK4 method. The 
% filter transfer function is:
%
%    h_notch(s) = (s^2 + 2*zeta*w_0*s+ w_0^2) / (s^2 + 2*w_0*s + w_0^2)
%
% Inputs:
% xf          - Current state (2x1 vector)
% u           - Input signal to be filtered (scalar)
% w_0         - Notch frequency
% zeta        - Damping factor, typical value for a narrow notch is 0.01 to 0.1
% h           - Sampling time
%
% Outputs:
% xf          - Propagated filter state at time k+1 (2x1 vector)
% y           - Filtered output at time k+1 (scalar)
%
% Author: Thor I. Fossen
% Date: 2024-11-27
% Revision: 

xf = xf(:);

% Define 2nd-order filter state-space matrices
A = [0 1; -w_0^2 -2*zeta*w_0];
B = [0; 1];
C = [w_0^2 2*zeta*w_0];
D = 1;

% RK4 implementation for state propagation
k1 = A * xf + B * u;
k2 = A * (xf + 0.5 * h * k1) + B * u;
k3 = A * (xf + 0.5 * h * k2) + B * u;
k4 = A * (xf + h * k3) + B * u;

xf = xf + (h / 6) * (k1 + 2 * k2 + 2 * k3 + k4);

% Compute the filtered output at time k+1
y = C * xf + D * u;

end
