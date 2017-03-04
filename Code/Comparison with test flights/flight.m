function flight(Ve,Pn,Pe,Hp,oat,aoa,beta,gamma,heading,bank,flap,elevator,rudder,aileron,throttle)

% FLIGHT is a GUI that allows the user to update the flight 
% condition. Clicking the UPDATE button updates the initialisation
% parameters. Clicking the OPEN button loads the SimuLink model

% written A Cooke: 15 Jul 08

D2R = pi/180;
F2M = 0.3048;

% Initialize variables
[pISA,tISA] = atmos(Hp * F2M);
offISA      = (273.15 + oat) - tISA; % non-standard atmosphere (degC)
[V,Mach,u,v,w,phi,theta,psi] = GetStates(Ve,Hp,offISA,aoa,beta,gamma,heading,bank);
eta  = elevator * D2R;
zeta = rudder * D2R;
xi = aileron * D2R;

%  Initialize and hide the GUI as it is being constructed.
    f = figure('Visible','off','MenuBar','none','NumberTitle','off','Position',[0,0,500,480]);
    
% Construct the components. 
    htextT1   = uicontrol('Style','text','String','user defined variables','BackgroundColor',[0.797,0.797,0.797],...
        'Position',[20,425,150,15]);  
% Variable lables
    htextEAS   = uicontrol('Style','text','String','EAS (kts)','Position',[20,400,120,17]);  
    htextAOA   = uicontrol('Style','text','String','Incidence (deg)','Position',[20,375,120,17]);
    htextFP    = uicontrol('Style','text','String','Flight Path (deg)','Position',[20,350,120,17]);
    htextSS    = uicontrol('Style','text','String','Sideslip (deg)','Position',[20,325,120,17]);
    htextHEAD  = uicontrol('Style','text','String','Heading (deg)','Position',[20,300,120,17]);
    htextBANK  = uicontrol('Style','text','String','Bank Angle (deg)','Position',[20,275,120,17]);
    htextPN    = uicontrol('Style','text','String','N Position (m)','Position',[20,225,120,17]);
    htextPE    = uicontrol('Style','text','String','E Position (m)','Position',[20,200,120,17]);
    htextHP    = uicontrol('Style','text','String','Altitude (ft)','Position',[20,175,120,17]);
    htextOAT   = uicontrol('Style','text','String','OAT (degC)','Position',[20,150,120,17]);
    align([htextT1,htextEAS,htextAOA,htextFP,htextSS,htextHEAD,htextBANK,htextPN,htextPE,...
        htextHP,htextOAT],'Center','None');
    htext = uicontrol('Style','text','String','aileron','Position',[230,95,80,17]); 
    htext = uicontrol('Style','text','String','elevator','Position',[230,70,80,17]);
    htext = uicontrol('Style','text','String','rudder','Position',[230,45,80,17]);  
    htext = uicontrol('Style','text','String','throttle (%)','Position',[230,20,80,17]);  
    htext = uicontrol('Style','text','String','(deg)','Position',[320,120,50,17],...
        'BackgroundColor',[0.797,0.797,0.797]);
    htext = uicontrol('Style','text','String','(rad)','Position',[390,120,50,17],...
        'BackgroundColor',[0.797,0.797,0.797]);  
    
%--------------------------------------------------------------------------       
% Dependent labels
    htext   = uicontrol('Style','text','String','TAS (m/s)','Position',[250,400,90,17],...
        'BackgroundColor',[0.797,0.797,0.797]);
    htext   = uicontrol('Style','text','String','Mach','Position',[250,375,90,17],...
        'BackgroundColor',[0.797,0.797,0.797]);
    htext   = uicontrol('Style','text','String','roll (rad)','Position',[250,325,90,17],...
        'BackgroundColor',[0.797,0.797,0.797]); 
    htext   = uicontrol('Style','text','String','pitch (rad)','Position',[250,300,90,17],...
        'BackgroundColor',[0.797,0.797,0.797]);
    htext   = uicontrol('Style','text','String','yaw (rad)','Position',[250,275,90,17],...
        'BackgroundColor',[0.797,0.797,0.797]); 
    htext   = uicontrol('Style','text','String','U (m/s)','Position',[250,225,90,17],...
        'BackgroundColor',[0.797,0.797,0.797]); 
    htext   = uicontrol('Style','text','String','V (m/s)','Position',[250,200,90,17],...
        'BackgroundColor',[0.797,0.797,0.797]);
    htext   = uicontrol('Style','text','String','W (m/s)','Position',[250,175,90,17],...
        'BackgroundColor',[0.797,0.797,0.797]); 
    htext  = uicontrol('Style','text','String','Off ISA (degC)','Position',[250,150,120,17],...
        'BackgroundColor',[0.797,0.797,0.797]);
    
