function varargout = CAFCTC(varargin)
% CAFCTC MATLAB code for CAFCTC.fig
%      CAFCTC, by itself, creates a new CAFCTC or raises the existing
%      singleton*.
%
%      H = CAFCTC returns the handle to a new CAFCTC or the handle to
%      the existing singleton*.
%
%      CAFCTC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAFCTC.M with the given input arguments.
%
%      CAFCTC('Property','Value',...) creates a new CAFCTC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CAFCTC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CAFCTC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CAFCTC

% Last Modified by GUIDE v2.5 18-Dec-2015 14:37:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CAFCTC_OpeningFcn, ...
    'gui_OutputFcn',  @CAFCTC_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before CAFCTC is made visible.
function CAFCTC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CAFCTC (see VARARGIN)

% Choose default command line output for CAFCTC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CAFCTC wait for user response (see UIRESUME)
% uiwait(handles.CTC);


% --- Outputs from this function are returned to the command line.
function varargout = CAFCTC_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ProjIDFol = handles.ProjectIDfolder;
ProjID = handles.projID;

[FileName,PathName] = uigetfile('*.*');
fname=[PathName FileName];
RGBimage = imread(fname);
A= RGBimage;
%--------------------------exporting red plane
redPlane(:,:,1)= A(:,:,1);
redPlane(:,:,2)= 0;
redPlane(:,:,3)= 0;

%--------------------------exporting green plane
greenPlane(:,:,2)= A(:,:,2);
greenPlane(:,:,3)= 0;

%--------------------------exporting Blue plane
bluePlane(:,:,3)= A(:,:,3);


save ( [ProjIDFol '\CAFCTC.mat'] ,'RGBimage', 'redPlane', 'greenPlane', 'bluePlane','ProjID','ProjIDFol', '-v7.3');
set(handles.pushbutton2,'enable','on');
set(handles.pushbutton1,'enable','off');

imwrite(RGBimage, [ProjIDFol '\OriginalRGBimage.tif']);
warndlg('The image was loaded, please press OK to continue!');



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ProjIDFol = handles.ProjectIDfolder;

[FileName,PathName] = uigetfile('*.*');
fname=[PathName FileName];
CAFimage = imread(fname);
save ([ProjIDFol '\CAFCTC.mat'], 'CAFimage' , '-append');
imwrite(CAFimage, [ProjIDFol '\OriginalCHAPERONEWHITE.tif']);
% clear myImage;, 'greenPlane', 'bluePlane',

set(handles.pushbutton3,'enable','on');
set(handles.pushbutton2,'enable','off');
warndlg('The image was loaded, please press OK to continue!');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ProjIDFol = handles.ProjectIDfolder;

load ([ProjIDFol '\CAFCTC.mat']);
[numberofspots,center] = ctctes(redPlane,greenPlane,bluePlane,RGBimage);
save ([ProjIDFol '\CAFCTC.mat'], 'numberofspots' , '-append');
set(handles.text9,'string',numberofspots);
% c=0.6;
% axes(handles.axes7)
% axes(handles.axes7);
% % axis(handles.axes7,'off');
% rectangle('Position', [0, 0, 1, 1],'FaceColor','w','EdgeColor','k');
% % rectangle('Position', [0, 0, 0.6, 1],'FaceColor','r','EdgeColor','k');

if numberofspots ==  0
    warndlg('No Cell found!');
    
else
    
    mkdir([ProjIDFol '\RGB']);
    directorythatyouwanttosavectc = ([ProjIDFol '\RGB']);
    
    splitimage(directorythatyouwanttosavectc,150,150,center,RGBimage);
%         splitimage(directorythatyouwanttosavectc,150,150,center,bluePlane);

    mkdir([ProjIDFol '\WHITE']);
    directorythatyouwanttosavecaf = ([ProjIDFol '\WHITE']);
    splitimage(directorythatyouwanttosavecaf,150,150,center,CAFimage);
    

    mkdir([ProjIDFol '\Discounted']);
    directorythatyouwanttosaveDisc = ([ProjIDFol '\Discounted']);
% %     
    handles.addressofCTCsection = directorythatyouwanttosavectc;
    handles.addressofCAFsection = directorythatyouwanttosavecaf;
    handles.addressofDisc = directorythatyouwanttosaveDisc;
    handles.numofspots = numberofspots;
