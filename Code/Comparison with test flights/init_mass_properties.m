function [mass,cg,Ixx,Iyy,Izz,Ixy,Iyz,Ixz] = init_mass_properties(pax_and_crew,fuel,uc)

% This function initialises the mass properties of the aircraft. 

% Written by A K Cooke 28 Mar 06, 
% amended 15 Feb 07 to add nacelle mass to engine
% amended 13 Aug 08 to add cg shift with undercarriage

% body axes centre location vector
bac = [223, 0, 0];

% fuselage
Ixx_f = 7078355;
Iyy_f = 64738605;
Izz_f = 64738605;
Ixy_f = 0.0;
Iyz_f = 0.0;
Ixz_f = 0.0;
mass_f = 5309;
cg_f  = [209.1, 0.0, 0.0];

% wing
Ixx_w = 34066713;
Iyy_w = 1524258;
Izz_w = 32733657;
Ixy_w = 0.0;
Iyz_w = 0.0;
Ixz_w = -261511;
mass_w = 2090;
cg_w = [228.5, 0.0, 24.4];

%other fixed structure - mass
mass_tu  = 588;
mass_e   = 894;
mass_ng  = 147;
mass_mg  = 221;

%other fixed structure - cg
cg_tu = [474.0, 0.0,  -53.0];
cg_e1 = [168.1, 105.3, 10.1];
cg_e2 = [168.1,-105.3, 10.1];
if uc == 0 
    cg_ng  = [34.0,  0.0, 24.0];
    cg_mg1 = [241.2, 72.0,26.8];
    cg_mg2 = [241.2,-72.0,26.8];
else
    cg_ng  = [61.0, 0.0, 54.0];
    cg_mg1 = [243.5, 109.6,52.2];
    cg_mg2 = [243.5,-109.6,52.2];
end

%other fixed structure - inertias
I_tu = Get_inertia(mass_tu,bac,cg_tu);
I_e1 = Get_inertia(mass_e,bac,cg_e1);
I_e2 = Get_inertia(mass_e,bac,cg_e2);
I_ng = Get_inertia(mass_ng,bac,cg_ng);
I_mg1= Get_inertia(mass_mg,bac,cg_mg1);
I_mg2= Get_inertia(mass_mg,bac,cg_mg2);

% passengers and crew
pax_and_crew = pax_and_crew * 2.2046; % conversion to lb
mass_p = sum(sum(pax_and_crew));

% seat location
seat_x = [
    111, 152.8, 182.7, 212.7, 250.8, 280.7, 310.6, 395.0;
    111, 152.8, 182.7, 212.7, 250.8, 280.7, 310.6, 336.6;
    376, 152.8, 182.7, 212.7, 250.8, 280.7, 310.6, 337.6];

seat_y = [
    +15.6, -22.48,  -22.48, -22.48, -22.48, -22.48, -22.48, 0;
    -15.6,  +6.88,   +6.88,  +6.88,  +6.88,  +6.88,  +6.88, -22.48;
        0, +22.48,  +22.48, +22.48, +22.48, +22.48, +22.48, +22.48]; 

seat_z = [
    8.36, 2.61, 2.61, 2.61, 2.61, 2.61, 2.61, 0;
    8.36, 2.61, 2.61, 2.61, 2.61, 2.61, 2.61, 0;
       0, 2.61, 2.61, 2.61, 2.61, 2.61, 2.61, 0];

% mass properties of fuel

mass_fl = fuel * 2.2046226218; % fuel mass in lbs for consistency

%fuel data look_up format [fuel,xcg,ycg,zcg,Ixx,Iyy,Izz,Ixz]
fuel_data = [
      0.0,    0.0, 0.0,  0.0,        0,       0,        0,       0;
    104.0,	214.3, 0.0, 30.3,   366036,	 103403,   278376,	 27423;
	298.0,	214.6, 0.0, 29.0,  1392752,	 272618,  1162606,	 73061;
	527.4,	216.3, 0.0, 27.9,  3132715,	 436890,  2747588,	100292;
	796.4,	218.1, 0.0, 26.7,  5929524,	 597618,  5384445,	108173;
	1134.8,	221.0, 0.0, 25.4, 10575415,	 775329,  9866945,	 73227;
	1521.6,	223.4, 0.0, 24.1, 17575971,	 956121, 16731392,	 13729;
	1858.8,	224.6, 0.0, 23.0, 25374079,	1083213, 24437370,  -30044;
	2153.2,	225.3, 0.0, 22.0, 33856112,	1170501, 32859341,  -61713;
	2410.0,	225.8, 0.0, 21.1, 42883714,	1228582, 41849899,  -84080;
	2629.6,	226.0, 0.0, 20.3, 52140939,	1265023, 51086494,  -99100;
	2806.6,	226.2, 0.0, 19.6, 60957918,	1285519, 59894078, -108208;
	2935.0,	226.3, 0.0, 19.1, 68421772,	1295517, 67355423, -113047;
	3020.4,	226.4, 0.0, 18.7, 74152432,	1299768, 73086449, -115165;
	3066.2,	226.4, 0.0, 18.4, 77666920,	1301259, 76601829, -115762;
	3072.0,	226.4, 0.0, 18.4, 78171665,	1301399, 77106713, -115772];  
    