% input boxes    
    hEAS  = uicontrol('Style','edit','String',sprintf('%3.0f',Ve),'BackgroundColor','white',...
        'Position',[180,400,50,17],'Callback',{@hEASCurrentValue_Callback});
    hAOA  = uicontrol('Style','edit','String',sprintf('%5.2f',aoa),'BackgroundColor','white',...
        'Position',[180,375,50,17],'Callback',{@hAOACurrentValue_Callback});
    hFP   = uicontrol('Style','edit','String',sprintf('%5.2f',gamma),'BackgroundColor','white',...
        'Position',[180,350,50,17],'Callback',{@hFPCurrentValue_Callback});
    hSS   = uicontrol('Style','edit','String',sprintf('%5.2f',beta),'BackgroundColor','white',...
        'Position',[180,325,50,17],'Callback',{@hSSCurrentValue_Callback});
    hHEAD = uicontrol('Style','edit','String',sprintf('%5.2f',heading),'BackgroundColor','white',...
        'Position',[180,300,50,17],'Callback',{@hHEADCurrentValue_Callback});
    hBANK = uicontrol('Style','edit','String',sprintf('%5.2f',bank),'BackgroundColor','white',...
        'Position',[180,275,50,17],'Callback',{@hBANKCurrentValue_Callback});
    hPN   = uicontrol('Style','edit','String',sprintf('%5.0f',Pn),'BackgroundColor','white',...
        'Position',[180,225,50,17],'Callback',{@hPNCurrentValue_Callback});
    hPE   = uicontrol('Style','edit','String',sprintf('%5.0f',Pe),'BackgroundColor','white',...
        'Position',[180,200,50,17],'Callback',{@hPECurrentValue_Callback});
    hHP   = uicontrol('Style','edit','String',sprintf('%5.0f',Hp),'BackgroundColor','white',...
        'Position',[180,175,50,17],'Callback',{@hHPCurrentValue_Callback});
    hOAT  = uicontrol('Style','edit','String',sprintf('%4.1f',oat),'BackgroundColor','white',...
        'Position',[180,150,50,17],'Callback',{@hOATCurrentValue_Callback});
    hXI   = uicontrol('Style','edit','String',sprintf('%5.2f',aileron),'BackgroundColor','white',...
        'Position',[320,95,50,17],'Callback',{@hXICurrentValue_Callback});
    hETA  = uicontrol('Style','edit','String',sprintf('%5.2f',elevator),'BackgroundColor','white',...
        'Position',[320,70,50,17],'Callback',{@hETACurrentValue_Callback});
    hZETA = uicontrol('Style','edit','String',sprintf('%5.2f',rudder),'BackgroundColor','white',...
        'Position',[320,45,50,17],'Callback',{@hZETACurrentValue_Callback});
    hTAU  = uicontrol('Style','edit','String',sprintf('%4.1f',throttle),'BackgroundColor','white',...
        'Position',[355,20,50,17],'Callback',{@hTAUCurrentValue_Callback});
   
% data cells
    hTAS  = uicontrol('Style','text','String',sprintf('%5.2f',V),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,400,50,17]);
    hMach = uicontrol('Style','text','String',sprintf('%5.3f',Mach),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,375,50,17]);
    hPHI  = uicontrol('Style','text','String',sprintf('%5.3f',phi),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,325,50,17]); 
    hTHETA= uicontrol('Style','text','String',sprintf('%5.3f',theta),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,300,50,17]);
    hPSI  = uicontrol('Style','text','String',sprintf('%5.3f',psi),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,275,50,17]);
    hU    = uicontrol('Style','text','String',sprintf('%5.2f',u),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,225,50,17]); 
    hV    = uicontrol('Style','text','String',sprintf('%5.2f',v),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,200,50,17]);
    hW    = uicontrol('Style','text','String',sprintf('%5.2f',w),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,175,50,17]);
    hISA  = uicontrol('Style','text','String',sprintf('%4.1f',offISA),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,150,50,17]);
    ha    = uicontrol('Style','text','String',sprintf('%5.3f',xi),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[390,95,50,17]); 
    he   = uicontrol('Style','text','String',sprintf('%5.3f',eta),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[390,70,50,17]);
    hr    = uicontrol('Style','text','String',sprintf('%5.3f',zeta),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[390,45,50,17]);
 