% %     
    guidata(hObject,handles);
% %     
    set(handles.pushbutton3,'enable','off');
    set(handles.pushbutton4,'enable','on');
%     set(handles.pushbutton5,'enable','on');
    set(handles.pushbutton6,'enable','on');
    warndlg('Splitting was done!');
    set(handles.text7,'String',num2str(1));
% %     
% %     %-------------------------------------------------------------------
    a = imread([directorythatyouwanttosavectc '\spot1.tif']);
    b = imread([directorythatyouwanttosavecaf '\spot1.tif']);
    

    
    axes(handles.axes2);
    imshow(a+b);
    
    axes(handles.axes3);
    bluespot(:,:,3)=a(:,:,3);
    imshow(bluespot);
    
    axes(handles.axes4)
    redspot(:,:,1)= a(:,:,1);
    redspot(:,:,2)=0;
    redspot(:,:,3)=0;
    imshow(redspot);
    
    axes(handles.axes5);
    greenspot(:,:,2)=a(:,:,2);
    greenspot(:,:,3)=0;
    imshow(greenspot);
    
    axes(handles.axes6);
    imshow(b);
end


%--------------------------------------------------
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ProjIDFol = handles.ProjectIDfolder;
numberofspots = handles.numofspots ;
addressofCTC = handles.addressofCTCsection;
addressofCAF = handles.addressofCAFsection;

mycurrentviewspot = str2double(get(handles.text7,'String'));
if mycurrentviewspot > numberofspots
    
    warndlg('Counting has finished!');
%     closereq;
%     CAF
    
else
    
voroodiCTC = [addressofCTC '\spot' num2str(mycurrentviewspot) '.tif'];
voroodiCAF = [addressofCAF '\spot' num2str(mycurrentviewspot) '.tif'];


a=imread(voroodiCTC);
aa=imread(voroodiCAF);
b(:,:,3)=a(:,:,3);
g(:,:,2)=a(:,:,2);
g(:,:,3)=0;
[xmax,ymax,nx]=size(a);
sep=eye(xmax,5);
r(:,:,1)=a(:,:,1);
r(:,:,3)=0;

ver(1:xmax,1:5,1:3)=255;
hor(1:5,1:ymax,1:3)=255;
cen(1:5,1:5,1:3)=255;

picCTC=[a ver b;hor cen hor; r ver g];
picCAF = [aa+a ver b;hor cen hor; aa  ver g];



mkdir([ProjIDFol '\selectedCTC\ ']);
% mkdir([addressofCAF '\selectedCAF\ ']);

