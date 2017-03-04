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


%% Compare linear vs non-linear

% Define inputs
longtime = 0:0.1:200;
shorttime = 0:0.01:5;

input.impulselong = [zeros(1, 201) ones(1, 2) zeros(1, 1798)];%impulse longtime
input.impulseshort = [zeros(1, 51) ones(1, 2) zeros(1, 448)];%impulse shorttime
input.steplong = [zeros(1, 201) ones(1, 1800)];%step longtime
input.stepshort = [zeros(1, 51) ones(1, 450)];%step shorttime




%% Simulate dynamic response for Non linear Model
%Trim inputs
ETAinit_short =  utrim(1)*ones(length(shorttime),1);
ZETAinit_short =  utrim(2)*ones(length(shorttime),1);
XIinit_short =    utrim(3)*ones(length(shorttime),1);
TAU_short = utrim(4)*ones(length(shorttime),1);

ETAinit_long =  utrim(1)*ones(length(longtime),1);
ZETAinit_long =  utrim(2)*ones(length(longtime),1);
XIinit_long =    utrim(3)*ones(length(longtime),1);
TAU_long = utrim(4)*ones(length(longtime),1);


Uinit_short = [shorttime(:),ETAinit_short,ZETAinit_short,XIinit_short,TAU_short];
Uinit_long = [longtime(:),ETAinit_long,ZETAinit_long,XIinit_long,TAU_long];
%% define inputs

U_SPPO  = Uinit_short + [zeros(length(shorttime),1), input.stepshort'*pi/180 , zeros(length(shorttime),1),zeros(length(shorttime),1) ,zeros(length(shorttime),1)];

U_PHU   = Uinit_long + [zeros(length(longtime),1), input.impulselong'*pi/180 , zeros(length(longtime),1),zeros(length(longtime),1) ,zeros(length(longtime),1)];

U_DR    = Uinit_short + [zeros(length(shorttime),1), zeros(length(shorttime),1) ,input.impulseshort'*pi/180, zeros(length(shorttime),1),zeros(length(shorttime),1)];

U_RM    = Uinit_short + [zeros(length(shorttime),1), zeros(length(shorttime),1), zeros(length(shorttime),1),input.stepshort'*pi/180 ,zeros(length(shorttime),1)];

U_SPI   = Uinit_long + [zeros(length(longtime),1), zeros(length(longtime),1),zeros(length(longtime),1),input.impulselong'*pi/180 ,zeros(length(longtime),1)];
%%
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

[time_RM, states_RM, output_RM] = sim('AssembledTEST1', 5 ,[],U_RM);

[time_SPI, states_SPI, output_SPI] = sim('AssembledTEST1', 200 ,[],U_SPI);


[time_SPPO, states_SPPO, output_SPPO] = sim('AssembledTEST1', 5 ,[],U_SPPO);

[time_PHU, states_PHU, output_PHU] = sim('AssembledTEST1', 200 ,[],U_PHU);

[time_DR, states_DR, output_DR] = sim('AssembledTEST1', 5 ,[],U_DR);


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

% NUM = { NumEta;
%         NumTau;
%         NumZeta;
%         NumXi};
% DEN = { DenLong;
%         DenLong;
%         DenLat;
%         DenLat};
    

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

%% Simulate dynamic response for linear Model
ySPPOlin = lsim(eta_q, input.stepshort*pi/180, shorttime);    %Linear SPPO pitch rate to elevator [s-1]

yPHUlin = lsim(eta_u, input.impulselong*pi/180, longtime); %Linear phugoid forward speed to elevator [ft*s-1*deg-1]
yPHUlin = xtrim(1)+yPHUlin;

yDRlin1= lsim(zeta_r, input.impulseshort*pi/180, shorttime); %Linear Dutch roll yaw-rate to rudder [s-1]
yDRlin2= lsim(zeta_p, input.impulseshort*pi/180, shorttime); %Linear Dutch roll roll-rate to rudder [s-1]

yRMlin= lsim(xi_p, input.stepshort*pi/180, shorttime); %Linear roll mode roll rate to aileron

ySPIlin= lsim(xi_phi, input.impulselong*pi/180, longtime);%Linear spiral mode bank angle to aileron


%%
% Plot : Non linear model and Linear model :

% SPPO
figure(fig) ; fig=fig+1;
plot(time_SPPO(:),states_SPPO(:,5)*180/pi)
hold on 
plot(shorttime, ySPPOlin*180/pi)
legend('q_N_o_n_ _L_i_n_e_a_r','q_L_i_n_e_a_r')
title('SPPO Mode (1 degree step input to elevator)')
xlabel('time (s)')
ylabel('q (deg/s)')

% Phugoid
figure(fig) ; fig=fig+1;
plot(time_PHU(:),states_PHU(:,1))
hold on 
plot(longtime, yPHUlin)
legend('U_N_o_n_ _L_i_n_e_a_r','U_L_i_n_e_a_r')
title('Phugoid Mode (1 degree impulse input to elevator)')
xlabel('time (s)')
ylabel('u (m/s)')

% Dutch roll
figure(fig) ; fig=fig+1;
subplot(2,1,1)
plot(time_DR(:),states_DR(:,6)*180/pi)
hold on 
plot(shorttime, yDRlin1*180/pi)
legend('r_N_o_n_ _L_i_n_e_a_r','r_L_i_n_e_a_r')
title('DR Mode (1 degree impulse input to rudder)')
xlabel('time (s)')
ylabel('r (deg/s)')

subplot(2,1,2)
plot(time_DR(:),states_DR(:,4)*180/pi)
hold on 
plot(shorttime, yDRlin2*180/pi)
legend('p_N_o_n_ _L_i_n_e_a_r','p_L_i_n_e_a_r')
title('DR Mode (1 degree impulse input to rudder)')
xlabel('time (s)')
ylabel('p (deg/s)')

% Roll Mode
figure(fig) ; fig=fig+1;
plot(time_RM(:),states_RM(:,4)*180/pi)
hold on 
plot(shorttime, yRMlin*180/pi)
legend('p_N_o_n_ _L_i_n_e_a_r','p_L_i_n_e_a_r')
title('Roll Mode')
xlabel('time (s)')
ylabel('p (deg/s)')

% Spiral Mode
figure(fig) ; fig=fig+1;
plot(time_SPI(:),(states_SPI(:,7)-0.02266)*180/pi)
hold on 
plot(longtime, ySPIlin*180/pi)
legend('\phi_N_o_n_ _L_i_n_e_a_r','\phi_L_i_n_e_a_r')
title('Spiral Mode')
xlabel('time (s)')
ylabel('bank angle (deg)')