%--------------------------------------------------------------------------
% Create the flap position button group.  
    hFlap = uibuttongroup('Titleposition','centertop','Title','Flap','Visible','on',...
      'Units','pixels','Position',[20,10,80,120]);
% Create two radio buttons in the button group. 
    hFlap0  = uicontrol('Style','RadioButton','String',' 0','Position',[20,75,50,20],'Parent',hFlap,...
       'HandleVisibility','off','Tag','0');
    hFlap10 = uicontrol('Style','RadioButton','String','10','Position',[20,55,50,20],'Parent',hFlap,...
       'HandleVisibility','off','Tag','1');
    hFlap20 = uicontrol('Style','RadioButton','String','20','Position',[20,35,50,20],'Parent',hFlap,...
       'HandleVisibility','off','Tag','2');
    hFlap35 = uicontrol('Style','RadioButton','String','35','Position',[20,15,50,20],'Parent',hFlap,...
       'HandleVisibility','off','Tag','3');
%--------------------------------------------------------------------------
% Create update buttons
    hupdate = uicontrol('Style','pushbutton','String','update','Position',[125,80,70,25],...
        'Callback',{@updatebutton_Callback});  
    hopen  = uicontrol('Style','pushbutton','String','open mdl','Position',[125,20,70,25],...
        'Callback',{@openbutton_Callback}); 
    hclose = uicontrol('Style','pushbutton','String','close','Position',[125,50,70,25],...
        'Callback',{@closebutton_Callback},'BackgroundColor',[0.832,0.945,0.820]); 
%--------------------------------------------------------------------------

% Initialize the GUI.
% Change units to normalized so components resize automatically.
    set([f,hFlap],'Units','normalized');
% Assign the GUI a name to appear in the window title.
    set(f,'Name','Flight Condition')
% Move the GUI to the center of the screen.
    movegui(f,'center')
% Make the GUI visible.
    set(f,'Visible','on');
% Initialize flap button group properties. 
set(hFlap,'SelectionChangeFcn',@FlapChanged);
switch flap
    case 0
        set(hFlap,'SelectedObject',hFlap0);   % flaps up
    case 1
        set(hFlap,'SelectedObject',hFlap10);  % flaps 10 deg
    case 2
        set(hFlap,'SelectedObject',hFlap20);  % flaps 20 deg
    case 3
        set(hFlap,'SelectedObject',hFlap35);  % flaps 35 deg
end
        
% callbacks  
% Radio button callback
function FlapChanged(hObject, eventdata,handles)
    selected = get(hFlap,'SelectedObject');
    switch get(selected,'Tag')   % Get Tag of selected object
        case '0'
            flap = 0;
        case '1'
            flap = 1;
        case '2'
            flap = 2;
        case '3'
            flap = 3;
    end        
end

function hEASCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    Ve = str2double(NewStrVal);
end

function hAOACurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    aoa = str2double(NewStrVal);
end

function hFPCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    gamma = str2double(NewStrVal);
end

function hSSCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    beta = str2double(NewStrVal);
end

function hHEADCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    heading = str2double(NewStrVal);
end

function hBANKCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    bank = str2double(NewStrVal);
end

function hPNCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    Pn = str2double(NewStrVal);
end

function hPECurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    Pe = str2double(NewStrVal);
end

function hHPCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    Hp = str2double(NewStrVal);
end

function hOATCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    oat = str2double(NewStrVal);
    [pISA,tISA] = atmos(Hp * F2M);
    offISA      = (273.15 + oat) - tISA; % non-standard atmosphere (degC)
end

function hXICurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    aileron = str2double(NewStrVal);
    xi = aileron * D2R;
    ha    = uicontrol('Style','text','String',sprintf('%5.3f',xi),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[390,95,50,17]);
end

function hETACurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    elevator = str2double(NewStrVal);
    eta = elevator * D2R;
    he   = uicontrol('Style','text','String',sprintf('%5.3f',eta),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[390,70,50,17]);
end

function hZETACurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    rudder = str2double(NewStrVal);
    zeta = rudder * D2R;
    hr    = uicontrol('Style','text','String',sprintf('%5.3f',zeta),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[390,45,50,17]);    
end

function hTAUCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for equivalent air speed
    NewStrVal = get(hObject, 'String'); 
    throttle = str2double(NewStrVal);
end

% Push button callbacks
function updatebutton_Callback(source,eventdata) 
% recalculate dependents and assign values to variables in workspace  
[pISA,tISA] = atmos(Hp * F2M);
offISA      = (273.15 + oat) - tISA; % non-standard atmosphere (degC)
[V,Mach,u,v,w,phi,theta,psi] = GetStates(Ve,Hp,offISA,aoa,beta,gamma,heading,bank);
% update display 
hEAS  = uicontrol('Style','edit','String',sprintf('%3.0f',Ve),'BackgroundColor','white',...
        'Position',[180,400,50,17],'Callback',{@hEASCurrentValue_Callback});