khorojiCTC = [ProjIDFol '\selectedCTC\' 'spot' num2str(mycurrentviewspot) '.tif'];
% khorojiCAF = [addressofCAF '\selectedCAF\' 'spot' (mycurrentviewspot) '.tif'];
imwrite(picCTC,khorojiCTC )
% imwrite(picCAF,khorojiCAF )
mycurrentviewspot = mycurrentviewspot +1;
set(handles.text7,'String',num2str(mycurrentviewspot));
clear a aa

a = imread([addressofCTC '\spot' num2str(mycurrentviewspot) '.tif']);
aa = imread([addressofCAF '\spot' num2str(mycurrentviewspot) '.tif']);
progress=mycurrentviewspot/numberofspots;
progressperc = round(progress*10000)/100;
set(handles.text10,'String',[num2str(progressperc) '%']);
axes(handles.axes7);

rectangle('Position', [0, 0, 1, 1],'FaceColor','w','EdgeColor','k');
rectangle('Position', [0, 0, progress, 1],'FaceColor','r','EdgeColor','k');



axes(handles.axes2);
imshow(a+b);

axes(handles.axes3);
bluespot(:,:,3)=a(:,:,3);
imshow(bluespot);

axes(handles.axes4)
redspot(:,:,1)= a(:,:,1);
redspot(:,:,2)=0;
redspot(:,:,3)=0;
imshow(redspot);

axes(handles.axes5);
greenspot(:,:,2)=a(:,:,2);
greenspot(:,:,3)=0;
imshow(greenspot);

axes(handles.axes6);
imshow(aa);


end





% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addressofCTC = handles.addressofCTCsection;
addressofCAF = handles.addressofCAFsection;
ProjIDFol = handles.ProjectIDfolder;
numberofspots = handles.numofspots ;

mycurrentviewspot = str2double(get(handles.text7,'String'));
if mycurrentviewspot > numberofspots
    
    warndlg('Counting has finished!');
    closereq;
    CAF
    
else
    voroodiCTC = [addressofCTC '\spot' num2str(mycurrentviewspot) '.tif'];
    voroodiCAF = [addressofCAF '\spot' num2str(mycurrentviewspot) '.tif'];
    
    a=imread(voroodiCTC);
    aa=imread(voroodiCAF);
    b(:,:,3)=a(:,:,3);
    g(:,:,2)=a(:,:,2);
    g(:,:,3)=0;
    [xmax,ymax,nx]=size(a);
    sep=eye(xmax,5);
    r(:,:,1)=a(:,:,1);
    r(:,:,3)=0;
    ver(1:xmax,1:5,1:3)=255;
    hor(1:5,1:ymax,1:3)=255;
    cen(1:5,1:5,1:3)=255;
    picCAF = [aa+a ver b;hor cen hor; aa  ver g];
    mkdir([ProjIDFol '\selectedChaperone\ ']);
    khorojiCAF = [ProjIDFol '\selectedChaperone\' 'spot' num2str(mycurrentviewspot) '.tif'];
    imwrite(picCAF,khorojiCAF )
    mycurrentviewspot = (mycurrentviewspot) +1;
    set(handles.text7,'String', num2str(mycurrentviewspot));
    clear a aa
    
    a = imread([addressofCTC '\spot' num2str(mycurrentviewspot) '.tif']);
    aa = imread([addressofCAF '\spot' num2str(mycurrentviewspot) '.tif']);
    
    axes(handles.axes2);
    imshow(a+b);
    
    axes(handles.axes3);
    bluespot(:,:,3)=a(:,:,3);
    imshow(bluespot);
    
    axes(handles.axes4)
    redspot(:,:,1)= a(:,:,1);
    redspot(:,:,2)=0;
    redspot(:,:,3)=0;
    imshow(redspot);
    
    axes(handles.axes5);
    greenspot(:,:,2)=a(:,:,2);
    greenspot(:,:,3)=0;
    imshow(greenspot);
    
    axes(handles.axes6);
    imshow(aa);
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addressofCTC = handles.addressofCTCsection;
addressofCAF = handles.addressofCAFsection;
addressofDiscounted = handles.addressofDisc;
numberofspots = handles.numofspots ;
ProjIDFol = handles.ProjectIDfolder;

mycurrentviewspot = str2double(get(handles.text7,'String'));
if mycurrentviewspot > numberofspots
    
    warndlg('Counting has finished!');
%     closereq;
%     CAF
    
else
    voroodiCTC = [addressofCTC '\spot' num2str(mycurrentviewspot) '.tif'];
    voroodiCAF = [addressofCAF '\spot' num2str(mycurrentviewspot) '.tif'];
    
    a=imread(voroodiCTC);
    aa=imread(voroodiCAF);
    b(:,:,3)=a(:,:,3);
    g(:,:,2)=a(:,:,2);
    g(:,:,3)=0;
    [xmax,ymax,nx]=size(a);
    sep=eye(xmax,5);
    r(:,:,1)=a(:,:,1);
    r(:,:,3)=0;
    ver(1:xmax,1:5,1:3)=255;
    
    % hor(1:5,1:ymax,1:3)=255;
    % cen(1:5,1:5,1:3)=255;
    picCAF = [aa+a ver b ver g ver r ver aa];
    % mkdir([addressofCAF '\notSelected\ ']);
    % khorojiCAF = [addressofCAF '\notSelected\' 'spot' num2str(mycurrentviewspot) '.tif'];
    khorojiDiscounted = [addressofDiscounted '\spot' num2str(mycurrentviewspot) '.tif'];
    imwrite(picCAF,khorojiDiscounted )
    % imwrite(picCAF,khorojiCAF )
    
    mycurrentviewspot = mycurrentviewspot +1;
    set(handles.text7,'String',num2str(mycurrentviewspot));
    
    
    a = imread([addressofCTC '\spot' num2str(mycurrentviewspot) '.tif']);
    aa = imread([addressofCAF '\spot' num2str(mycurrentviewspot) '.tif']);
    progress=mycurrentviewspot/numberofspots;
progressperc = round(progress*10000)/100;
set(handles.text10,'String',[num2str(progressperc) '%']);
axes(handles.axes7);

rectangle('Position', [0, 0, 1, 1],'FaceColor','w','EdgeColor','k');
rectangle('Position', [0, 0, progress, 1],'FaceColor','r','EdgeColor','k');


    axes(handles.axes2);
    imshow(a+aa);
    
    axes(handles.axes3);
    bluespot(:,:,3)=a(:,:,3);
    imshow(bluespot);
    
    axes(handles.axes4)
    redspot(:,:,1)= a(:,:,1);
    redspot(:,:,2)=0;
    redspot(:,:,3)=0;
    imshow(redspot);
    
    axes(handles.axes5);
    greenspot(:,:,2)=a(:,:,2);
    greenspot(:,:,3)=0;
    imshow(greenspot);
    
    axes(handles.axes6);
    imshow(aa);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
val = get(handles.popupmenu1,'Value');

if val == 1
    zoomvalu = 149;
elseif val == 2
    zoomvalu = 100;
elseif val == 3
    zoomvalu = 75;
elseif val == 4
    zoomvalu = 50;
end

%---------------------------------------------Zoomin part
%   read the address of the files to display
addressofCTC = handles.addressofCTCsection;
addressofCAF = handles.addressofCAFsection;
%read th enumber of image which  is on the display
mycurrentviewspot = str2double(get(handles.text7,'String'));

%read the image which  is on the display
a = imread([addressofCTC '\spot' num2str(mycurrentviewspot) '.tif']);
aa = imread([addressofCAF '\spot' num2str(mycurrentviewspot) '.tif']);

[xctc,yctc,nmn]=size(a);

xCTC=(xctc-1)/2;
yCTC=(yctc-1)/2;
%-------------------------------------------------Ploting the Original
%spots
axes(handles.axes2);
imshow(a(yCTC-zoomvalu:yCTC+zoomvalu,xCTC-zoomvalu:xCTC+zoomvalu,:)+aa(yCTC-zoomvalu:yCTC+zoomvalu,xCTC-zoomvalu:xCTC+zoomvalu,:));
%--------------------------------------------------------------------------------
axes(handles.axes3);
bluespot(:,:,3)=a(:,:,3);
imshow(bluespot(yCTC-zoomvalu:yCTC+zoomvalu,xCTC-zoomvalu:xCTC+zoomvalu,:));
%-------------------------------------------------Ploting the Red Plane
axes(handles.axes4);
redspot(:,:,1)= a(yCTC-zoomvalu:yCTC+zoomvalu,xCTC-zoomvalu:xCTC+zoomvalu,1);
redspot(:,:,2)=0;
redspot(:,:,3)=0;
imshow(redspot);

%--------------------------------------------------------------------------------
%-------------------------------------------------Ploting the Green PLane
axes(handles.axes5);
greenspot(:,:,2)=a(yCTC-zoomvalu:yCTC+zoomvalu,xCTC-zoomvalu:xCTC+zoomvalu,2);
greenspot(:,:,3)=0;
imshow(greenspot);
%--------------------------------------------------------------------------
%-------------------------------------------------Ploting the WHite plane
axes(handles.axes6);
WHite(:,:,:)=aa(yCTC-zoomvalu:yCTC+zoomvalu,xCTC-zoomvalu:xCTC+zoomvalu,:);
imshow(WHite);
%-------------------------------------------------------------




% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


projID = get(handles.edit1,'String');
if isempty(projID)
     
    warndlg('Please Enter A Valid Project ID!');
    
else
    
    mkdir(projID);
    currentFolder = pwd;
    ProjectIDforlder = ([currentFolder '\' projID]);
    handles.ProjectIDfolder = ProjectIDforlder;
    handles.projID = projID;
    set(handles.edit1,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
    set(handles.pushbutton1,'Enable','on');
    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function CTC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
