function [V,Mach,u,v,w,phi,theta,psi] = GetStates(Ve,Hp,offISA,aoa,beta,gamma,heading,bank)

% this function determines the initial aircraft states for use in 
% Initialise J31 and the associated GUI
% written by A Cooke : 16 Jul 08

% constants
F2M = 0.3048;  % convert feet to metres
K2M = 0.5144;  % convert kts to m/s
D2R = pi/180;  % convert degrees to radians

% Obtain atmospheric data
[pISA,tISA] = atmos(Hp * F2M); % pressure and temperature - standard atmosphere
p_amb = pISA;
t_amb = tISA + offISA;         
rho   = p_amb/(287 * t_amb);          % determine air density
a     = sqrt(1.4 * 287 * t_amb);      % determine local speed of sound
V     = (Ve * K2M)*sqrt(1.225/rho);   % determine TAS in m/s
Mach  =  V/a;

% Obtain aircraft attitudes
theta = D2R * (aoa + gamma);
psi   = D2R * (heading - beta);
phi   = bank;

% Obtain body velocities
u = V * cos(D2R * aoa) * cos(D2R * beta);
v = V * sin(D2R * beta);
w = V * sin(D2R * aoa) * cos(D2R * beta);

end