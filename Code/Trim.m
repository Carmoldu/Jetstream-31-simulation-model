fig=1;

%% TRIM

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
[xtrim,utrim,ytrim,dxtrim] = trim('AssembledTEST1',xini ,uini ,yini ,xfix,ufix,yfix ,dxini,dxfix,options)


%% Plot results of the trim

% time vector
t = 1:0.1:60;

% Trimmed inputs
ETA =  utrim(1)*ones(length(t),1);
ZETA =  utrim(2)*ones(length(t),1);
XI =    utrim(3)*ones(length(t),1);
TAU = utrim(4)*ones(length(t),1);

U = [t(:),ETA,ZETA,XI,TAU];
% 
% % Simulate with original initial conditions
% [time, states, output] = sim('AssembledTEST1', 60,[],U);
% 
% % Plot position
% figure(fig);fig=fig+1;
% subplot(3,1,1)
% plot(time(:),states(:,10))
% subplot(3,1,2)
% plot(time(:),states(:,11))
% subplot(3,1,3)
% plot(time(:),-states(:,12))
% 
% % Plot vertical plane trajectory
% figure(fig);fig=fig+1;
% plot(states(:,10),-states(:,12))
% ylim ([1500,3000])
% 
% % Plot angles
% figure(fig);fig=fig+1;
% subplot(3,1,1)
% plot(time(:),states(:,7)*180/pi)
% subplot(3,1,2)
% plot(time(:),states(:,8)*180/pi)
% subplot(3,1,3)
% plot(time(:),states(:,9)*180/pi)

% Simulate with trimmed initial conditions
NORTH_0 = xtrim(10);  
EAST_0  = xtrim(11);  
DOWN_0  = -xtrim(12); 

U_0 = xtrim(1);
V_0 = xtrim(2);
W_0 = xtrim(3);

P_0 = xtrim(4);
Q_0 = xtrim(5);
R_0 = xtrim(6);

PHI_0 = xtrim(7);
THETA_0 = xtrim(8);
PSI_0 = xtrim(9);

[time, states, output] = sim('AssembledTEST1', 60,[],U);

% % Plot position
% figure(fig);fig=fig+1;
% subplot(3,1,1)
% plot(time(:),states(:,10))
% title('North position')
% xlabel('s')
% ylabel('m')
% 
% subplot(3,1,2)
% plot(time(:),states(:,11))
% title('East position')
% xlabel('s')
% ylabel('m')
% subplot(3,1,3)
% plot(time(:),-states(:,12))
% title('Height')
% xlabel('s')
% ylabel('m')
% 
% % Plot vertical plane trajectory
% figure(fig);fig=fig+1;
% plot(states(:,10),-states(:,12))
% ylim ([1500,3000])
% title('Vertical plane trajectory')
% xlabel('North position (m)')
% ylabel('Height (m)')
% 
% % Plot angles
% figure(fig);fig=fig+1;
% subplot(3,1,1)
% plot(time(:),states(:,7)*180/pi)
% title('\phi')
% xlabel('s')
% ylabel('rad')
% subplot(3,1,2)
% plot(time(:),states(:,8)*180/pi)
% title('\theta')
% xlabel('s')
% ylabel('rad')
% subplot(3,1,3)
% plot(time(:),states(:,9)*180/pi)
% title('\psi')
% xlabel('s')
% ylabel('rad')

% Plot fixed variables
figure(fig);fig=fig+1;
subplot(2,1,1)
plot(time(:),-states(:,12))
title('Height')
xlabel('s')
ylabel('m')

subplot(2,1,2)
plot(time(:),output(:,1))
title('Velocity')
xlabel('s')
ylabel('m/s')

figure(fig);fig=fig+1;
subplot(3,1,1)
plot(time(:),states(:,4))
title('P')
xlabel('s')
ylabel('rad/s')
subplot(3,1,2)
plot(time(:),states(:,5))
title('Q')
xlabel('s')
ylabel('rad/s')
subplot(3,1,3)
plot(time(:),states(:,6))
title('R')
xlabel('s')
ylabel('rad/s')



%% LINEARIZATION

[A,B,C,D] = linmod('AssembledTEST1',xtrim, utrim);

% Remove residuals
tolerance = 10e-4;

Ares=A;
Bres=B;
Ares (abs(Ares)<tolerance)= 0;
Bres (abs(Bres)<tolerance)= 0;


%% Decoupled modes

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
[NumZeta, DenLat] = ss2tf(ALat, BLat, CLat, DLat, 1);
[NumXi, DenLat] = ss2tf(ALat, BLat, CLat, DLat, 2);

NUM = { NumEta;
        NumTau;
        NumZeta;
        NumXi};
DEN = { DenLong;
        DenLong;
        DenLat;
        DenLat};
    

% Compute the transfer functions
eta_u    =zpk(tf(NUM{1}(1, :), DEN{1}))
eta_w    =zpk(tf(NUM{1}(2, :), DEN{1}))
eta_q    =zpk(tf(NUM{1}(3, :), DEN{1}))
eta_theta=zpk(tf(NUM{1}(4, :), DEN{1}))
tau_1    =zpk(tf(NUM{2}(1, :), DEN{2}))
tau_w    =zpk(tf(NUM{2}(2, :), DEN{2}))
tau_q    =zpk(tf(NUM{2}(3, :), DEN{2}))
tau_theta=zpk(tf(NUM{2}(4, :), DEN{2}))
zeta_v   =zpk(tf(NUM{3}(1, :), DEN{3}))
zeta_p   =zpk(tf(NUM{3}(2, :), DEN{3}))
zeta_r   =zpk(tf(NUM{3}(3, :), DEN{3}))
zeta_phi =zpk(tf(NUM{3}(4, :), DEN{3}))
zeta_psi =zpk(tf(NUM{3}(5, :), DEN{3}))
xi_v     =zpk(tf(NUM{4}(1, :), DEN{4}))
xi_p     =zpk(tf(NUM{4}(2, :), DEN{4}))
xi_r     =zpk(tf(NUM{4}(3, :), DEN{4}))
xi_phi   =zpk(tf(NUM{4}(4, :), DEN{4}))
xi_psi   =zpk(tf(NUM{4}(5, :), DEN{4}))


%% Compare linear vs non-linear

% Define inputs
longtime = 0:0.1:300;
shorttime = 0:0.01:5;

input.impulselong = [zeros(1, 201) ones(1, 2) zeros(1, 2798)];%impulse longtime
input.impulseshort = [zeros(1, 51) ones(1, 2) zeros(1, 448)];%impulse shorttime
input.steplong = [zeros(1, 201) ones(1, 2800)];%step longtime
input.stepshort = [zeros(1, 51) ones(1, 450)];%step shorttime


% Simulate
ySPPOlin = lsim(eta_q, input.stepshort, shorttime);    %Linear SPPO pitch rate to elevator [s-1]

yPHUlin = lsim(eta_u, input.impulselong*pi/180, longtime); %Linear phugoid forward speed to elevator [ft*s-1*deg-1]

yDRlin1= lsim(zeta_r, input.impulseshort, shorttime); %Linear Dutch roll yaw-rate to rudder [s-1]
yDRlin2= lsim(zeta_p, input.impulseshort, shorttime); %Linear Dutch roll roll-rate to rudder [s-1]

yRMlin= lsim(xi_p, input.stepshort, shorttime); %Linear roll mode roll rate to aileron

ySPIlin= lsim(xi_phi, input.impulselong, longtime);%Linear spiral mode bank angle to aileron

