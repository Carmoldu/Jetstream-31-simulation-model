%% TRIM
fig=1;
[time, states, output] = sim('AssembledTEST1', 60);
[ sizes ,initial , names ]= AssembledTEST1;

%x=[u v w  p q r  phi theta psi X Y Z]
%y=[V_mag alphaBody betaBody]
%u=[Eta Zeta Xi Tau]

xini=[U_0; V_0; W_0; P_0; Q_0; R_0; PHI_0; THETA_0; PSI_0; NORTH_0; EAST_0; -DOWN_0];
xfix=[4;5; 6; 12];

uini=[ETA; ZETA; XI; TAU];
ufix=[];

yini=[TAS; 0; 0];
yfix=[1];

dxini=[0;0;0;0;0;0;0;0;0;TAS;0;0];
dxfix=[1; 2; 3; 4; 5; 6; 7; 8; 9;10; 11; 12];

options(14) = 1000000;
[xtrim,utrim,ytrim,dxtrim] = trim('AssembledTEST1',xini ,uini ,yini ,xfix,ufix,yfix ,dxini,dxfix,options);




%% LINEARIZATION

[A,B,C,D] = linmod('AssembledTEST1',xtrim, utrim)

% Remove residuals
tolerance = 10e-4;

Ares=A;
Bres=B;
Ares (abs(Ares)<tolerance)= 0;
Bres (abs(Bres)<tolerance)= 0;

% Decoupled modes
%Original variables: 
%x=[u v w  p q r  phi theta psi X Y Z]
%y=[V_mag alphaBody betaBody]
%u=[Eta Zeta Xi Tau]


% Longitudinal mode
% uLong=[eta thau] xLong=[u w q theta]
ALong=[Ares(1,1) Ares(1,3) Ares(1,5) Ares(1,8)
       Ares(3,1) Ares(3,3) Ares(3,5) Ares(3,8)
       Ares(5,1) Ares(5,3) Ares(5,5) Ares(5,8)
       Ares(8,1) Ares(8,3) Ares(8,5) Ares(8,8)]
   
BLong=[Bres(1,1) Bres(1,4)
       Bres(3,1) Bres(3,4)
       Bres(5,1) Bres(5,4)
       Bres(8,1) Bres(8,4)]
   
CLong=eye(size(ALong))
DLong=zeros(size(BLong))

% Lateral-directional Mode
% uLat=[zeta xi] xLat=[v p r phi psi]

ALat=[Ares(2,2) Ares(2,4) Ares(2,6) Ares(2,7) Ares(2,9)
       Ares(4,2) Ares(4,4) Ares(4,6) Ares(4,7) Ares(4,9)
       Ares(6,2) Ares(6,4) Ares(6,6) Ares(6,7) Ares(6,9)
       Ares(7,2) Ares(7,4) Ares(7,6) Ares(7,7) Ares(7,9)
       Ares(9,2) Ares(9,4) Ares(9,6) Ares(9,7) Ares(9,9)]
   
BLat=[Bres(2,2) Bres(2,3)
       Bres(4,2) Bres(4,3)
       Bres(6,2) Bres(6,3)
       Bres(7,2) Bres(7,3)
       Bres(9,2) Bres(9,3)]
   
CLat=eye(size(ALat))
DLat=zeros(size(BLat))


% Transfer functions
[NumEta, DenLong] = ss2tf(ALong, BLong, CLong, DLong, 1);
[NumTau, DenLong] = ss2tf(ALong, BLong, CLong, DLong, 2);
[NumZeta, DenLat1] = ss2tf(ALat, BLat, CLat, DLat, 1);
[NumXi, DenLat2] = ss2tf(ALat, BLat, CLat, DLat, 2);


% Compute the transfer functions
eta_u    =zpk(tf(NumEta(1, :), DenLong))
eta_w    =zpk(tf(NumEta(2, :), DenLong))
eta_q    =zpk(tf(NumEta(3, :), DenLong))
eta_theta=zpk(tf(NumEta(4, :), DenLong))
tau_1    =zpk(tf(NumTau(1, :), DenLong))
tau_w    =zpk(tf(NumTau(2, :), DenLong))
tau_q    =zpk(tf(NumTau(3, :), DenLong))
tau_theta=zpk(tf(NumTau(4, :), DenLong))
zeta_v   =zpk(tf(NumZeta(1, :), DenLat1))
zeta_p   =zpk(tf(NumZeta(2, :), DenLat1))
zeta_r   =zpk(tf(NumZeta(3, :), DenLat1))
zeta_phi =zpk(tf(NumZeta(4, :), DenLat1))
zeta_psi =zpk(tf(NumZeta(5, :), DenLat1))
xi_v     =zpk(tf(NumXi(1, :), DenLat2))
xi_p     =zpk(tf(NumXi(2, :), DenLat2))
xi_r     =zpk(tf(NumXi(3, :), DenLat2))
xi_phi   =zpk(tf(NumXi(4, :), DenLat2))
xi_psi   =zpk(tf(NumXi(5, :), DenLat2))


%% Frequency analysis

% Add a delay to the TF to account for the mechanical slop and blaklash of
% 0.01s

s=tf('s');
eta_theta_delay=eta_theta*exp(-0.01*s)

W=logspace(-2,2,1000);
bode(-eta_theta_delay,W)


