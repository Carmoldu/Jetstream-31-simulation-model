% Initialisation File
% This file sets all the constants for the J31 simulation
% Written by A K Cooke - 6 Mar 07, updated 22 Nov 10

Sw = 25.084;    % wing area in sq metres
St = 7.785;     % tailplane area in sq metres
Sf = 4.734;     % fin area in sq metres

% wing data
iw      = d2r(1.33);                    % setting angle of wing MAC in degrees
xb0_c0  = 0.248;                        % position of aerocentre behind wing apex/centreline wing chord
c0      = 2.3774;                       % centreline chord in metres
xb0     = c0 * xb0_c0;                  % position of aerocentre behind wing apex
mac     = 1.716;                        % mean aerodynamic chord in metres
zacw    = 0.929 - (3.307 * tan(d2r(7)));% vertical location of MAC below body axes centre
Aw      = 10.0;                         % aspect ratio
b       = 15.85;                        % span
piAw    = Aw * pi;

D0q_10  = 0.0778;                       % drag area 10deg flap
D0q_20  = 0.2634;                       % drag area 20deg flap
D0q_35  = 0.7099;                       % drag area 35deg flap

% tail data
it      = d2r(-2.3);        % tailplane setting angle relative to centreline wing mean aerodynamic chord in degrees
crt     = 1.6764;           % tailplane root chord in metres
l_t     = 11.6205 - 5.6642; % distance from body axes centre to tailplane root chord leading edge in metres
e0      = d2r(2.0);         % downwash at zero lift        
zact    = -1.435;           % vertical location of tailplane below body axes centre
At      = 5.6;              % aspect ratio
piAt    = At * pi;
Lt      = 4.686;            % direct distance between wing TE (centreline) and MAC/4 for tailplane in metres
gamma_t = 0.578;            % angle between wing chord plane and Lt in radians

% fuselage data
df      = 1.981;                    % fuselage diameter in metres
Sref    = (pi/4) * df^2;            % fuselage reference area
DCM0b   = -0.188;                   % fuselage contribution to wing zero lift pitching moment coefficient

% fin data
Af   = 2.838;                % aspect ratio
piAf = Af * pi;
xacf = -6.653;               % location of fin aerocentre in front of body axes centre
zacf = -1.741;               % vertical location of fin aerocentre below body axes centre
J_W  = 1.26;                 % fin sideforce correction factor due to presence of wing

% engine data
elaw_2 = -6.94240e-3;       % polynominal coefficients for static engine law
elaw_1 =  8.98698;          % Referred FFR (kg/h) to Referred Power (SHP)
elaw_0 = -7.50225e+2;
mach_ffr = 0.4158;          % Mach effects : FFR = FFR_static(1 + mach_ffr * Mach^2)
mach_pow = 0.7984;          % Mach effects : POW = POW_static(1 + mach_pow * Mach^2)

% nacelle data
xacn = (223 - 197.3)*0.3048/12; % horizontal location of nacelle aerocentre from body axes centre
zacn = 11.5*0.3048/12;          % vertical location of nacelle aerocentre from body axes centre
Sn   = 0.552;                   % maximum nacelle cross-sectional area
Iwn2 = 0.636;                   % width squared integral for free moments - NASA TN D-6800

% propeller data
n   = 1591/60;                % datum propeller speed in revs/sec
D   = 2.692;                  % propeller diameter in metres
s_e = 0.0954;                 % solidity
Ap  = pi * (D^2)/4;           % propeller disc area
c_i = 1.847;                  % wing chord at engine centreline
Xp_dash = 79.4  * 0.3048/12;            % position of c_i/4 aft of propeller
Zt_dash = 12.0  * 0.3048/12;            % position of c_i/4 below thrust line    
Lt_dash = 247.1 * 0.3048/12;            % position of c_t/4 behind c_i/4 
Z_ht = 11.5*0.3048/12 - zact;           % postion of tailplane above c_i/4
X_ci =((223 - 140)*0.3048/12) - Xp_dash;% position of c_i/4 fwd of BAC
Z_ci =(11.5*0.3048/12) + Zt_dash;       % position of c_i/4 below BAC

xyz_s = [140.0*0.3048/12; 107.0*0.3048/12;11.5*0.3048/12]; % location from body axes centre in metres
xyz_p = [140.0*0.3048/12;-107.0*0.3048/12;11.5*0.3048/12];

Sit   = 1.874;                  % area of tailplane immersed in propeller wake (plan view - one engine)  
ycit  = 2.306;                                      % lateral offset of c_it (MAC of immersed tailplane)
xcit  = -l_t - ycit * sin(d2r(11.31)) - (0.981/4);  % longitudinal offset of c_it (MAC of immersed tailplane)

% Lateral-Directional Constants

Yv_wb   = -0.2627;       % aeronormalised sideforce derivative for wing/body combination
Yv_n    = -0.0458;       % aeronormalised sideforce derivative for nacelles   
Yr_b    = -0.0283;       % aeronormalised sideforce derivative for body   
Lv_n    =  0.0165;       % aeronormalised rolling moment derivative for nacelle
Lv_h    =  0.0445;       % aeronormalised rolling moment derivative from wing-body interference
Nv_wb   = -0.0719;       % aeronormalised yawing moment derivative for wing/body combination
Nv_n    = -0.0005;       % aeronormalised yawing moment derivative for nacelles
Nr_b    = -0.0060;       % aeronormalised yawing moment derivative for body
Lv_b    = -0.00145;      % fuselage contribution to Lv (function of body incidence [deg]) 

% flap contribution to Lr
L_r0_10f  = -0.0096;
L_r0_20f  = -0.0180;
L_r0_35f  = -0.0245;

% aileron terms

H_eta_i = 0.0770;
H_eta_o = 0.0715;
  