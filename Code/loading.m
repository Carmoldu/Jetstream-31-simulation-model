function loading(fuel,pax_and_crew,uc,cg,mac)
% LOADING is a gui that allows the user to update the passenger load
% fuel state and undercarriage state. Clicking the update button
% recalculates the cg position and inertias

% written A Cooke: 11 Jul 08

% Initialize variables

sFL   = num2str(fuel);
mFL   = fuel;
cgx   = 30.0 - (100*cg(1)/mac);

% obtain loading from initialisation using seating arrangement:
%   [pilot seat,    1A, 2A, 3A, 4A, 5A, 6A, ballast;
%    copilot seat,  1B, 2B, 3B, 4B, 5B, 6B, computer station;
%    attendant seat,1C, 2C, 3C, 4C, 5C, 6C, instrumentation
% create strings for GUI
s1A = num2str(pax_and_crew(1,2)); s1B = num2str(pax_and_crew(2,2)); s1C = num2str(pax_and_crew(3,2));
s2A = num2str(pax_and_crew(1,3)); s2B = num2str(pax_and_crew(2,3)); s2C = num2str(pax_and_crew(3,3));
s3A = num2str(pax_and_crew(1,4)); s3B = num2str(pax_and_crew(2,4)); s3C = num2str(pax_and_crew(3,4));
s4A = num2str(pax_and_crew(1,5)); s4B = num2str(pax_and_crew(2,5)); s4C = num2str(pax_and_crew(3,5));
s5A = num2str(pax_and_crew(1,6)); s5B = num2str(pax_and_crew(2,6)); s5C = num2str(pax_and_crew(3,6));
s6A = num2str(pax_and_crew(1,7)); s6B = num2str(pax_and_crew(2,7)); s6C = num2str(pax_and_crew(3,7));
sAS = num2str(pax_and_crew(3,1)); sCS = num2str(pax_and_crew(2,8)); sBL = num2str(pax_and_crew(1,8)); 
% initilaise masses
m1A = pax_and_crew(1,2); m1B = pax_and_crew(2,2); m1C = pax_and_crew(3,2);
m2A = pax_and_crew(1,3); m2B = pax_and_crew(2,3); m2C = pax_and_crew(3,3);
m3A = pax_and_crew(1,4); m3B = pax_and_crew(2,4); m3C = pax_and_crew(3,4);
m4A = pax_and_crew(1,5); m4B = pax_and_crew(2,5); m4C = pax_and_crew(3,5);
m5A = pax_and_crew(1,6); m5B = pax_and_crew(2,6); m5C = pax_and_crew(3,6);
m6A = pax_and_crew(1,7); m6B = pax_and_crew(2,7); m6C = pax_and_crew(3,7);
mAS = pax_and_crew(3,1); mCS = pax_and_crew(2,8); mBL = pax_and_crew(1,8);


%  Initialize and hide the GUI as it is being constructed.
    f = figure('Visible','off','MenuBar','none','NumberTitle','off','Position',[0,0,300,480]);
    
% Construct the components.
% labels
    htext   = uicontrol('Style','text','String','all masses in kg','FontWeight','bold',...
        'Position',[10,450,120,15],'BackgroundColor',[0.797,0.797,0.797]);
    htextA   = uicontrol('Style','text','String','Seat A','Position',[90,425,50,15]);
    htextB   = uicontrol('Style','text','String','Seat B','Position',[160,425,50,15]);
    htextC   = uicontrol('Style','text','String','Seat C','Position',[230,425,50,15]);
    htext   = uicontrol('Style','text','String','Row 1','Position',[20,400,50,15]);   
    htext   = uicontrol('Style','text','String','Row 2','Position',[20,375,50,15]); 
    htext   = uicontrol('Style','text','String','Row 3','Position',[20,350,50,15]);   
    htext   = uicontrol('Style','text','String','Row 4','Position',[20,325,50,15]); 
    htext   = uicontrol('Style','text','String','Row 5','Position',[20,300,50,15]);   
    htext   = uicontrol('Style','text','String','Row 6','Position',[20,275,50,15]); 
    htext   = uicontrol('Style','text','String','Computer Station','Position',[20,250,150,17]); 
    htext   = uicontrol('Style','text','String','Flight Attendant Seat','Position',[20,225,150,17]); 
    htext   = uicontrol('Style','text','String','Fuel Quantity','Position',[20,200,150,17]); 
    htext   = uicontrol('Style','text','String','Ballast in Baggage Bay','Position',[20,175,150,17]); 
    htext   = uicontrol('Style','text','String','cg (% MAC)','Position',[180,120,100,17],...
        'BackgroundColor',[0.797,0.797,0.797]); 
% input boxes    
    hmass1A   = uicontrol('Style','edit','String',s1A,'BackgroundColor','white','Position',[90,400,35,15],...
        'Callback',{@m1ACurrentValue_Callback});
    hmass2A   = uicontrol('Style','edit','String',s2A,'BackgroundColor','white','Position',[90,375,35,15],...
        'Callback',{@m2ACurrentValue_Callback});
    hmass3A   = uicontrol('Style','edit','String',s3A,'BackgroundColor','white','Position',[90,350,35,15],...
        'Callback',{@m3ACurrentValue_Callback});
    hmass4A   = uicontrol('Style','edit','String',s4A,'BackgroundColor','white','Position',[90,325,35,15],...
        'Callback',{@m4ACurrentValue_Callback});
    hmass5A   = uicontrol('Style','edit','String',s5A,'BackgroundColor','white','Position',[90,300,35,15],...
        'Callback',{@m5ACurrentValue_Callback});
    hmass6A   = uicontrol('Style','edit','String',s6A,'BackgroundColor','white','Position',[90,275,35,15],...
        'Callback',{@m6ACurrentValue_Callback});
    align([htextA,hmass1A,hmass2A,hmass3A,hmass4A,hmass5A,hmass6A],'Center','None');
%--------------------------------------------------------------------------    
    hmass1B   = uicontrol('Style','edit','String',s1B,'BackgroundColor','white','Position',[160,400,35,15],...
        'Callback',{@m1BCurrentValue_Callback});
    hmass2B   = uicontrol('Style','edit','String',s2B,'BackgroundColor','white','Position',[160,375,35,15],...
        'Callback',{@m2BCurrentValue_Callback});
    hmass3B   = uicontrol('Style','edit','String',s3B,'BackgroundColor','white','Position',[160,350,35,15],...
        'Callback',{@m3BCurrentValue_Callback});
    hmass4B   = uicontrol('Style','edit','String',s4B,'BackgroundColor','white','Position',[160,325,35,15],...
        'Callback',{@m4BCurrentValue_Callback});
    hmass5B   = uicontrol('Style','edit','String',s5B,'BackgroundColor','white','Position',[160,300,35,15],...
        'Callback',{@m5BCurrentValue_Callback});
    hmass6B   = uicontrol('Style','edit','String',s6B,'BackgroundColor','white','Position',[160,275,35,15],...
        'Callback',{@m6BCurrentValue_Callback});
    align([htextB,hmass1B,hmass2B,hmass3B,hmass4B,hmass5B,hmass6B],'Center','None');
%--------------------------------------------------------------------------    
    hmass1C   = uicontrol('Style','edit','String',s1C,'backgroundColor','white','Position',[230,400,35,15],...
        'Callback',{@m1CCurrentValue_Callback});
    hmass2C   = uicontrol('Style','edit','String',s2C,'BackgroundColor','white','Position',[230,375,35,15],...
        'Callback',{@m2BCurrentValue_Callback});
    hmass3C   = uicontrol('Style','edit','String',s3C,'BackgroundColor','white','Position',[230,350,35,15],...
        'Callback',{@m3CurrentValue_Callback});
    hmass4C   = uicontrol('Style','edit','String',s4C,'BackgroundColor','white','Position',[230,325,35,15],...
        'Callback',{@m4CurrentValue_Callback});
    hmass5C   = uicontrol('Style','edit','String',s5C,'BackgroundColor','white','Position',[230,300,35,15],...
        'Callback',{@m5CCurrentValue_Callback});
    hmass6C   = uicontrol('Style','edit','String',s6C,'BackgroundColor','white','Position',[230,275,35,15],...
        'Callback',{@m6CCurrentValue_Callback});
    align([htextC,hmass1C,hmass2C,hmass3C,hmass4C,hmass5C,hmass6C],'Center','None');  
%--------------------------------------------------------------------------       
    hmassCS   = uicontrol('Style','edit','String',sCS,'BackgroundColor','white','Position',[200,250,35,15],...
        'Callback',{@mCSCurrentValue_Callback});
    hmassAS   = uicontrol('Style','edit','String',sAS,'BackgroundColor','white','Position',[200,225,35,15],...
        'Callback',{@mASCurrentValue_Callback});
    hmassFL   = uicontrol('Style','edit','String',sFL,'BackgroundColor','white','Position',[200,200,35,15],...
        'Callback',{@mFLCurrentValue_Callback});
    hmassBL   = uicontrol('Style','edit','String',sBL,'BackgroundColor','white','Position',[200,175,35,15],...
        'Callback',{@mBLCurrentValue_Callback});
    align([hmassCS,hmassAS,hmassFL,hmassBL],'Center','None');   
%--------------------------------------------------------------------------
% Create the undercarriage position button group.  
    hUC = uibuttongroup('Titleposition','centertop','Title','Undercarriage','Visible','on',...
      'Units','pixels','Position',[20,50,140,110],'SelectionChangeFcn',@UCSelectionChanged);
% Create two radio buttons in the button group. 
    hUCup  = uicontrol('Style','RadioButton','String',' Up ','Position',[40,60,70,20],'Parent',hUC,...
       'HandleVisibility','off','Tag','up');
    hUCdwn = uicontrol('Style','RadioButton','String','Down','Position',[40,20,70,20],'Parent',hUC,...
       'HandleVisibility','off','Tag','down');
%--------------------------------------------------------------------------
% Create update button
    hupdate = uicontrol('Style','pushbutton','String','update','Position',[60,20,70,25],...
        'Callback',{@updatebutton_Callback});   
    hclose  = uicontrol('Style','pushbutton','String','close','Position',[175,20,70,25],...
        'Callback',{@closebutton_Callback});   
%--------------------------------------------------------------------------
% Output boxes
    hrcg   = uicontrol('Style','text','String',sprintf('%4.1f',cgx),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[205,90,50,17]);

% Initialize the GUI.
% Change units to normalized so components resize automatically.
    set([f,hUC],'Units','normalized');
% Assign the GUI a name to appear in the window title.
    set(f,'Name','Loading')
% Move the GUI to the center of the screen.
    movegui(f,'east')
% Make the GUI visible.
    set(f,'Visible','on');
% Initialize some button group properties. 
if uc == 0
    set(hUC,'SelectedObject',hUCup);  % undercarriage up
else
    set(hUC,'SelectedObject',hUCdwn);  % undercarriage up
end

% Function calls
    
function m1ACurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 1A
NewStrVal = get(hObject, 'String'); m1A = str2double(NewStrVal);
end

function m1BCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 1B
NewStrVal = get(hObject, 'String'); m1B = str2double(NewStrVal);
end

function m1CCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 1C
NewStrVal = get(hObject, 'String'); m1C = str2double(NewStrVal);
end

function m2ACurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 2A
NewStrVal = get(hObject, 'String'); m2A = str2double(NewStrVal);
end

function m2BCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 2B
NewStrVal = get(hObject, 'String'); m2B = str2double(NewStrVal);
end

function m2CCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 2C
NewStrVal = get(hObject, 'String'); m2C = str2double(NewStrVal);
end

function m3ACurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 3A
NewStrVal = get(hObject, 'String'); m3A = str2double(NewStrVal);
end

function m3BCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 3B
NewStrVal = get(hObject, 'String'); m3B = str2double(NewStrVal);
end

function m3CCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 3C
NewStrVal = get(hObject, 'String'); m3C = str2double(NewStrVal);
end

function m4ACurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 4A
NewStrVal = get(hObject, 'String'); m4A = str2double(NewStrVal);
end

function m4BCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 1C
NewStrVal = get(hObject, 'String'); m4B = str2double(NewStrVal);
end

function m4CCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 2A
NewStrVal = get(hObject, 'String'); m4C = str2double(NewStrVal);
end

function m5ACurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 5A
NewStrVal = get(hObject, 'String'); m5A = str2double(NewStrVal);
end

function m5BCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 5B
NewStrVal = get(hObject, 'String'); m5B = str2double(NewStrVal);
end

function m5CCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 5C
NewStrVal = get(hObject, 'String'); m5C = str2double(NewStrVal);
end

function m6ACurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 6A
NewStrVal = get(hObject, 'String'); m6A = str2double(NewStrVal);
end

function m6BCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 6B
NewStrVal = get(hObject, 'String'); m6B = str2double(NewStrVal);
end

function m6CCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at seat 6C
NewStrVal = get(hObject, 'String'); m6C = str2double(NewStrVal);
end

function mCSCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at computer station
NewStrVal = get(hObject, 'String'); mCS = str2double(NewStrVal);
end

function mASCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the mass at flight attendant seat
NewStrVal = get(hObject, 'String'); mAS = str2double(NewStrVal);
end

function mFLCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the fuel mass
NewStrVal = get(hObject, 'String'); mFL = str2double(NewStrVal);
end

function mBLCurrentValue_Callback(hObject, eventdata, handles)
% Get the new value for the ballast mass
NewStrVal = get(hObject, 'String'); mBL = str2double(NewStrVal);
end

% Radio button callback
function UCSelectionChanged(hObject, eventdata,handles)
    selected = get(hUC,'SelectedObject');
    switch get(selected,'Tag')   % Get Tag of selected object
        case 'up'
            uc = 0;
        case 'down'
            uc = 1;
    end        
end

% Push button callbacks
function updatebutton_Callback(source,eventdata) 
% recalculate mass properties using seating arrangement:
%   [pilot seat,    1A, 2A, 3A, 4A, 5A, 6A, ballast;
%    copilot seat,  1B, 2B, 3B, 4B, 5B, 6B, computer station;
%    attendant seat,1C, 2C, 3C, 4C, 5C, 6C, instrumentation
pax_and_crew =[95,m1A,m2A,m3A,m4A,m5A,m6A,mBL;
               95,m1B,m2B,m3B,m4B,m5B,m6B,mCS;
              mAS,m1C,m2C,m3C,m4C,m5C,m6C,110];
[mass,cg,Ixx,Iyy,Izz,Ixy,Iyz,Ixz] = init_mass_properties(pax_and_crew,mFL,uc);
% recalculate cg position as %mac and update GUI
cgx   = 30.0 - (100*cg(1)/mac);
hrcg   = uicontrol('Style','text','String',sprintf('%4.1f',cgx),'BackgroundColor',[0.832,0.945,0.820],...
        'Position',[205,90,50,17]);
% assign values to variables in workspace     
assignin('base','MASS',mass);
assignin('base','CG',cg);
assignin('base','IXX',Ixx);
assignin('base','IYY',Iyy);
assignin('base','IZZ',Izz);
assignin('base','IXY',Ixy);
assignin('base','IYZ',Iyz);
assignin('base','IXZ',Ixz);
assignin('base','UC',uc);
assignin('base','FUEL',mFL);
assignin('base','pax_and_crew',pax_and_crew);
end

function closebutton_Callback(source,eventdata) 
close(f);

end

end     