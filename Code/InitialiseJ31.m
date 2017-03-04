% Top Level Initialisation File
% Written by A K Cooke - 20 Apr 07

clear all;
close all;
clc;   

lookup_init;
constants_init;

F2M = 0.3048;
D2R = pi/180;
R2D=180/pi; 
g = 9.81;
G =[0;0;9.81];
% passengers and crew - individual masses (kg) allocated to seat location
% pax_and_crew = [pilot seat,    1A, 2A, 3A, 4A, 5A, 6A, ballast;
%                 copilot seat,  1B, 2B, 3B, 4B, 5B, 6B, computer station;
%                 attendant seat,1C, 2C, 3C, 4C, 5C, 6C, instrumentation];
pax_and_crew =[
    86,0,69,65,64,86,0,180;
    86,0,75,68,58, 90,0,80;
     0,0,75,69,50, 120,0,0];

FUEL = 656.069;   % starting fuel (kg)
FLAP = 0;     % flaps 0=up, 1=10 degrees, 2=20 degrees & 3=35 degrees
UC   = 0;     % undercarriage 0=up & 1=down

% determine inertia properties about cg
[MASS,CG,IXX,IYY,IZZ,IXY,IYZ,IXZ] = init_mass_properties(pax_and_crew,FUEL,UC);


% open GUI to allow update of loading comment out if not required
%loading(FUEL,pax_and_crew,UC,CG,mac)

% create inertia tensor

INERTIA = [IXX,IXY,IXZ;IXY,IYY,IYZ;IXZ,IYZ,IZZ];

% set location and altitude
NORTH_0 = 0.0;  % position in metres
EAST_0  = 0.0;  % position in metres
HP      = 6004;% altitude in ft 
DOWN_0  = HP * F2M;  % convert altitude to metres

% define atmosphere
OAT         = -2.0;                  % outside air temperature (degC)
[pISA,tISA] = atmos(DOWN_0);
OFF_ISA     = (273.15 + OAT) - tISA; % non-standard atmosphere (degC)

% Get initial states from trim value
EAS    =  161.0;     % kts
ALPHA  =  2.62;       % body incidence (deg)
BETA   =  0.0;       % sideslip (deg)
GAMMA  =  0.0;       % flight path angle (deg)
BANK   =  0.0;       % bank angle (deg)
HEADING = 0.0;       % heading (deg)
[TAS,MACH,U_0,V_0,W_0,PHI_0,THETA_0,PSI_0] = GetStates(EAS,HP,OFF_ISA,ALPHA,BETA,GAMMA,HEADING,BANK);
Vm_0 = [U_0;V_0;W_0];
xme_0 = [NORTH_0;EAST_0;-DOWN_0];
eul_0 = [PHI_0;THETA_0;PSI_0];
% intialise other states 
P_0     = 0.0;
Q_0     = 0.0;
R_0     = 0.0;
pm_0 = [P_0;Q_0;R_0];
% set trim control positions (surfaces deflections in deg)
ETA_d  = 2;
ZETA_d = 0.0;
XI_d   = 0.0;
TAU    = 30.0;

% convert to radians
ETA  = ETA_d * D2R;
ZETA = ZETA_d * D2R;
XI   = XI_d * D2R;

% open GUI to update flight condition comment out if not required
%flight(EAS,NORTH_0,EAST_0,HP,OAT,ALPHA,BETA,GAMMA,HEADING,BANK,FLAP,ETA_d,ZETA_d,XI_d,TAU);

%[t,x,y]= sim('AssembledTEST1' ,[0 ,60] ,[] ,'[ETA, ZETA, XI, TAU]')
 