xcg_fl    = interp1(fuel_data(:,1),fuel_data(:,2),mass_fl,'pchip',NaN); 
ycg_fl    = interp1(fuel_data(:,1),fuel_data(:,3),mass_fl,'pchip',NaN); 
zcg_fl    = interp1(fuel_data(:,1),fuel_data(:,4),mass_fl,'pchip',NaN); 
Ixx_fl    = interp1(fuel_data(:,1),fuel_data(:,5),mass_fl,'pchip',NaN); 
Iyy_fl    = interp1(fuel_data(:,1),fuel_data(:,6),mass_fl,'pchip',NaN); 
Izz_fl    = interp1(fuel_data(:,1),fuel_data(:,7),mass_fl,'pchip',NaN); 
Ixz_fl    = interp1(fuel_data(:,1),fuel_data(:,8),mass_fl,'pchip',NaN);     
    
cg_fl = [xcg_fl,ycg_fl,zcg_fl];

% total mass
mass = mass_f + mass_w + 2*mass_e + mass_tu + mass_p + mass_fl + mass_ng + 2*mass_mg;

%cg position
mom_f  = mass_f  * cg_f;
mom_w  = mass_w  * cg_w;
mom_tu = mass_tu * cg_tu;
mom_e1 = mass_e  * cg_e1;
mom_e2 = mass_e  * cg_e2;
mom_fl = mass_fl * cg_fl;
mom_ng = mass_ng * cg_ng;
mom_mg1= mass_mg * cg_mg1;
mom_mg2= mass_mg * cg_mg2;

mom_px = sum(sum(pax_and_crew .* seat_x));
mom_py = sum(sum(pax_and_crew .* seat_y));
mom_pz = sum(sum(pax_and_crew .* seat_z));
mom_p  = [mom_px mom_py mom_pz];

moments = mom_f + mom_w + mom_tu + mom_e1 + mom_e2 + mom_p + mom_fl + mom_ng + mom_mg1 + mom_mg2;
cg = moments/mass;

% mass properties about body axes centre

cg(1) = bac(1) - cg(1);

% passengers and crew
for i = 1:8
    for j = 1:3
        Ixx_pax(j,i) = pax_and_crew(j,i)*((seat_y(j,i) - bac(2))^2 + (seat_z(j,i) - bac(3))^2);
        Iyy_pax(j,i) = pax_and_crew(j,i)*((bac(1) - seat_x(j,i))^2 + (seat_z(j,i) - bac(3))^2);
        Izz_pax(j,i) = pax_and_crew(j,i)*((bac(1) - seat_x(j,i))^2 + (seat_y(j,i) - bac(2))^2);
        Ixy_pax(j,i) = pax_and_crew(j,i)*((bac(1) - seat_x(j,i)) * (seat_y(j,i) - bac(2)));
        Iyz_pax(j,i) = pax_and_crew(j,i)*((seat_y(j,i) - bac(2)) * (seat_z(j,i) - bac(3)));
        Ixz_pax(j,i) = pax_and_crew(j,i)*((bac(1) - seat_x(j,i)) * (seat_z(j,i) - bac(3)));
    end
end

Ixx_p = sum(sum(Ixx_pax));
Iyy_p = sum(sum(Iyy_pax));
Izz_p = sum(sum(Izz_pax));
Ixy_p = sum(sum(Ixy_pax));
Iyz_p = sum(sum(Iyz_pax));
Ixz_p = sum(sum(Ixx_pax));

% total inertias in lb.ins.ins

Ixx = Ixx_f + Ixx_w + I_tu(1) + I_e1(1) + I_e2(1) + I_ng(1) + I_mg1(1) + I_mg2(1) + Ixx_p + Ixx_fl;
Iyy = Iyy_f + Iyy_w + I_tu(2) + I_e1(2) + I_e2(2) + I_ng(2) + I_mg1(2) + I_mg2(2) + Iyy_p + Iyy_fl;
Izz = Izz_f + Izz_w + I_tu(3) + I_e1(3) + I_e2(3) + I_ng(3) + I_mg1(3) + I_mg2(3) + Izz_p + Izz_fl;
Ixy = Ixy_f + Ixy_w + I_tu(4) + I_e1(4) + I_e2(4) + I_ng(4) + I_mg1(4) + I_mg2(4) + Ixy_p;
Iyz = Iyz_f + Iyz_w + I_tu(5) + I_e1(5) + I_e2(5) + I_ng(5) + I_mg1(5) + I_mg2(5) + Iyz_p;
Ixz = Ixz_f + Ixz_w + I_tu(6) + I_e1(6) + I_e2(6) + I_ng(6) + I_mg1(6) + I_mg2(6) + Ixz_p + Ixz_fl;

% convert to SI units (kg.m.m)

Ixx = Ixx * 0.0002926396563;
Iyy = Iyy * 0.0002926396563;
Izz = Izz * 0.0002926396563;
Ixy = Ixx * 0.0002926396563;
Iyz = Iyy * 0.0002926396563;
Ixz = Izz * 0.0002926396563;

mass = mass/2.2046226218;

cg = cg * 0.0254;

return

function inertia = Get_inertia(mass,xyz2,xyz1)

% this function determines the inertia of a point mass
% located at xyz1 about another point located at xzy2

% written by A K Cooke - 28 Mar 06

Ixx = mass * (xyz2(1) - xyz1(1))^2;
Iyy = mass * (xyz1(2) - xyz2(2))^2;
Izz = mass * (xyz1(3) - xyz2(3))^2;
Ixy = mass * (xyz2(1) - xyz1(1)) * (xyz1(2) - xyz2(2));
Iyz = mass * (xyz1(2) - xyz2(2)) * (xyz1(3) - xyz2(3));
Ixz = mass * (xyz2(1) - xyz1(1)) * (xyz1(3) - xyz2(3));

inertia = [Ixx, Iyy, Izz, Ixy, Iyz, Ixz];