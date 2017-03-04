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
[xtrim,utrim,ytrim,dxtrim] = trim('AssembledTEST1',xini ,uini ,yini ,xfix,ufix,yfix ,dxini,dxfix,options);


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

% Plot position
figure(fig);fig=fig+1;
subplot(3,1,1)
plot(time(:),states(:,10))
title('North position')
xlabel('s')
ylabel('m')

subplot(3,1,2)
plot(time(:),states(:,11))
title('East position')
xlabel('s')
ylabel('m')
subplot(3,1,3)
plot(time(:),-states(:,12))
title('Height')
xlabel('s')
ylabel('m')

% Plot vertical plane trajectory
figure(fig);fig=fig+1;
plot(states(:,10),-states(:,12))
ylim ([1500,3000])
title('Vertical plane trajectory')
xlabel('North position (m)')
ylabel('Height (m)')

% Plot angles
figure(fig);fig=fig+1;
subplot(3,1,1)
plot(time(:),states(:,7)*180/pi)
title('\phi')
xlabel('s')
ylabel('rad')
subplot(3,1,2)
plot(time(:),states(:,8)*180/pi)
title('\theta')
xlabel('s')
ylabel('rad')
subplot(3,1,3)
plot(time(:),states(:,9)*180/pi)
title('\psi')
xlabel('s')
ylabel('rad')

%% Comparison with experimental data SPPO

timeSPPO=xlsread('GPA_SPPO2.xlsx','B2:B1110');
etaSPPO=xlsread('GPA_SPPO2.xlsx','L2:L1110');
qExpSPPO=xlsread('GPA_SPPO2.xlsx','D2:D1110');

ETA =  utrim(1)+etaSPPO*pi/180;
ZETA =  utrim(2)*ones(length(timeSPPO),1);
XI =    utrim(3)*ones(length(timeSPPO),1);
TAU = utrim(4)*ones(length(timeSPPO),1);

U = [timeSPPO,ETA,ZETA,XI,TAU];

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

[time, states, output] = sim('AssembledTEST1', 23,[],U);

figure(fig);fig=fig+1;
plot(time(:),states(:,5)*180/pi)
hold on
plot(timeSPPO,qExpSPPO)
title('SPPO')
xlabel('time (s)')
ylabel('deg/s')

%% Comparison with experimental data Phugoid
timePHU=xlsread('Phugoid_Fri103855.xlsx','A2:A2067');
etaPHU=xlsread('Phugoid_Fri103855.xlsx','F2:F2067');
thetaExpPHU=xlsread('Phugoid_Fri103855.xlsx','C2:C2067');

ETA =  utrim(1)+etaPHU*pi/180;
ZETA =  utrim(2)*ones(length(timePHU),1);
XI =    utrim(3)*ones(length(timePHU),1);
TAU = utrim(4)*ones(length(timePHU),1);

U = [timePHU,ETA,ZETA,XI,TAU];

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

[time, states, output] = sim('AssembledTEST1', 210,[],U);

figure(fig);fig=fig+1;
plot(time(:),states(:,8)*180/pi)
hold on
plot(timePHU,thetaExpPHU)
title('Phugoid')
xlabel('time (s)')
ylabel('deg')


%% Comparison with experimental data DUTCH ROLL
timeDR=xlsread('Dutch-Roll_Fri104819.xlsx','B2:B415');
rudDR=xlsread('Dutch-Roll_Fri104819.xlsx','J2:J415');
rExpDR=xlsread('Dutch-Roll_Fri104819.xlsx','E2:E415');
pExpDR=xlsread('Dutch-Roll_Fri104819.xlsx','F2:F415');

ETA =  utrim(1)*ones(length(timeDR),1);
ZETA =  utrim(2)*ones(length(timeDR),1)+rudDR*pi/180;
XI =    utrim(3)*ones(length(timeDR),1);
TAU = utrim(4)*ones(length(timeDR),1);

U = [timeDR,ETA,ZETA,XI,TAU];

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

[time, states, output] = sim('AssembledTEST1', 20,[],U);

figure(fig);fig=fig+1;
subplot(2,1,1)
plot(time(:),states(:,6)*180/pi)
hold on
plot(timeDR,rExpDR)
title('Yaw rate')
xlabel('time (s)')
ylabel('deg/s')

subplot(2,1,2)
plot(time(:),states(:,4)*180/pi)
hold on
plot(timeDR,pExpDR)
title('Roll rate')
xlabel('time (s)')
ylabel('deg/s')

%% Comparison with experimental data ROLL
timeROLL=xlsread('GpA_Roll.xlsx','B2:B1250');
ailROLL=xlsread('GpA_Roll.xlsx','J2:J1250');
bankExpROLL=xlsread('GpA_Roll.xlsx','C2:C1250');


ETA =  utrim(1)*ones(length(timeROLL),1);
ZETA =  utrim(2)*ones(length(timeROLL),1);
XI =    utrim(3)*ones(length(timeROLL),1)+ailROLL*pi/180;
TAU = utrim(4)*ones(length(timeROLL),1);

U = [timeROLL,ETA,ZETA,XI,TAU];

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

[time, states, output] = sim('AssembledTEST1', 25,[],U);

figure(fig);fig=fig+1;
plot(time(:),states(:,7)*180/pi)
hold on
plot(timeROLL,bankExpROLL)
title('Roll Mode')
xlabel('time (s)')
ylabel('deg')
