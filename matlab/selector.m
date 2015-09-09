function varargout = selector(varargin)

global files
global acfiles
global refiles
global curim

%--------------------------------------------------------------------------
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selector_OpeningFcn, ...
                   'gui_OutputFcn',  @selector_OutputFcn, ...
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


%--------------------------------------------------------------------------
function selector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selector (see VARARGIN)

% Choose default command line output for selector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using selector.
if strcmp(get(hObject,'Visible'),'off')
    %plot(rand(5));
    a = rand(256,256,3);
    imagesc(a);
    axis off;
end

% UIWAIT makes selector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = selector_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





%--------------------------------------------------------------------------
function pushbutton4_Callback(hObject, eventdata, handles)

  global curim
  global files
  global acfiles
  global refiles
  disp('Accept');
  movefile(files{curim},acfiles{curim})
  curim = curim + 1
  im = imread(files{curim});
  imagesc(im);
  axis off;

%--------------------------------------------------------------------------
function pushbutton5_Callback(hObject, eventdata, handles)

  global curim
  global files
  global acfiles
  global refiles
  disp('Reject');
  movefile(files{curim},refiles{curim})
  curim = curim + 1
  im = imread(files{curim});
  imagesc(im);
  axis off;


%--------------------------------------------------------------------------
function pushbutton6_Callback(hObject, eventdata, handles)

  global files
  global acfiles
  global refiles
  global curim
  
  
  files = [];
  acfiles = [];
  refiles = [];
  
  %Get a list of all the images in a category
  count = 0;
  rootdir = cd;
  cd('~/Desktop/Brandsafety/roulette/');
  system('mkdir -p accepted');
  system('mkdir -p rejected');
  path = cd;
  fdir = dir;
  for i=3:size(fdir,1)
    ext = fdir(i).name(end-2:end);
    if (strcmp(ext,'png') | strcmp(ext,'jpg'))
      count = count + 1;
      files{count} = [path '/' fdir(i).name];
      acfiles{count} = [path '/accepted/' fdir(i).name];
      refiles{count} = [path '/rejected/' fdir(i).name];
    end
  end
  cd(rootdir);

  %Load First Image
  curim = 1
  im = imread(files{1});
  imagesc(im);
  axis off;