hAOA  = uicontrol('Style','edit','String',sprintf('%5.2f',aoa),'BackgroundColor','white',...
        'Position',[180,375,50,17],'Callback',{@hAOACurrentValue_Callback});
hFP   = uicontrol('Style','edit','String',sprintf('%5.2f',gamma),'BackgroundColor','white',...
        'Position',[180,350,50,17],'Callback',{@hFPCurrentValue_Callback});
hSS   = uicontrol('Style','edit','String',sprintf('%5.2f',beta),'BackgroundColor','white',...
        'Position',[180,325,50,17],'Callback',{@hSSCurrentValue_Callback});
hHEAD = uicontrol('Style','edit','String',sprintf('%5.2f',heading),'BackgroundColor','white',...
        'Position',[180,300,50,17],'Callback',{@hHEADCurrentValue_Callback});
hBANK = uicontrol('Style','edit','String',sprintf('%5.2f',bank),'BackgroundColor','white',...
        'Position',[180,275,50,17],'Callback',{@hBANKCurrentValue_Callback});
hPN   = uicontrol('Style','edit','String',sprintf('%5.0f',Pn),'BackgroundColor','white',...
        'Position',[180,225,50,17],'Callback',{@hPNCurrentValue_Callback});
hPE   = uicontrol('Style','edit','String',sprintf('%5.0f',Pe),'BackgroundColor','white',...
        'Position',[180,200,50,17],'Callback',{@hPECurrentValue_Callback});
hHP   = uicontrol('Style','edit','String',sprintf('%5.0f',Hp),'BackgroundColor','white',...
        'Position',[180,175,50,17],'Callback',{@hHPCurrentValue_Callback});
hOAT  = uicontrol('Style','edit','String',sprintf('%4.1f',oat),'BackgroundColor','white',...
        'Position',[180,150,50,17],'Callback',{@hOATCurrentValue_Callback});
%--------------------------------------------------------------------------    
hTAS  = uicontrol('Style','text','String',sprintf('%5.2f',V),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,400,50,17]);
hMach = uicontrol('Style','text','String',sprintf('%5.3f',Mach),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,375,50,17]);
hPHI  = uicontrol('Style','text','String',sprintf('%5.3f',phi),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,325,50,17]); 
hTHETA= uicontrol('Style','text','String',sprintf('%5.3f',theta),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,300,50,17]);
hPSI  = uicontrol('Style','text','String',sprintf('%5.3f',psi),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,275,50,17]);
hU    = uicontrol('Style','text','String',sprintf('%5.2f',u),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,225,50,17]); 
hV    = uicontrol('Style','text','String',sprintf('%5.2f',v),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,200,50,17]);
hW    = uicontrol('Style','text','String',sprintf('%5.2f',w),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,175,50,17]);
hISA  = uicontrol('Style','text','String',sprintf('%4.1f',offISA),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[360,150,50,17]);    
%--------------------------------------------------------------------------    
% assign new values in workspace
assignin('base','EAS',Ve);
assignin('base','TAS',V);
assignin('base','ALPHA',aoa);
assignin('base','BETA',beta);
assignin('base','GAMMA',gamma);
assignin('base','BANK',bank);
assignin('base','HEADING',heading);
assignin('base','MACH',Mach);
assignin('base','FLAP',flap);
assignin('base','OFF_ISA',offISA);
%--------------------------------------------------------------------------
assignin('base','PHI_0',phi);
assignin('base','THETA_0',theta);
assignin('base','PSI_0',psi);
assignin('base','U_0',u);
assignin('base','V_0',v);
assignin('base','W_0',w);
assignin('base','NORTH_0',Pn);
assignin('base','EAST_0',Pe);
assignin('base','DOWN_0',Hp * F2M);
%--------------------------------------------------------------------------
assignin('base','XI',xi);
assignin('base','ETA',eta);
assignin('base','ZETA',zeta);
assignin('base','TAU',throttle);
assignin('base','XI_d',aileron);
assignin('base','ETA_d',elevator);
assignin('base','ZETA_d',rudder);
end

function openbutton_Callback(source,eventdata) 
% open Simulink model and close GUIs
open('J31_avms_10');
close(f);
end

function closebutton_Callback(source,eventdata) 
% close GUI
close(f);
end

end
