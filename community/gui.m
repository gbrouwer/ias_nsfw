function  gui(varargin)
%GUI Community Detection Toolbox Front-End

%%% LOAD DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Data.Graphs         = load_data('Graphs');
Data.Algorithms     = load_data('Algorithms');
Data.Cluster_Number = load_data('Cluster_Number');
Data.Evaluation     = load_data('Evaluation');


%%% CONSTANTS & VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%constants
Pos            = struct;
Pos.Gui        = [51     51     1210    710     ]; %pixels (the rest are normalized)

Color.tab      = [ 0.85   0.85     0.85];
Color.Gui      = [ 0.8    0.8      0.8 ];
Color.msg      = [ 1      1        1   ]; %white

msgFontSize    = 11; %font size for GUI messages

%Panel 1 contains 4 sub-panels 
%   Graph, Algorithm, Cluster_Number,Evaluation, 
%   each one for the respective group of functions
Pos.Panel1     = [ 0      0.2      0.65   0.8   ];
Pos.Panel1a    = [ 0      0.5      0.5    0.5   ]; %sub-panel a  
Pos.add_grf    = [ 0      0.9056   0.2    0.0944]; %add function pushbutton
Pos.rm_grf     = [ 0.2    0.9056   0.2    0.0944]; %remove function pushbutton
Pos.slc_grf    = [ 0      0        1      0.9056]; %selected graph

Pos.Panel1b    = [ 0.5    0.5      0.5    0.5   ]; %sub-panel b  
Pos.add_alg    = [ 0      0.9056   0.2    0.0944]; %add function pushbutton
Pos.edit_alg   = [ 0.2    0.9056   0.2    0.0944]; %edit function pushbutton
Pos.rm_alg     = [ 0.4    0.9056   0.2    0.0944]; %remove function pushbutton
Pos.slc_alg    = [ 0      0.08     1      0.8256]; %selected algorithm

Pos.Panel1c    = [ 0      0        0.5    0.5   ]; %sub-panel c  
Pos.add_cln    = [ 0      0.9056   0.2    0.0944]; %add function pushbutton
Pos.rm_cln     = [ 0.2    0.9056   0.2    0.0944]; %remove function pushbutton
Pos.slc_cln    = [ 0      0        1      0.9056]; %selected cluster_number

Pos.Panel1d    = [ 0.5    0        0.5    0.5   ]; %sub-panel d  
Pos.add_eva    = [ 0      0.9056   0.2    0.0944]; %add function pushbutton
Pos.rm_eva     = [ 0.2    0.9056   0.2    0.0944]; %remove function pushbutton
Pos.slc_eva    = [ 0      0        1      0.9056]; %selected evaluation


%Panel 2 contains a preview of the figure produced
Pos.Panel2     = [ 0.65   0.2      0.35   0.8   ];
Pos.Preview    = [ 0.12   0.075    0.85   0.85  ];


%Panel 3 contains control buttons and space for the GUI messages
Pos.Panel3     = [ 0      0        1      0.2   ];
Pos.msg        = [ 0      0        0.98   0.75  ];
Pos.slider     = [ 0.98   0        0.02   0.75  ];
Pos.options    = [ 0.01   0.775    0.1    0.2   ];
Pos.variables  = [ 0.11   0.775    0.1    0.2   ];
Pos.reseed     = [ 0.79   0.775    0.1    0.2   ];
Pos.run_exp    = [ 0.89   0.775    0.1    0.2   ];

%%variables
Param.Grf = struct; %the graph          function  chosen, and any parameters
Param.Alg = struct; %the algorithm      functions chosen, and any parameters
Param.Cln = struct; %the cluster_number function  chosen, and any parameters
Param.Eva = struct; %the evaluation     functions chosen, and any parameters
Param.Opt = struct; %the specified options for the experiment
Param.Var = {};     %any extra user-defined variables

Id.grf = []; %id of the selected graph
Id.alg = []; %id of the selected algorithms
Id.cln = []; %id of the selected cluster_number
Id.eva = []; %id of the selected evaluation

Results = []; %experiment results will be stored here

G = []; %temporary variable to plot the graph
seed = uint64(rand()*1000);

%%% THE GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Main Window
Fig.main       = figure     ('MenuBar'       ,'none',...
                             'Name'          ,'Community Detection Toolbox',...
                             'NumberTitle'   ,'off',...
                             'Position'      ,Pos.Gui,...
                             'Resize'        ,'on',...
                             'Toolbar'       ,'none',...
                             'Units'         ,'pixels',...
                             'Color'         ,Color.Gui,...
                             'CloseRequestFcn',@quit,...
                             'Visible'       ,'off');
                         
%%Menu                    
menu1          = uimenu('Label','File',...
                        'Accelerator','l');
                    
                 uimenu(menu1,'Label'      ,'New',...
                              'Accelerator','n',...
                              'Callback'   ,@new_callback);
                 
                 uimenu(menu1,'Label'      ,'Import Data',...
                              'Separator'  ,'on',...
                              'Accelerator','i',...
                              'Callback'   ,@import_callback);
                          
                 uimenu(menu1,'Label'      ,'Export Data',...
                              'Accelerator','x',...
                              'Callback'   ,@export_callback);
                 
                 uimenu(menu1,'Label'      ,'Export Script',...
                              'Separator'  ,'on',...
                              'Accelerator','s',...
                              'Callback'   ,@export_script_callback);
                          
                 uimenu(menu1,'Label'      ,'Export Figure',...
                              'Accelerator','f',...
                              'Callback'   ,@export_figure_callback);         
                          
                 uimenu(menu1,'Label','Quit',...
                              'Separator'  ,'on',...
                              'Accelerator','q',...
                              'Callback'   ,{@quit,Fig.main});

menu2          = uimenu('Label','Plot');
                uimenu(menu2,'Label','Adjacency Matrices',...
                               'Callback',@plot_adjacency_callback);
                uimenu(menu2,'Label','Graphs',...
                               'Callback',@plot_graph_callback);
                uimenu(menu2,'Label','All Partitions',...
                               'Callback',@plot_all_partitions_callback);
                uimenu(menu2,'Label','Best Partition',...
                               'Callback',@plot_best_partition_callback);
                uimenu(menu2,'Label','Results to Command Line',...
                               'Callback',@results_to_cli_callback);
                  
menu3          = uimenu('Label','Help');
                 uimenu(menu3,'Label','Quick Start',...
                              'Callback',@quick_start_callback);
                 uimenu(menu3,'Label','User Manual',...
                              'Callback',@user_manual_callback);


%%Panel 1 - Functions
Panel.main1    = uipanel  ('Parent'          ,Fig.main,...
                           'Title'           ,'Functions',....
                           'FontSize'        ,12,...
                           'Units'           ,'normalized',...
                           'BackgroundColor' ,Color.Gui,...
                           'Position'        ,Pos.Panel1);

%sub-panel a - Graphs                       
Panel.main1a   = uipanel  ('Parent'          ,Panel.main1,...
                           'FontSize'        ,10,...
                           'Title'           ,'Graphs',...
                           'Units'           ,'normalized',...
                           'BackgroundColor' ,Color.Gui,...
                           'Position'        ,Pos.Panel1a); %sub-panel a
                       
Button.add_grf = uicontrol('Parent'          ,Panel.main1a,...
                           'Style'           ,'pushbutton',...
                           'String'          ,'Add',...
                           'Units'           ,'normalized',...
                           'Position'        ,Pos.add_grf,...
                           'Callback'        ,{@add_function,Data.Graphs,'Grf'});

Button.rm_grf  = uicontrol('Parent'          ,Panel.main1a,...
                           'Style'           ,'pushbutton',...
                           'String'          ,'Remove',...
                           'Units'           ,'normalized',...
                           'Enable'          ,'off',...
                           'Position'        ,Pos.rm_grf,...
                           'Callback'        ,{@rm_function,'Grf'});
                       
                       
Txt.slc_grf    = uicontrol('Parent'          ,Panel.main1a,...
                           'Style'           ,'text',...
                           'String'          ,'',...
                           'Units'           ,'normalized',...
                           'FontSize'        ,msgFontSize,...
                           'BackgroundColor' ,Color.Gui,...
                           'HorizontalAlignment','left',...
                           'Position'        ,Pos.slc_grf);                       


%sub-panel b - Algorithms                        
Panel.main1b   = uipanel  ('Parent'           ,Panel.main1,...
                           'FontSize'         ,10,...
                           'Title'            ,'Algorithms',...
                           'Units'            ,'normalized',...
                           'BackgroundColor'  ,Color.Gui,...
                           'Position'         ,Pos.Panel1b); %sub-panel b 

Button.add_alg = uicontrol('Parent'           ,Panel.main1b,...
                           'Style'            ,'pushbutton',...
                           'String'           ,'Add',...
                           'Units'            ,'normalized',...
                           'Position'         ,Pos.add_alg,...
                           'Callback'         ,{@add_function,Data.Algorithms,'Alg'});
                       
Button.edit_alg= uicontrol('Parent'           ,Panel.main1b,...
                           'Style'            ,'pushbutton',...
                           'String'           ,'Edit',...
                           'Units'            ,'normalized',...
                           'Enable'           ,'off',...
                           'Position'         ,Pos.edit_alg,...
                           'Callback'         ,{@add_function,Data.Algorithms,'Alg',1});
                       
Button.rm_alg  = uicontrol('Parent'          ,Panel.main1b,...
                           'Style'           ,'pushbutton',...
                           'String'          ,'Remove',...
                           'Units'           ,'normalized',...
                           'Enable'          ,'off',...
                           'Position'        ,Pos.rm_alg,...
                           'Callback'        ,{@rm_alg_function});
                       
Txt.slc_alg    = [];                       

Button.alg_tab = [];


%sub-panel c - Cluster Number Selection
Panel.main1c   = uipanel  ('Parent'           ,Panel.main1,...
                           'FontSize'         ,10,...
                           'Title'            ,'Cluster Number Selection',...
                           'Units'            ,'normalized',...
                           'BackgroundColor'  ,Color.Gui,...
                           'Position'         ,Pos.Panel1c); %sub-panel c

Button.add_cln = uicontrol('Parent'           ,Panel.main1c,...
                           'Style'            ,'pushbutton',...
                           'String'           ,'Add',...
                           'Units'            ,'normalized',...
                           'Position'         ,Pos.add_cln,...
                           'Callback'         ,{@add_function,Data.Cluster_Number,'Cln'});
                       
Button.rm_cln  = uicontrol('Parent'          ,Panel.main1c,...
                           'Style'           ,'pushbutton',...
                           'String'          ,'Remove',...
                           'Units'           ,'normalized',...
                           'Enable'          ,'off',...
                           'Position'        ,Pos.rm_cln,...
                           'Callback'        ,{@rm_function,'Cln'});                       
                       
Txt.slc_cln    = uicontrol('Parent'            ,Panel.main1c,...
                           'Style'             ,'text',...
                           'String'            ,'',...
                           'Units'             ,'normalized',...
                           'FontSize'          ,msgFontSize,...
                           'BackgroundColor'   ,Color.Gui,...
                           'HorizontalAlignment','left',...
                           'Position'          ,Pos.slc_cln);                       

%sub-panel d - Evaluation
Panel.main1d   = uipanel  ('Parent'            ,Panel.main1,...
                           'FontSize'          ,10,...
                           'Title'             ,'Evaluation',...
                           'Units'             ,'normalized',...
                           'BackgroundColor'   ,Color.Gui,...
                           'Position'          ,Pos.Panel1d); %sub-panel d
                     
Button.add_eva = uicontrol('Parent'            ,Panel.main1d,...
                           'Style'             ,'pushbutton',...
                           'String'            ,'Add',...
                           'Units'             ,'normalized',...
                           'Position'          ,Pos.add_eva,...
                           'Callback'          ,{@add_function,Data.Evaluation,'Eva'});
                       
Button.rm_eva  = uicontrol('Parent'          ,Panel.main1d,...
                           'Style'           ,'pushbutton',...
                           'String'          ,'Remove',...
                           'Units'           ,'normalized',...
                           'Enable'          ,'off',...
                           'Position'        ,Pos.rm_eva,...
                           'Callback'        ,{@rm_function,'Eva'});                       

Txt.slc_eva    = uicontrol('Parent'            ,Panel.main1d,...
                           'Style'             ,'text',...
                           'String'            ,'',...
                           'Units'             ,'normalized',...
                           'FontSize'          ,msgFontSize,...
                           'BackgroundColor'   ,Color.Gui,...
                           'HorizontalAlignment','left',...
                           'Position'          ,Pos.slc_eva);

                       
%%Panel 2 - Preview
Panel.main2    = uipanel ('Parent'             ,Fig.main,...
                          'Title'              ,'Preview',....
                          'FontSize'           ,12,...
                          'Units'              ,'normalized',...
                          'BackgroundColor'    ,Color.Gui,...
                          'Position'           ,Pos.Panel2);

Ax.Preview     = axes    ('Parent'             ,Panel.main2,...
                          'Units'              ,'normalized',...
                          'XLim'               ,[0 1],...
                          'YLim'               ,[-0.05 1.05],...
                          'Position'           ,Pos.Preview); 
                      
%%Panel 3 - Messages, Options, Run
Panel.main3    = uipanel ('Parent'             ,Fig.main,...
                          'BorderType'         ,'none',...
                          'FontSize'           ,12,...
                          'Units'              ,'normalized',...
                          'BackgroundColor'    ,Color.Gui,...
                          'Position'           ,Pos.Panel3);
                     
Txt.msg       = uicontrol('Parent'             ,Panel.main3,...
                          'Style'              ,'text',...
                          'String'             ,'Ready...',...
                          'BackgroundColor'    ,Color.msg,...
                          'FontSize'           ,msgFontSize,...
                          'Units'              ,'normalized',...
                          'HorizontalAlignment','left',...
                          'Position'           ,Pos.msg);
              
Txt.slider    = uicontrol('Parent'             ,Panel.main3,...
                          'Style'              ,'slider',...
                          'Units'              ,'normalized',...
                          'Enable'             ,'off',...
                          'Position'           ,Pos.slider,...
                          'Callback'           ,{@slider_callback,Txt.msg});

Button.options= uicontrol('Parent'             ,Panel.main3,...
                          'Style'              ,'pushbutton',....
                          'String'             ,'Options',...
                          'Units'              ,'normalized',...
                          'Position'           ,Pos.options,...
                          'Callback'           ,@options_callback);

Button.variables= uicontrol('Parent'           ,Panel.main3,...
                          'Style'              ,'pushbutton',....
                          'String'             ,'Variables',...
                          'Units'              ,'normalized',...
                          'Position'           ,Pos.variables,...
                          'Callback'           ,@variables_callback);                      

                      
Button.reseed =uicontrol('Parent'             ,Panel.main3,...
                          'Style'              ,'pushbutton',....
                          'String'             ,'Re-Seed',...
                          'Enable'             ,'on',...
                          'Units'              ,'normalized',...
                          'Position'           ,Pos.reseed,...
                          'Callback'           ,@reseed_callback);                      

Button.run_exp= uicontrol('Parent'              ,Panel.main3,...
                         'Style'               ,'pushbutton',....
                         'String'              ,'Run',...
                         'Units'               ,'normalized',...
                         'Position'            ,Pos.run_exp,...
                         'Callback'            ,@run_callback);
                     

                     
%%Callbacks
    function new_callback(~,~)
        %NEW_CALLBACK will clear the current options from the gui and start
        %a new session
        
        %reset gui options
        rm_function([],[],'Grf');
        rm_function([],[],'Cln');
        rm_function([],[],'Eva');
        
        algs_todel = length(Button.alg_tab);
        for i = 1:algs_todel
            rm_alg_function([],[]);
        end
        
        %clear gui preview screen
        Panel.main2    = uipanel ('Parent'     ,Fig.main,...
                          'Title'              ,'Preview',....
                          'FontSize'           ,12,...
                          'Units'              ,'normalized',...
                          'BackgroundColor'    ,Color.Gui,...
                          'Position'           ,Pos.Panel2);
                      
        Ax.Preview     = axes    ('Parent'             ,Panel.main2,...
                          'Units'              ,'normalized',...
                          'XLim'               ,[0 1],...
                          'YLim'               ,[-0.05 1.05],...
                          'Position'           ,Pos.Preview); 
        
                      
        %clear messages and button options
        Panel.main3    = uipanel ('Parent'             ,Fig.main,...
                                  'BorderType'         ,'none',...
                                  'FontSize'           ,12,...
                                  'Units'              ,'normalized',...
                                  'BackgroundColor'    ,Color.Gui,...
                                  'Position'           ,Pos.Panel3);

        Txt.msg       = uicontrol('Parent'             ,Panel.main3,...
                                  'Style'              ,'text',...
                                  'String'             ,'Ready...',...
                                  'BackgroundColor'    ,Color.msg,...
                                  'FontSize'           ,msgFontSize,...
                                  'Units'              ,'normalized',...
                                  'HorizontalAlignment','left',...
                                  'Position'           ,Pos.msg);

        Txt.slider    = uicontrol('Parent'             ,Panel.main3,...
                                  'Style'              ,'slider',...
                                  'Units'              ,'normalized',...
                                  'Enable'             ,'off',...
                                  'Position'           ,Pos.slider,...
                                  'Callback'           ,{@slider_callback,Txt.msg});

        Button.options= uicontrol('Parent'             ,Panel.main3,...
                                  'Style'              ,'pushbutton',....
                                  'String'             ,'Options',...
                                  'Units'              ,'normalized',...
                                  'Position'           ,Pos.options,...
                                  'Callback'           ,@options_callback);

        Button.variables= uicontrol('Parent'             ,Panel.main3,...
                                  'Style'              ,'pushbutton',....
                                  'String'             ,'Variables',...
                                  'Units'              ,'normalized',...
                                  'Position'           ,Pos.variables,...
                                  'Callback'           ,@variables_callback);                      

        Button.reseed =uicontrol('Parent'             ,Panel.main3,...
                                  'Style'              ,'pushbutton',....
                                  'String'             ,'Re-Seed',...
                                  'Enable'             ,'on',...
                                  'Units'              ,'normalized',...
                                  'Position'           ,Pos.reseed,...
                                  'Callback'           ,@reseed_callback);                      

        Button.run_exp= uicontrol('Parent'              ,Panel.main3,...
                                 'Style'               ,'pushbutton',....
                                 'String'              ,'Run',...
                                 'Units'               ,'normalized',...
                                 'Position'            ,Pos.run_exp,...
                                 'Callback'            ,@run_callback);
                     
        %clear current session data
        set(Fig.main,'HandleVisibility','off');
        clear Results; close all;
        
        %clear all variables
        Param.Grf = struct; %the graph          function  chosen, and any parameters
        Param.Alg = struct; %the algorithm      functions chosen, and any parameters
        Param.Cln = struct; %the cluster_number function  chosen, and any parameters
        Param.Eva = struct; %the evaluation     functions chosen, and any parameters
        Param.Opt = struct; %the specified options for the experiment
        Param.Var = {};     %any extra user-defined variables

        Id.grf = []; %id of the selected graph
        Id.alg = []; %id of the selected algorithms
        Id.cln = []; %id of the selected cluster_number
        Id.eva = []; %id of the selected evaluation

        Results = []; %experiment results will be stored here

        G = []; %temporary variable to plot the graph
        seed = uint64(rand()*1000);
        
        %reset Param options
        default_callback([],[]);

        %reset Gui visibility
        set(Fig.main,'HandleVisibility','on');
        
    end

    function quit(~,~,this)
        %QUIT will close the figure that called it. If the figure
        %is the main GUI it will close all other figures too. The function
        %works as following: all the GUI figures are assumed to be inside
        %the Fig struct. Thus, from the handle that called the function
        %we iteratively look for the parent figure it belongs and delete
        %it. If the parent figure is the Fig.main then delete all other
        %figures.        
        
        if nargin < 3
            this = Fig.main;
        end
        
        %function to delete the open figures - necessary for the try block
        function del(x)
                try
                    delete(x);
                end
        end
        
        if this == Fig.main
            %delete all figures
            structfun(@del,Fig);
        else
            %delete only the current figure
            delete(this);
            
            %remove it from the Fig struct
            f     = fieldnames(Fig);
            field = f(logical(cellfun(@(x) (Fig.(x)==this),f)));
            Fig   = rmfield(Fig,field);
        end
    end
            
    function reseed_callback(~,~)
        
        seed = uint64(rand()*1000);
        Param.Opt.seed = num2str(seed);
        
        print_msg(['New seed: ' num2str(seed)],Txt.msg,Txt.slider,0);
    end

    function change_alg_tab(source,~)
        %CHANGE_ALG_TAB is used to change between the tabs from the selected
        %algorithms
        
        %get the tab id
        n = str2double(get(source,'Tag'));

        %show only the selected algorithm
        for i = 1:length(Txt.slc_alg)
            set(Txt.slc_alg(i),'Visible','off');
        end
        set(Txt.slc_alg(n),'Visible','on');

        %activate all but the selected tab
        for i = 1:length(Button.alg_tab)
            set(Button.alg_tab(i),'Enable','on');
        end
        set(source,'Enable','off');
    end

    function rm_function(~,~,var)
    %RM_FUNCTION will remove the selected function (Graph,CN,Evaluation)
    %from the experiment
    
        %clear variable contents
        eval(['Param.' var '= struct;']);

        %GUI changes
        switch var
            case 'Grf'
                %clear GUI selection text
                set(Txt.slc_grf,'String','');

                %change from edit to add the graph button
                set(Button.add_grf,'String','Add');

                %disable the remove graph button
                set(Button.rm_grf,'Enable','off');

            case 'Alg'
                rm_alg_function([],[]);
                
            case 'Cln'
                %clear GUI selection text
                set(Txt.slc_cln,'String','');

                %change from edit to add the cln button
                set(Button.add_cln,'String','Add');

                %disable the remove cln button
                set(Button.rm_cln,'Enable','off');

            case 'Eva'
                %clear GUI selection text
                set(Txt.slc_eva,'String','');

                %change from edit to add the evalution button
                set(Button.add_eva,'String','Add');

                %disable the remove evaluation button
                set(Button.rm_eva,'Enable','off');
        end
    end

    function rm_alg_function(~,~)
    %RM_ALG_FUNCTION will remove the selected function (Algorithm) from the
    %experiment
    
        %get the panel-id of the algorithm that should be deleted
        n = 1;
        for i = 1:length(Button.alg_tab)
            status = get(Button.alg_tab(i),'Enable');
            if strcmp(status,'off')
                n = i;
                break;
            end
        end

        %remove the algorithm
        if length(Param.Alg.name) > 1
            Param.Alg.name = {Param.Alg.name{1:(n-1)} Param.Alg.name{(n+1):end}};
            Param.Alg.par  = {Param.Alg.par{1:(n-1)} Param.Alg.par{(n+1):end}};
        else
            Param.Alg = struct;
        end

        %correct the tab labeling and move tabs
        for i = (n+1):length(Button.alg_tab)
            set(Button.alg_tab(i),'Tag',num2str(i-1));

            s = ['Alg' num2str(i-1)];
            set(Button.alg_tab(i),'String',s);

            set(Button.alg_tab(i),'Position',[0.1*(mod((i-1)-1,10)) 0.08*floor(((i-1)-1)/10) 0.1 0.08]);
        end

        %clear the text
        set(Txt.slc_alg(n),'Visible','off');
        if length(Txt.slc_alg) > 1
            Txt.slc_alg = [Txt.slc_alg(1:n-1) Txt.slc_alg(n+1:end)];
        else
            Txt.slc_alg = [];
        end

        %clear the tab
        set(Button.alg_tab(n),'Visible','off');
        if length(Button.alg_tab) > 1
            Button.alg_tab = [Button.alg_tab(1:n-1) Button.alg_tab(n+1:end)];
        else
            Button.alg_tab = [];
        end

        %switch to a valid tab
        if n ~= 1
            change_alg_tab(Button.alg_tab(n-1),[]);
        else
            if ~isempty(Txt.slc_alg)
                change_alg_tab(Button.alg_tab(1),[]);
            end
        end

        %disable edit and remove buttons if needed
        if isempty(fields(Param.Alg))
            set(Button.edit_alg,'Enable','off');
            set(Button.rm_alg,'Enable','off');
        end
    end

    function add_function(~,~,fun,var,edit_alg_mode)
        %ADD_FUNCTION opens a new window which enables the user to choose
        %a specific function and initialize its parameters
        %fun, var are parameters passed by the main GUI
        %fun = what type of functions should we look for
        %var = the name of the variable for output (add_function is a callback)

        %l declares local variable

        %%constants
        lPos.Gui      = [0    0    1124   533   ]; %pixels (the rest are normalized)

        lPos.Panel1   = [0    0.15   0.35   0.85]; %panel 1
        lPos.fun_text = [0.2  0.85   0.5    0.05];
        lPos.pp       = [0.2  0.45   0.5    0.4 ];

        lPos.Panel2   = [0.35 0.15   0.63   0.85]; %panel 2
        lPos.msg      = [0    0      0.95   1   ];
        lPos.slider   = [0.95 0      0.05   1   ];

        lPos.Panel3   = [0    0      1      0.15]; %panel 3
        lPos.can      = [0.72 0.2    0.13   0.38];
        lPos.ok       = [0.85 0.2    0.13   0.38]; 

        lColor.Gui    = Color.Gui; %warning: Gui_Color is a global variable
        lColor.msg    = Color.msg; %warning: msg_Color is a global variable

        if ~exist('edit_alg_mode','var')
            edit_alg_mode = 0;
        end

        %the listbox title
        switch var
            case 'Grf'
                ltext = 'Graph Function';
            case 'Alg'
                ltext = 'Algorithm Function';
            case 'Cln'
                ltext = 'Cluster Number Function';
            case 'Eva'
                ltext = 'Evaluation Function';
            otherwise
                ltext = 'Function';
        end

        %a list of the available functions
        llist = '';
        for i = 1:length(fun)
            llist = [llist '|' fun{i}{1}];
        end
        if ~isempty(llist)
            llist = llist(2:end);
        end


        %%variables

        %uicontrols to hold the text- and edit-boxes for the function's parameters
        lplt = [];
        lpli = [];


        %Main Window
        Fig.add    = figure    ('MenuBar'           ,'none',...
                                'Name'              ,'Function Selection',...
                                'NumberTitle'       ,'off',...
                                'Position'          ,lPos.Gui,...
                                'Resize'            ,'on',...
                                'Toolbar'           ,'none',...
                                'Units'             ,'pixels',...
                                'Color'             ,lColor.Gui,...
                                'Visible'           ,'off');


        %Panel 1 - Function Selection
        lPanel.add1 = uipanel   ('Parent'            ,Fig.add,....
                                'BorderType'        ,'none',...
                                'BackgroundColor'   ,lColor.Gui,...
                                'Units'             ,'normalized',...
                                'Position'          ,lPos.Panel1);

        lTxt.fun_text  = uicontrol ('Style'              ,'text',...
                                'Parent'             ,lPanel.add1,...
                                'String'             ,ltext,...
                                'Units'              ,'normalized',...
                                'FontSize'           ,12,...
                                'FontWeight'         ,'bold',...
                                'BackgroundColor'    ,lColor.Gui,...
                                'Position'           ,lPos.fun_text);

        lpp        = uicontrol ('Style'              ,'popup',...
                                'Parent'             ,lPanel.add1,...
                                'String'             ,llist,...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.pp,...
                                'Callback'           ,{@lpp_callback});



        %Panel2 - Help for the function           
        lPanel.add2= uipanel   ('Parent'             ,Fig.add,....
                                'FontSize'           ,10,...
                                'Title'              ,'Help',...
                                'BackgroundColor'    ,lColor.Gui,...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.Panel2);

        lTxt.msg       = uicontrol ('Style'              ,'text',...
                                'Parent'             ,lPanel.add2,...
                                'Units'              ,'normalized',...
                                'FontSize'           ,msgFontSize,...
                                'FontName'           ,'Courier',...
                                'HorizontalAlignment','left',...
                                'BackgroundColor'    ,lColor.msg,...
                                'Position'           ,lPos.msg);

        lTxt.slider    = uicontrol ('Style'              ,'slider',...
                                'Parent'             ,lPanel.add2,...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.slider,...
                                'Enable'             ,'off',...
                                'Callback'           ,{@print_msg,lTxt.msg});


        %Panel 3 - Cancel/Done buttons         
        lPanel.add3= uipanel   ('Parent'             ,Fig.add,....
                                'BorderType'         ,'none',...
                                'BackgroundColor'    ,lColor.Gui,...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.Panel3);


        lButton.can = uicontrol ('Parent'             ,lPanel.add3,...
                                'Style'              ,'pushbutton',...
                                'String'             ,'Cancel',...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.can,...
                                'Callback'           ,{@quit,Fig.add});
                                 %warning: quit is global function


        lButton.ok = uicontrol ('Parent'             ,lPanel.add3,...
                                'Style'              ,'pushbutton',...
                                'String'             ,'Done',...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.ok,...
                                'Callback'           ,@lok_callback);


        %%Callbacks              
        function lpp_callback(hObject,~)
            %parameter validation
            if isempty(fun)
                return;
            end

            %get the id of the selected function
            val = get(hObject,'Value');

            %update the help information (scrolltext_update is a global function)
            print_msg({fun{val}{3}} ,lTxt.msg,lTxt.slider,0);

            %define the necessary uicontrols
            for i = 1:length(lplt)
                set(lplt{i},'Visible','off');
                set(lpli{i},'Visible','off');
            end
            lplt = cell(1,length(fun{val}{2}));
            lpli = cell(1,length(fun{val}{2}));

            %implement the necessary uicontrols
            for i = 1:length(fun{val}{2})
                lplt_Pos = [0.2 0.7-i*0.05 0.2 0.05];
                lpli_Pos = [0.4 0.7-i*0.05 0.4 0.05];
                lplt{i} = uicontrol('Style'   ,'text',...
                         'Parent'  ,lPanel.add1,...
                         'String'  ,[fun{val}{2}{i} ': '],...
                         'Units'   ,'normalized',...
                         'HorizontalAlignment','left',...
                         'FontSize',10,...
                         'BackgroundColor',lColor.Gui,...
                         'Position',lplt_Pos);

                lpli{i} = uicontrol('Style'   ,'edit',...
                         'Parent'  ,lPanel.add1,...
                         'String'  ,'',...
                         'BackgroundColor'   ,lColor.msg,...
                         'Units'   ,'normalized',...
                         'FontSize',10,...
                         'Position',lpli_Pos);
            end

            
            %user-help: general auto-completion
            for i = 1:length(lplt)
                tmp = get(lplt{i},'String');
                
                if strcmp(tmp,'A: ') ||...
                        strcmp(tmp,'VV: ') ||...
                        strcmp(tmp,'V: ') ||...
                        strcmp(tmp,'V0: ')
                    set(lpli{i},'String',tmp(1:end-2));
                end
                
                if strcmp(tmp,'Graph: ')
                    set(lpli{i},'String','A');
                end
                
            end
                        
        end

        function lok_callback(~,~)
            switch var
                case 'Grf'
                    %store user parameters in the struct
                    Param.Grf      = struct;
                    Param.Grf.name = fun{get(lpp,'Value')}{1};
                    Param.Grf.par  = cell(1,length(lpli));
                    for i = 1:length(Param.Grf.par)
                        Param.Grf.par{i} = get(lpli{i},'String');
                    end

                    %get the selected graph id
                    Id.grf = get(lpp,'Value');

                    %change the gui button string to edit
                    set(Button.add_grf,'String','Edit');

                    %print the user options in the gui screen
                    str = sprintf(['\n' Param.Grf.name '\n']);
                    for i = 1:length(Param.Grf.par)
                        par = ['   ' fun{Id.grf}{2}{i} ' : ' Param.Grf.par{i} '\n'];
                        str = sprintf([str par]);
                    end
                    set(Txt.slc_grf,'String',str);

                    %enable the remove button
                    set(Button.rm_grf,'Enable','on');

                case 'Alg'
                    if ~edit_alg_mode %add mode
                        %store user parameters in the struct
                        if ~isempty(fields(Param.Alg)) %Alg is not empty
                            Param.Alg.name = {Param.Alg.name{:} fun{get(lpp,'Value')}{1}};
                            Param.Alg.par  = {Param.Alg.par{:} cell(1,length(lpli))};
                        else                     %Alg is empty
                            Param.Alg.name = {fun{get(lpp,'Value')}{1}};
                            Param.Alg.par  = {cell(1,length(lpli))};
                        end
                        for i = 1:length(Param.Alg.par{end})
                            Param.Alg.par{end}{i} = get(lpli{i},'String');
                        end

                        %get the selected graph id
                        Id.alg = [Id.alg get(lpp,'Value')];

                        %print the user options in the gui screen
                        str = sprintf(['\n' Param.Alg.name{end} '\n']);
                        for i = 1:length(Param.Alg.par{end})
                            par = ['   ' fun{Id.alg(end)}{2}{i} ' : ' Param.Alg.par{end}{i} '\n'];
                            str = sprintf([str par]);
                        end

                        %enable the edit button
                        set(Button.edit_alg,'Enable','on');

                        %enable the remove button
                        set(Button.rm_alg,'Enable','on');

                        %add a tab button
                        n = length(Button.alg_tab) + 1;
                        s = ['Alg' num2str(n)];
                        tmp_alg_tab = uicontrol('Parent'          ,Panel.main1b,...
                                                'String'          ,s,...
                                                'Units'           ,'normalized',...
                                                'Enable'          ,'on',...
                                                'Tag'             ,num2str(n),...
                                                'BackgroundColor' ,Color.tab,....
                                                'Position'        ,[0.1*(mod(n-1,10)) 0.08*floor((n-1)/10) 0.1 0.08],...
                                                'Callback'        ,{@change_alg_tab});
                        Button.alg_tab     = [Button.alg_tab tmp_alg_tab];

                        %add an algorihtm selection text
                        tmp_slc_alg    = uicontrol('Parent'          ,Panel.main1b,...
                                                   'Style'           ,'text',...
                                                   'String'          ,str,...
                                                   'Units'           ,'normalized',...
                                                   'FontSize'        ,msgFontSize,...
                                                   'BackgroundColor' ,Color.Gui,...
                                                   'HorizontalAlignment','left',...
                                                   'Position'        ,Pos.slc_alg);

                         Txt.slc_alg       = [Txt.slc_alg tmp_slc_alg];                               
                         change_alg_tab(Button.alg_tab(n),[]);

                    else %edit_alg_mode
                        %get the panel-id of the algorithm that should be edited
                        n = 1;
                        for i = 1:length(Button.alg_tab)
                            status = get(Button.alg_tab(i),'Enable');
                            if strcmp(status,'off')
                                n = i;
                                break;
                            end
                        end

                        %store user parameters in the struct
                        Param.Alg.name = {Param.Alg.name{1:(n-1)} fun{get(lpp,'Value')}{1} Param.Alg.name{(n+1):end}};
                        Param.Alg.par  = {Param.Alg.par{1:(n-1)}  cell(1,length(lpli)) Param.Alg.par{(n+1):end}};
                        for i = 1:length(Param.Alg.par{n})
                            Param.Alg.par{n}{i} = get(lpli{i},'String');
                        end

                        %get the selected graph id
                        Id.alg = [Id.alg(1:n-1) get(lpp,'Value') Id.alg(n+1:end)];

                        %print the user options in the gui screen
                        str = sprintf(['\n' Param.Alg.name{n} '\n']);
                        for i = 1:length(Param.Alg.par{n})
                            par = ['   ' fun{Id.alg(n)}{2}{i} ' : ' Param.Alg.par{n}{i} '\n'];
                            str = sprintf([str par]);
                        end
                        set(Txt.slc_alg(n),'String',str);

                    end

                case 'Cln'
                    %store user parameters in the struct
                    Param.Cln      = struct;
                    Param.Cln.name = fun{get(lpp,'Value')}{1};
                    Param.Cln.par  = cell(1,length(lpli));
                    for i = 1:length(Param.Cln.par)
                        Param.Cln.par{i} = get(lpli{i},'String');
                    end

                    %get the selected graph id
                    Id.cln = get(lpp,'Value');

                    %change the gui button string to edit
                    set(Button.add_cln,'String','Edit');

                    %print the user options in the gui screen
                    str = sprintf(['\n' Param.Cln.name '\n']);
                    for i = 1:length(Param.Cln.par)
                        par = ['   ' fun{Id.cln}{2}{i} ' : ' Param.Cln.par{i} '\n'];
                        str = sprintf([str par]);
                    end
                    set(Txt.slc_cln,'String',str);

                    %enable the remove button
                    set(Button.rm_cln,'Enable','on');

                case 'Eva'
                    %store user parameters in the struct
                    Param.Eva      = struct;
                    Param.Eva.name = fun{get(lpp,'Value')}{1};
                    Param.Eva.par  = cell(1,length(lpli));
                    for i = 1:length(Param.Eva.par)
                        Param.Eva.par{i} = get(lpli{i},'String');
                    end

                    %get the selected graph id
                    Id.eva = get(lpp,'Value');

                    %change the gui button string to edit
                    set(Button.add_eva,'String','Edit');

                    %print the user options in the gui screen
                    str = sprintf(['\n' Param.Eva.name '\n']);
                    for i = 1:length(Param.Eva.par)
                        par = ['   ' fun{Id.eva}{2}{i} ' : ' Param.Eva.par{i} '\n'];
                        str = sprintf([str par]);
                    end
                    set(Txt.slc_eva,'String',str);

                    %enable the remove button
                    set(Button.rm_eva,'Enable','on');
            end
            quit([],[],Fig.add);
        end
        
        %%GUI Activation commands
        lpp_callback(lpp);

        %check if we are in edit mode (to load previous options)
        if ~strcmp(var,'Alg') || (strcmp(var,'Alg') && edit_alg_mode)
            if ~isempty(fields(eval(['Param.' var])))
                %load the function name

                %if algorithm get the panel-id
                if strcmp(var,'Alg') && edit_alg_mode
                    n = 1;
                    for i = 1:length(Button.alg_tab)
                        status = get(Button.alg_tab(i),'Enable');
                        if strcmp(status,'off')
                            n = i;
                            break;
                        end
                    end
                   %find the function name in the popup menu (for Algs)
                   s = strfind(llist,eval(['Param.' var '.name{' num2str(n) '}']));
                else
                   %find the function name in the popup menu (for funs)
                   s = strfind(llist,eval(['Param.' var '.name']));
                end

                %if the function's name wasn't found (problem)
                if isempty(s)
                    %clear the function name and parameters
                    eval(['Param.' var '= struct;']);

                else
                    %then get its value for the popup
                    v = length(strfind(llist(1:s),'|'))+1;
                    set(lpp,'Value',v);

                    %change the GUI displayed parameters
                    lpp_callback(lpp);

                    %load the parameters
                    if strcmp(var,'Alg') && edit_alg_mode
                        pars = eval(['Param.' var '.par{' num2str(n) '};']);
                    else
                        pars = eval(['Param.' var '.par;']);
                    end
                    for i = 1:length(lpli)
                        set(lpli{i},'String',pars{i});
                    end
                end
            end
        end
        movegui(Fig.add,'center');              
        set(Fig.add,'Visible','on'); 
    end

    function export_callback(~,~)
        %EXPORT_CALLBACK exports the data of the experiment
        
        if isempty(Results)
            lvars = {'Data' 'Param' 'Id'};
        else
            lvars = {'Data' 'Param' 'Id' 'Results'};
        end
        cd('./Experiments');
        uisave(lvars,'savefile');
        cd('..');
        print_msg('Exported Data.',Txt.msg,Txt.slider);
    end

    function import_callback(~,~)
        %IMPORT_CALLBACK imports data, exported from another experiment.
        %If the data is corrupted, nothing is imported and the previous
        %data is kept.
        
        %select a file
        [file path] = uigetfile('*.mat', 'Open MAT file','Experiments');
        
        %if no file is specified return
        if file == 0
            return;
        end
        
        %load data
        ldata = load([path file]);
        
        %if not all the variables exist, return
        if ~isfield(ldata,'Data') || ~isfield(ldata,'Param') || ~isfield(ldata,'Id')
            print_msg('Error: Unable to import data. Corrupted File.',Txt.msg,Txt.slider);
            return;
        end
        
        %if anything is missing, return
        if ~isempty(setdiff(fieldnames(ldata.Data),fieldnames(Data))) ...
            && ~isempty(setdiff(fieldnames(ldata.Param),fieldnames(Param))) ...
            && ~isempty(setdiff(fieldnames(ldata.Id),fieldnames(Id)))
             print_msg('Error: Unable to import data. Corrupted File.',Txt.msg,Txt.slider);
            return;
        end
        
        %data checked, import it
        
        %import Graph
        Id.grf = [];
        Param.Grf = struct;
        
        if ~isempty(ldata.Id.grf)
            %check if the imported graph function exists in the Toolbox
            found = 0;
            
            %get the graph name
            name = ldata.Param.Grf.name;
            
            for i = 1:length(Data.Graphs)
                
                %check if it is in the Data.Graphs struct
                found = or(found,strcmp(name,Data.Graphs{i}{1}));
                
                %found it
                if found
                    Param.Grf = ldata.Param.Grf;
                    Id.grf = i;
                    break;
                end
            end
            
            %did not find it
            if ~found
                print_msg(['Graph function: ' name ' not found.'],Txt.msg,Txt.slider);
            end
        end
        
        %import Algorithms
        Id.alg = [];
        Param.Alg = struct;
        
        %if ~isempty(ldata.Id.alg)
        if ~isempty(fieldnames(ldata.Param.Alg))
            for j = 1:length(ldata.Id.alg)
                
                %check if we exceed the array length
                if j > length(ldata.Param.Alg.name)
                     break;
                end
                
                %check if the imported graph function exists in the Toolbox
                found = 0;

                %get the algorithm name
                name = ldata.Param.Alg.name{j};

                for i = 1:length(Data.Algorithms)

                    %check if it is in the Data.Graphs struct
                    found = or(found,strcmp(name,Data.Algorithms{i}{1}));

                    %found it
                    if found
                        if ~isempty(fieldnames(Param.Alg))
                            Param.Alg.name = {Param.Alg.name{:} ldata.Param.Alg.name{j}};
                            Param.Alg.par = {Param.Alg.par{:} ldata.Param.Alg.par{j}};
                        else
                            Param.Alg.name = ldata.Param.Alg.name(j); %{ldata.Param.Alg.name{j}};
                            Param.Alg.par  = ldata.Param.Alg.par(j); %{ldata.Param.Alg.par{j}};
                        end
                        Id.alg = [Id.alg i];
                        break;
                    end
                end

                %did not find it
                if ~found
                    print_msg(['Algorithm function: ' name ' not found.'],Txt.msg,Txt.slider);
                end
            end
        end
        
        
        
        %import Cluster_Number
        Id.cln = [];
        Param.Cln = struct;
        
        if ~isempty(ldata.Id.cln)
            %check if the imported cluster_number function exists in the Toolbox
            found = 0;
            
            %get the cluster_number name
            name = ldata.Param.Cln.name;
            for i = 1:length(Data.Cluster_Number)
                
                %check if it is in the Data.Cluster_Number struct
                found = or(found,strcmp(name,Data.Cluster_Number{i}{1}));
                
               %found it
                if found
                    Param.Cln = ldata.Param.Cln;
                    Id.cln = i;
                    break;
                end
            end
            
            %did not find it
            if ~found
                print_msg(['Cluster Number function: ' name ' not found.'],Txt.msg,Txt.slider);
            end
        end
        
        %import Evaluation    
        Id.eva = [];
        Param.Eva = struct;
        
        if ~isempty(ldata.Id.eva)
            %check if the imported evalution function exists in the Toolbox
            found = 0;
            
            %get the evaluation name
            name = ldata.Param.Eva.name;
            
            for i = 1:length(Data.Evaluation)
                
                %check if it is in the Data.Evaluation struct
                found = or(found,strcmp(name,Data.Evaluation{i}{1}));
                
                %found it
                if found
                    Param.Eva = ldata.Param.Eva;
                    Id.eva = i;
                    break;
                end
            end
            
            %did not find it
            if ~found
                print_msg(['Evaluation function: ' name ' not found.'],Txt.msg,Txt.slider);
            end
        end
        
        %load user options
        Param.Opt = ldata.Param.Opt;
        
        %load Results
        if ~isempty(ldata.Results)
            Results = ldata.Results;
        end
        
        %make the necessary changes to the GUI
        
        %Graph changes
        if isempty(fieldnames(Param.Grf))
            set(Button.add_grf,'String','Add');
            set(Txt.slc_grf,'String','');
        else
            %change the button string to edit
            set(Button.add_grf,'String','Edit');
            
            %enable the remove button
            set(Button.rm_grf,'Enable','on');

            %print the user options in the gui screen
            str = sprintf(['\n' Param.Grf.name '\n']);
            for i = 1:length(Param.Grf.par)
                 par = ['   ' Data.Graphs{Id.grf}{2}{i} ' : ' Param.Grf.par{i} '\n'];
                 str = sprintf([str par]);
            end
             set(Txt.slc_grf,'String',str);    
        end
        
        %Algorithm changes
        if isempty(fieldnames(Param.Alg))
            %change the status of the Algorithm buttons
            set(Button.add_alg,'Enable','on');
            set(Button.edit_alg,'Enable','off');
            set(Button.rm_alg,'Enable','off');

            %Clear the Algorithm Selection Panel
            for i = 1:length(Button.alg_tab)
                set(Button.alg_tab(i),'Visible','off');
                set(Txt.slc_alg(i),'Visible','off');
            end

            Button.alg_tab = [];
            Txt.slc_alg = [];
        else
            %change the status of the Algorithm buttons
            set(Button.add_alg,'Enable','on');
            set(Button.edit_alg,'Enable','on');
            set(Button.rm_alg,'Enable','on');

            %Clear the Algorithm Selection Panel
            for i = 1:length(Button.alg_tab)
                set(Button.alg_tab(i),'Visible','off');
                set(Txt.slc_alg(i),'Visible','off');
            end

            %make sure we don't get out of limits
            N = min(length(Param.Alg.name),length(Param.Alg.par));
            
            Button.alg_tab = [];
            Button.slc_alg = [];
            Txt.slc_alg    = [];
  
            %construct the elements
            for i = 1:N
                    %add a tab button
                    n = length(Button.alg_tab) + 1;
                    s = ['Alg' num2str(n)];
                    tmp_alg_tab = uicontrol('Parent'          ,Panel.main1b,...
                                            'String'          ,s,...
                                            'Units'           ,'normalized',...
                                            'Enable'          ,'on',...
                                            'Tag'             ,num2str(n),...
                                            'BackgroundColor' ,Color.tab,....
                                            'Position'        ,[0.1*(mod(n-1,10)) 0.08*floor((n-1)/10) 0.1 0.08],...
                                            'Callback'        ,{@change_alg_tab});
                    Button.alg_tab    = [Button.alg_tab tmp_alg_tab];

                    %print the user options in the gui screen
                    str = sprintf(['\n' Param.Alg.name{i} '\n']);
                                      
                    for j = 1:length(Param.Alg.par{i})
                        par = ['   ' Data.Algorithms{Id.alg(i)}{2}{j} ' : ' Param.Alg.par{i}{j} '\n'];
                        str = sprintf([str par]);
                    end

                    %add an algorihtm selection text
                    tmp_slc_alg    = uicontrol('Parent'          ,Panel.main1b,...
                                               'Style'           ,'text',...
                                               'String'          ,str,...
                                               'Units'           ,'normalized',...
                                               'BackgroundColor' ,Color.Gui,...
                                               'HorizontalAlignment','left',...
                                               'FontSize'        ,msgFontSize,...
                                               'Visible'         ,'off',...
                                               'Position'        ,Pos.slc_alg);

                     Txt.slc_alg       = [Txt.slc_alg tmp_slc_alg];
            end
            change_alg_tab(Button.alg_tab(1),[]);
        end
        
        %Cluster Number Selection changes
        if isempty(fieldnames(Param.Cln))
            set(Button.add_cln,'String','Add');
            set(Txt.slc_cln,'String','');
        else
            %change the button string to edit
            set(Button.add_cln,'String','Edit');
            
            %enable the remove button
            set(Button.rm_cln,'Enable','on');

            %print the user options in the gui screen
            str = sprintf(['\n' Param.Cln.name '\n']);
            for i = 1:length(Param.Cln.par)
                 par = ['   ' Data.Cluster_Number{Id.cln}{2}{i} ' : ' Param.Cln.par{i} '\n'];
                 str = sprintf([str par]);
             end
             set(Txt.slc_cln,'String',str); 
        end
        
        %Evaluation changes
        if isempty(fieldnames(Param.Eva))
            set(Button.add_eva,'String','Add');
            set(Txt.slc_eva,'String','');
        else
            %change the button string to edit
            set(Button.add_eva,'String','Edit');
            
            %enable the remove button
            set(Button.rm_eva,'Enable','on');

            %print the user options in the gui screen
            str = sprintf(['\n' Param.Eva.name '\n']);
            for i = 1:length(Param.Eva.par)
                 par = ['   ' Data.Evaluation{Id.eva}{2}{i} ' : ' Param.Eva.par{i} '\n'];
                 str = sprintf([str par]);
             end
             set(Txt.slc_eva,'String',str); 
        end 
    end

    function slider_callback(source,~,hText)
        %SLIDER_CALLBACK is used to print the right text in a message box
        %when the slider is moved
        
        %get the current text from the message screen
        textString = get(hText,'UserData');

        %calculate the number of lines
        nLines = numel(textString);

        %calculate the value of the slider
        lineIndex = nLines-round(get(source,'Value'))+1;

        %set the value of the slider
        set(hText,'String',textString(lineIndex:nLines));
    end

    function print_msg(newText,hText,hSlider,keep_old)
        %PRINT_MSG is a function for printing messages in the GUI.
        %newText is the text to be printed
        %hText is the handle where we will print
        %hSlider is the slider that should move with hText
        %keep_old is optional, whether we want to keep the previous
        %         messages in hText
        
        %check if previous text should be kept
        if ~exist('keep_old','var')
            keep_old = 1;
        end
        
        if isempty(keep_old)
            keep_old = 1;
        end

        %newText may be a string as well
        if ischar(newText)
            newText = {newText};
        end

        if keep_old
            %check the value of the old text
            oldText = get(hText,'UserData');

            %calculate the final new text
            if ~strcmp(oldText,'Ready...')
                newText = [oldText; newText];
            end
            newText = textwrap(hText,newText);
            %set the the new text to the message screen
            set(hText,'String',newText,'UserData',newText);

            %check if the slider should be enabled or not
            nRows = numel(newText);
            if (nRows < 2),
              sliderEnable = 'off';
            else
              sliderEnable = 'on';
            end
            
            %calculate the approximate number of lines the slider should move down
            set(hText,'Units','characters');
            c    = get(hText,'Position');
            fact = floor(c(4))-2;

            %update the length of the slider
            set(hSlider,'Enable',sliderEnable,'Max',nRows,...
                'SliderStep',[1 3]./nRows,'Value',min(nRows,get(hSlider,'Min')+fact));

            %update the slider position
            slider_callback(hSlider,[],hText);

        else %~keep_old
            %format and save the new text
            newText = textwrap(hText,newText);
            set(hText,'String',newText,'UserData',newText);

            %calculate the number of rows
            nRows = numel(newText);

            %calculate if the slider should be enabled
            if (nRows < 5),
              sliderEnable = 'off';
            else
              sliderEnable = 'on';
            end
            nRows = max(nRows-1,1);

            %save the value of the slider
            set(hSlider,'Enable',sliderEnable,'Max',nRows,...
                'SliderStep',[1 3]./nRows,'Value',nRows);
        end
    end

    function variables_callback(~,~)
        %VARIABLES_CALLBACK opens a new window which enables the user to specify the
        %experiment options
        
        %l declares local variable

        lPos.Gui           = [0    0    908    533   ]; %pixels (the rest are normalized)

        lPos.Panel1        = [0    0.95    1     0.05]; %panel 1
        lPos.title         = [0.4  0       0.2   1   ];

        lPos.Panel2        = [0    0.15   1      0.8 ]; %panel 2
        lPos.name          = [0.05 0.95   0.2    0.05];
        lPos.value         = [0.55 0.95   0.2    0.05];
        lPos.sel_all_ck    = [0    0.95   0.02   0.05];

        lPos.Panel3        = [0    0      1      0.15]; %panel 3
        lPos.add           = [0.05 0.2    0.13   0.38];
        lPos.remove        = [0.18 0.2    0.13   0.38];
        lPos.can           = [0.72 0.2    0.13   0.38];
        lPos.ok            = [0.85 0.2    0.13   0.38];


        lColor.Gui    = Color.Gui; %warning: Gui_Color is a global variable
        lColor.msg    = Color.msg; %warning: msg_Color is a global variable

        %uicontrols for the variables
        lckbox = {}; %checkbox for removing variables
        lnamef = {}; %edit for the name of the variable
        lvalf  = {}; %edit for the value of the variable

        %Main Window
        Fig.var        = figure('MenuBar'           ,'none',...
                                'Name'              ,'Variables Selection',...
                                'NumberTitle'       ,'off',...
                                'Position'          ,lPos.Gui,...
                                'Resize'            ,'on',...
                                'Toolbar'           ,'none',...
                                'Units'             ,'pixels',...
                                'Color'             ,lColor.Gui,...
                                'Visible'           ,'off');



        %Panel 1 - Title Section
        lPanel.var1= uipanel   ('Parent'            ,Fig.var,....
                                'BorderType'        ,'none',...
                                'BackgroundColor'   ,lColor.Gui,...
                                'Units'             ,'normalized',...
                                'Position'          ,lPos.Panel1);



        lTxt.title = uicontrol ('Style'              ,'text',...
                                'Parent'             ,lPanel.var1,...
                                'String'             ,'Variables',...
                                'Units'              ,'normalized',...
                                'FontSize'           ,12,...
                                'FontWeight'         ,'bold',...
                                'BackgroundColor'    ,lColor.Gui,...
                                'Position'           ,lPos.title);



        %Panel 2 - Variables' Section
        lPanel.var2   = uipanel('Parent'             ,Fig.var,....
                                'BorderType'         ,'none',...
                                'BackgroundColor'    ,lColor.Gui,...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.Panel2);

        lButton.sel_all = uicontrol('Parent'           ,lPanel.var2,...
                                 'Style'            ,'checkbox',...
                                 'Units'            ,'normalized',...
                                 'Position'         ,lPos.sel_all_ck,...
                                 'Callback'         ,@select_all_callback);


        lTxt.name = uicontrol('Style'              ,'text',...
                              'Parent'             ,lPanel.var2,...
                              'String'             ,'Name',...
                              'Units'              ,'normalized',...
                              'HorizontalAlignment','left',...
                              'FontSize'           ,11,...
                              'BackgroundColor'    ,lColor.Gui,...
                              'Position'           ,lPos.name);

        lTxt.value = uicontrol('Style'              ,'text',...
                              'Parent'             ,lPanel.var2,...
                              'String'             ,'Value',...
                              'Units'              ,'normalized',...
                              'HorizontalAlignment','left',...
                              'FontSize'           ,11,...
                              'BackgroundColor'    ,lColor.Gui,...
                              'Position'           ,lPos.value);                  

        %Panel 3 - Cancel/Done buttons         
        lPanel.var3    = uipanel('Parent'             ,Fig.var,....
                                'BorderType'         ,'none',...
                                'BackgroundColor'    ,lColor.Gui,...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.Panel3);


        lButton.add= uicontrol ('Parent'             ,lPanel.var3,...
                                'Style'              ,'pushbutton',...
                                'String'             ,'Add',...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.add,...
                                'Callback'           ,@ladd_callback);


        lButton.remove= uicontrol('Parent'             ,lPanel.var3,...
                                'Style'              ,'pushbutton',...
                                'String'             ,'Remove',...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.remove,...
                                'Callback'           ,{@lremove_callback,lButton.add});                    


        lButton.cancel= uicontrol ('Parent'             ,lPanel.var3,...
                                'Style'              ,'pushbutton',...
                                'String'             ,'Cancel',...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.can,...
                                'Callback'           ,{@quit,Fig.var});
                                 %warning: quit is global function


        lButton.ok = uicontrol ('Parent'             ,lPanel.var3,...
                                'Style'              ,'pushbutton',...
                                'String'             ,'Done',...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.ok,...
                                'Callback'           ,@lok_callback);

        function select_all_callback(handle,~)
        %SELECT_ALL_CALLBACK selects all the variables' checkboxes. It is
        %useful if the user wants to delete all of them at once.

            %check if the checkbox is selected
            selected = get(handle,'Value') == get(handle,'Max');

            if selected
                %select every other checkbox
                for i = 1:length(lckbox)
                    set(lckbox{i},'Value',get(lckbox{i},'Max'));
                end
            else
                %deselect every other checkbox
                for i = 1:length(lckbox)
                    set(lckbox{i},'Value',get(lckbox{i},'Min'));
                end
            end

        end

        function ladd_callback(handle,~)
           %LADD_CALLBACK creates the necessary fields for the user to add new
           %variables

           tmp_ckbox = uicontrol('Parent'           ,lPanel.var2,...
                                 'Style'            ,'checkbox',...
                                 'Units'            ,'normalized',...
                                 'Position'         ,[0 0.9-length(lckbox)*0.05 0.02 0.05]);

           tmp_namef = uicontrol('Parent'           ,lPanel.var2,...
                                 'Style'            ,'edit',...
                                 'Units'            ,'normalized',...
                                 'FontSize'         ,10,...
                                 'HorizontalAlignment','left',...
                                 'Position'         ,[0.02 0.9-length(lckbox)*0.05 0.4 0.05]);

           tmp_valf  = uicontrol('Parent'           ,lPanel.var2,...
                                 'Style'            ,'edit',...
                                 'Units'            ,'normalized',...
                                 'FontSize'         ,10,...
                                 'HorizontalAlignment','left',...
                                 'Position'         ,[0.5 0.9-length(lckbox)*0.05 0.4 0.05]);

            lckbox = [lckbox {tmp_ckbox}];
            lnamef = [lnamef {tmp_namef}];
            lvalf  = [lvalf  {tmp_valf}];

            if length(lckbox) >= 19
                set(handle,'Enable','off');
            end
        end

        function lremove_callback(~,~,add_handle)
            %LREMOVE_CALLBACK removes all the variable fields, with a selected
            %checkbox

            %create a logical array indicating what fields are selected
            selected = zeros(1,length(lckbox));
            for i = 1:length(lckbox)
                selected(i) = get(lckbox{i},'Value') == get(lckbox{i},'Max');
            end
            selected = logical(selected);

            %if nothing is selected
            if ~any(selected)
                return;
            end

            %clear all
            for i = 1:length(lckbox)
                set(lckbox{i},'Visible','off');
                set(lnamef{i},'Visible','off');
                set(lvalf{i},'Visible','off');
            end

            %deselect the select-all checkbox
            set(lButton.sel_all,'Value',get(lButton.sel_all,'Min'));

            %remove the selected variables 
            lckbox = lckbox(~selected);
            lnamef = lnamef(~selected);
            lvalf =  lvalf(~selected);

            %correct the position od the remaining variables
            for i = 1:length(lckbox)
                set(lckbox{i},'Position',[0 0.95-i*0.05 0.02 0.05]);
                set(lnamef{i},'Position',[0.02 0.95-i*0.05 0.4 0.05]);
                set(lvalf{i},'Position',[0.5 0.95-i*0.05 0.4 0.05]);
            end

            %make variables Visible again
            for i = 1:length(lckbox)
                set(lckbox{i},'Visible','on');
                set(lnamef{i},'Visible','on');
                set(lvalf{i},'Visible','on');
            end

            if length(lckbox) < 19
                set(add_handle,'Enable','on');
            end     
        end

        function lok_callback(~,~)
        %LOK_CALLBACK saves the user variables and closes the current figure

            %clear the Var cell array
            Param.Var = cell(1,length(lckbox));

            %set the values of Var
            for i = 1:length(lckbox)
                Param.Var{i} = {get(lnamef{i},'String') get(lvalf{i},'String')};
            end

            quit([],[],Fig.var);     
        end


        %if Var has already values keep them
        ladd_vars = length(Param.Var); %number of variables to add
        if ladd_vars > 19
            %the maximum is 19
            ladd_vars = 19;
        end

        %print each variable in the figure
        for j = 1:ladd_vars
            %call the add function
            ladd_callback(lButton.add,[]);

            %set the variable name and value
            set(lnamef{j},'String',Param.Var{j}{1});
            set(lvalf{j},'String',Param.Var{j}{2});
        end

        %%GUI Activation commands 
        movegui(Fig.var,'center');              
        set(Fig.var,'Visible','on');
    end

    function options_callback(~,~)
        %OPTIONS_CALLBACK opens a new window which enables the user to specify the
        %experiment options

        %l declares local variable

        %%constants
        lPos.Gui           = [0    0    1024   533   ]; %pixels (the rest are normalized)

        lPos.Panel1        = [0    0.15   0.4    0.85]; %panel 1
        lPos.title         = [0.2  0.85   0.5    0.05];

        lPos.seed          = [0.5  0.80   0.35    0.05];
        lPos.iters         = [0.5  0.75   0.35    0.05];
        lPos.parameter     = [0.5  0.70   0.35    0.05];
        lPos.status        = [0.5  0.65   0.35    0.05];
        lPos.invert        = [0.5  0.60   0.35    0.05];
        lPos.errors        = [0.5  0.55   0.35    0.05];
        lPos.figtitle      = [0.5  0.50   0.35    0.05];
        lPos.figtype       = [0.5  0.45   0.35    0.05];
        lPos.figxlabel     = [0.5  0.40   0.35    0.05];
        lPos.figylabel     = [0.5  0.35   0.35    0.05];
        lPos.figlegend     = [0.5  0.30   0.35    0.05];


        lPos.Panel2        = [0.4  0.15   0.58   0.85]; %panel 2
        lPos.msg           = [0    0      0.95   1   ];
        lPos.slider        = [0.95 0      0.05   1   ];

        lPos.Panel3        = [0    0      1      0.15]; %panel 3
        lPos.default       = [0.05 0.2    0.13   0.38];
        lPos.can           = [0.72 0.2    0.13   0.38];
        lPos.ok            = [0.85 0.2    0.13   0.38]; 

        lColor.Gui    = Color.Gui; %warning: Gui_Color is a global variable
        lColor.msg    = Color.msg; %warning: msg_Color is a global variable

        lTxt.strings  = {'Options', 'Seed:', 'Iterations:', 'parameter:', 'Status?',...
                        'Invert?', 'Ignore Errors?', 'Figtitle',...
                        'Figtype', 'Figxlabel', 'Figylabel', 'Figlegend'};


        %Main Window
        Fig.opt    = figure    ('MenuBar'           ,'none',...
                                'Name'              ,'Options Selection',...
                                'NumberTitle'       ,'off',...
                                'Position'          ,lPos.Gui,...
                                'Resize'            ,'on',...
                                'Toolbar'           ,'none',...
                                'Units'             ,'pixels',...
                                'Color'             ,lColor.Gui,...
                                'Visible'           ,'off');


        %Panel 1 - Function Selection
        lPanel.opt1   = uipanel('Parent'            ,Fig.opt,....
                                'BorderType'        ,'none',...
                                'BackgroundColor'   ,lColor.Gui,...
                                'Units'             ,'normalized',...
                                'Position'          ,lPos.Panel1);

        lTxt.text = cell(1,length(lTxt.strings));
        lTxt.text{1} = uicontrol ('Style'              ,'text',...
                                'Parent'             ,lPanel.opt1,...
                                'String'             ,'Options',...
                                'Units'              ,'normalized',...
                                'FontSize'           ,12,...
                                'FontWeight'         ,'bold',...
                                'BackgroundColor'    ,lColor.Gui,...
                                'Position'           ,lPos.title);


        for i = 2:length(lTxt.strings)
            lTxt.text = [lTxt.text {uicontrol('Style'              ,'text',...
                                              'Parent'             ,lPanel.opt1,...
                                              'String'             ,lTxt.strings{i},...
                                              'Units'              ,'normalized',...
                                              'FontSize'           ,10,...
                                              'HorizontalAlignment','left',...
                                              'BackgroundColor'    ,lColor.Gui,...
                                              'Position'           ,[0.2  0.90-i*0.05   0.3    0.05])}];
        end





        lTxt.seed = uicontrol('Style' ,'edit',...
                              'Parent',lPanel.opt1,...
                              'String',num2str(seed),...
                              'Units','normalized',...
                              'HorizontalAlignment','center',...
                              'FontSize',10,...
                              'BackgroundColor',lColor.msg,...
                              'Position',lPos.seed);     

        lTxt.iters = uicontrol('Style' ,'edit',...
                              'Parent',lPanel.opt1,...
                              'String','10',...
                              'Units','normalized',...
                              'HorizontalAlignment','center',...
                              'FontSize',10,...
                              'BackgroundColor',lColor.msg,...
                              'Position',lPos.iters);    

        lTxt.parameter  = uicontrol('Style' ,'edit',...
                              'Parent',lPanel.opt1,...
                              'String','0:0.1:1',...
                              'Units','normalized',...
                              'HorizontalAlignment','center',...
                              'FontSize',10,...
                              'BackgroundColor',lColor.msg,...
                              'Position',lPos.parameter);

        lTxt.status = uicontrol('Style' ,'checkbox',...
                              'Parent',lPanel.opt1,...
                              'Units','normalized',...
                              'BackgroundColor',lColor.Gui,...
                              'Position',lPos.status);

        lTxt.invert = uicontrol('Style' ,'checkbox',...
                              'Parent',lPanel.opt1,...
                              'Units','normalized',...
                              'BackgroundColor',lColor.Gui,...
                              'Position',lPos.invert);

        lTxt.errors = uicontrol('Style' ,'checkbox',...
                              'Parent',lPanel.opt1,...
                              'Units','normalized',...
                              'BackgroundColor',lColor.Gui,...
                              'Position',lPos.errors);

        lTxt.figtitle = uicontrol('Style' ,'edit',...
                              'Parent',lPanel.opt1,...
                              'String','Clustering Experiment',...
                              'Units','normalized',...
                              'HorizontalAlignment','center',...
                              'FontSize',10,...
                              'BackgroundColor',lColor.msg,...
                              'Position',lPos.figtitle);

        lTxt.figtype = uicontrol('Style' ,'edit',...
                              'Parent',lPanel.opt1,...
                              'String','',...
                              'Units','normalized',...
                              'HorizontalAlignment','center',...
                              'FontSize',10,...
                              'BackgroundColor',lColor.msg,...
                              'Position',lPos.figtype);

        lTxt.figxlabel = uicontrol('Style' ,'edit',...
                              'Parent',lPanel.opt1,...
                              'String','',...
                              'Units','normalized',...
                              'HorizontalAlignment','center',...
                              'FontSize',10,...
                              'BackgroundColor',lColor.msg,...
                              'Position',lPos.figxlabel);

        lTxt.figylabel = uicontrol('Style' ,'edit',...
                              'Parent',lPanel.opt1,...
                              'String','',...
                              'Units','normalized',...
                              'HorizontalAlignment','center',...
                              'FontSize',10,...
                              'BackgroundColor',lColor.msg,...
                              'Position',lPos.figylabel);

        lTxt.figlegend = uicontrol('Style' ,'edit',...
                              'Parent',lPanel.opt1,...
                              'String','',...
                              'Units','normalized',...
                              'HorizontalAlignment','center',...
                              'FontSize',10,...
                              'BackgroundColor',lColor.msg,...
                              'Position',lPos.figlegend);


        %Panel2 - Help for the function           
        lPanel.opt2 = uipanel   ('Parent'             ,Fig.opt,....
                                'FontSize'           ,10,...
                                'Title'              ,'Help',...
                                'BackgroundColor'    ,lColor.Gui,...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.Panel2);

        lTxt.msg   = uicontrol ('Style'              ,'text',...
                                'Parent'             ,lPanel.opt2,...
                                'Units'              ,'normalized',...
                                'HorizontalAlignment','left',...
                                'FontName'           ,'Courier',...
                                'FontSize'           ,msgFontSize,...
                                'BackgroundColor'    ,lColor.msg,...
                                'Position'           ,lPos.msg);

        lTxt.slider = uicontrol ('Style'              ,'slider',...
                                'Parent'             ,lPanel.opt2,...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.slider,...
                                'Enable'             ,'off',...
                                'Callback'           ,{@scrolltext_callback,lTxt.msg});


        %Panel 3 - Cancel/Done buttons         
        lPanel.opt3= uipanel   ('Parent'             ,Fig.opt,....
                                'BorderType'         ,'none',...
                                'BackgroundColor'    ,lColor.Gui,...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.Panel3);

        lButton.default= uicontrol ('Parent'         ,lPanel.opt3,...
                                'Style'              ,'pushbutton',...
                                'String'             ,'Default',...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.default,...
                                'Callback'           ,@ldefault_callback);


        lButton.can= uicontrol ('Parent'             ,lPanel.opt3,...
                                'Style'              ,'pushbutton',...
                                'String'             ,'Cancel',...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.can,...
                                'Callback'           ,{@quit,Fig.opt});
                                 %warning: quit is global function


        lButton.done= uicontrol ('Parent'             ,lPanel.opt3,...
                                'Style'              ,'pushbutton',...
                                'String'             ,'Done',...
                                'Units'              ,'normalized',...
                                'Position'           ,lPos.ok,...
                                'Callback'           ,@lok_callback);



        function lok_callback(~,~)
        %LOK_CALLBACK saves the user options and closes the current figure

            %clear the Opt variable
            Param.Opt = struct;

            %set Opt values
            Param.Opt.parameter = get(lTxt.parameter,'String');
            Param.Opt.seed  = get(lTxt.seed,'String');
            seed            = str2num(get(lTxt.seed,'String'));
            Param.Opt.iters = get(lTxt.iters,'String');

            if (get(lTxt.errors,'Value') == get(lTxt.errors,'Max'))
                Param.Opt.errors = 'on';
            else
                Param.Opt.errors = 'off';
            end

            if (get(lTxt.invert,'Value') == get(lTxt.invert,'Max'))
                Param.Opt.invert = 'on';
            else
                Param.Opt.invert = 'off';
            end

            if (get(lTxt.status,'Value') == get(lTxt.status,'Max'))
                Param.Opt.status = 'on';
            else
                Param.Opt.status = 'off';
            end

            if ~isempty(get(lTxt.figtype,'String'))
                Param.Opt.figtype = get(lTxt.figtype,'String');
            else
                Param.Opt.figtype = '';
            end

            Param.Opt.figtitle  = get(lTxt.figtitle,'String');
            Param.Opt.figxlabel = get(lTxt.figxlabel,'String');
            Param.Opt.figylabel = get(lTxt.figylabel,'String');
            Param.Opt.figlegend = get(lTxt.figlegend,'String');

            %should this be kept??
            Param.Opt.savefig = 'off';

            quit([],[],Fig.opt);
        end

        function ldefault_callback(~,~)
        %LDEFAULT_CALLBACK changed the options back to default

            %set default values
            set(lTxt.seed,'String',num2str(seed));
            set(lTxt.iters,'String','10');
            set(lTxt.parameter,'String','0:0.1:1');
            set(lTxt.figtitle,'String','Clustering Experiment');

            set(lTxt.figxlabel,'String','');
            set(lTxt.figylabel,'String','');
            set(lTxt.figlegend,'String','');
            set(lTxt.figtype,'String','');
            set(lTxt.status,'Value',get(lTxt.status,'Max'));
            set(lTxt.invert,'Value',get(lTxt.invert,'Min'));
            set(lTxt.errors,'Value',get(lTxt.errors,'Min'));
        end

        %Options have already been defined (default_callback)
        set(lTxt.seed,'String',Param.Opt.seed);
        set(lTxt.iters,'String',Param.Opt.iters);
        set(lTxt.parameter,'String',Param.Opt.parameter);
        set(lTxt.figtitle,'String',Param.Opt.figtitle);

        set(lTxt.figxlabel,'String',Param.Opt.figxlabel);
        set(lTxt.figylabel,'String',Param.Opt.figylabel);
        set(lTxt.figlegend,'String',Param.Opt.figlegend);
        set(lTxt.figtype,'String',Param.Opt.figtype);

        if strcmp(Param.Opt.status,'on')
            set(lTxt.status,'Value',get(lTxt.status,'Max'));
        else
            set(lTxt.status,'Value',get(lTxt.status,'Min'));
        end


        if strcmp(Param.Opt.errors,'on')
            set(lTxt.errors,'Value',get(lTxt.errors,'Max'));
        else
            set(lTxt.errors,'Value',get(lTxt.errors,'Min'));
        end


        if strcmp(Param.Opt.invert,'on')
            set(lTxt.invert,'Value',get(lTxt.invert,'Max'));
        else
            set(lTxt.invert,'Value',get(lTxt.invert,'Min'));
        end

        Param.Opt.savefig = 'on';

        %update the help information (scrolltext_update is a global function)
        helpfile = ['Options Help' char(10) char(10)];
        helpfile = [helpfile 'Seed      : number for the initialization of random processes' char(10)];
        helpfile = [helpfile 'Iterations: number of iteration points' char(10)];
        helpfile = [helpfile 'parameter : the parameter that is changing on every iteration' char(10)];
        helpfile = [helpfile 'Status?   : print experiment''s status? (exported script)' char(10)];
        helpfile = [helpfile 'Invert?   : relabel the the nodes of the graph?' char(10)];
        helpfile = [helpfile 'Errors?   : ignore function errors?' char(10)];
        helpfile = [helpfile 'Figtitle  : the title of the figure' char(10)];
        helpfile = [helpfile 'Figtype   : type of the figure lines: b-x,r-o' char(10)];
        helpfile = [helpfile 'Figxlabel : the label of the x-axis' char(10)];
        helpfile = [helpfile 'Figylabel : the label of the y-axis' char(10)];
        helpfile = [helpfile 'Figlegend : the legend of the figure' char(10)];
        
        print_msg(helpfile,lTxt.msg,lTxt.slider,0);

        movegui(Fig.opt,'center');              
        set(Fig.opt,'Visible','on');                     
    end

    function export_script_callback(~,~)
        %EXPORT_SCRIPT_CALLBACK creates an executable script with the
        %experiment  
        
        %Specify the file
        cd('./Experiments');
        [file,path] = uiputfile('ClustExp.m','Export Script');
        cd('..');
        [name ext]  = fileparts(file);
        
        Param.Opt.filename = [path file];
        Param.Opt.figname =  [path name 'Fig' ext];
        
        %Export it
        make(Param.Grf,Param.Alg,Param.Cln,Param.Eva,Param.Opt,Param.Var);
    end   
     
    function export_figure_callback(~,~)
        %EXPORT_FIGURE_CALLBACK opens a new figure and copies there the
        %contents of the Preview axes. From there we can edit, save the
        %figure the way we want.       
        
        %create a new figure
        Ax.fig = figure;
        
        %copy the old plot
        copyobj(Ax.Preview,Ax.fig);
        
        %the legend (if one exists) won't be copied
        if isfield(Ax,'legend')
            copyobj(Ax.legend,Ax.fig);
        end
    end

    function default_callback(~,~)
    %DEFAULT_CALLBACK changed the options back to default
      
        %set default values
        Param.Opt.seed     = num2str(seed);
        Param.Opt.iters    = '10';
        Param.Opt.parameter = '0:0.1:1';
        Param.Opt.figtitle = 'Clustering Experiment';

        Param.Opt.figxlabel = '';
        Param.Opt.figylabel = '';
        Param.Opt.figlegend = '';
        Param.Opt.figtype   = '';
        Param.Opt.status    = 'on';
        Param.Opt.invert    = 'off';
        Param.Opt.errors    = 'off';
    end

    function run_callback(handle,~)
        %RUN_CALLBACK executes the experiment from the GUI and prints the
        %figure in the Preview axes

        %%Function to check if a name is in the variable cell
        function a = isvar(val,Var)
             a = any(cell2mat(cellfun(@(x) (strcmp(x{1},val)),Var,'UniformOutput',false)));
        end
        
        try
            %disable run and reseed buttons
            set(handle,'Enable','off');
            set(Button.reseed,'Enable','off');

            %%Default Paramaters
            nAlg       = 1;
            graph      = '';
            algorithm  = '';
            evaluation = '';
            clust_num  = '';
            parameter  = 0:0.1:1;
            iters      = 10;
            status     = 0;
            invert     = 0;
            savefig    = 1;
            errors     = 0;
            figtitle   = 'Clustering Experiment';
            figlegend  = {''};
            figtype    = {''};
            figxlabel  = '';
            figylabel  = '';


            %%Check Parameters

            %graph Parameters
            if isfield(Param.Grf,'name')
                graph = Param.Grf.name;
            else
                print_msg('Error: Graph function not specified.',Txt.msg,Txt.slider);

                %enable run and reseed buttons
                set(handle,'Enable','on');
                set(Button.reseed,'Enable','on');
                return;
            end

            if ~ischar(graph) || isempty(graph)
                error('[Param.Grf.name] must be a non-empty string.');
            end

            if isfield(Param.Grf,'par')
                if ischar(Param.Grf.par)
                    %warning('Converting [Grf.par] to cell.');
                    Param.Grf.par = {Param.Grf.par};
                end
            end

            %algorithm parameters
            if isfield(Param.Alg,'name')
                algorithm = Param.Alg.name;
            else
                print_msg('Error: Algorithm function not specified.',Txt.msg,Txt.slider);

                %enable run and reseed buttons
                set(handle,'Enable','on');
                set(Button.reseed,'Enable','on');
                return;
            end

            if iscell(algorithm)
                nAlg = length(algorithm);
            elseif ischar(algorithm)
                algorithm = {algorithm};
            else
                error('[Param.Alg.name] must be a string or a cell of strings.');
            end

            if isfield(Param.Alg,'par')
                if length(Param.Alg.par) ~= nAlg
                    error('The number of algorithm parameters does not match the number of algorithms.');
                end
                %search for the "Graph" parameter
                for i = 1:nAlg
                    if isempty(find(not(cellfun('isempty',strfind(Param.Alg.par{i},'A'))), 1))
                        print_msg(['Error: No "A" parameter for Algorithm: ',num2str(i),'. ',algorithm{i},'.'],Txt.msg,Txt.slider);

                        %enable run and reseed buttons
                        set(handle,'Enable','on');
                        set(Button.reseed,'Enable','on');
                        return;
                    end
                end
            else
                print_msg('Warning: No parameters for the algorithm(s). Using default: "A".',Txt.msg,Txt.slider);
                for i = 1:nAlg
                    Param.Alg.par{i} = 'A';
                end
            end

            %cluster number selection parameters
            if isfield(Param.Cln,'name')
                clust_num = Param.Cln.name;
            else
                print_msg('Error: Cluster Number Selection function not specified.',Txt.msg,Txt.slider);

                %enable run and reseed buttons
                set(handle,'Enable','on');
                set(Button.reseed,'Enable','on');
                return;
            end

            if ~ischar(clust_num) || isempty(clust_num)
                error('[Param.Cln.name] must be a string.');
            end

            if isfield(Param.Cln,'par')
                if ischar(Param.Cln.par)
                    %warning('Converting [Cln.par] to cell.');
                    Param.Cln.par = {Param.Cln.par};
                end
            end

            %evaluation parameters
            if isfield(Param.Eva,'name')
                evaluation = Param.Eva.name;
            else
                print_msg('Error: Evaluation function not specified.',Txt.msg,Txt.slider);

                %enable run and reseed buttons
                set(handle,'Enable','on');
                set(Button.reseed,'Enable','on');
                return;
            end

            if ~ischar(evaluation) || isempty(evaluation)
                error('[Param.Eva.name] must be a string.');
            end

            if isfield(Param.Eva,'par')
                if ischar(Param.Eva.par)
                    %warning('Converting [Param.Eva.par] to cell.');
                    Param.Eva.par = {Param.Eva.par};
                end
            end

            %option parameters
            if ~isempty(Param.Opt)   
                if isfield(Param.Opt,'seed')
                    seed = str2num(Param.Opt.seed);
                end

                if isfield(Param.Opt,'iters')
                    if ischar(Param.Opt.iters)
                        Param.Opt.iters = str2num(Param.Opt.iters);
                    end
                    %check if Param.Opt.iters is a double
                    iters_tmp = floor(Param.Opt.iters / 1);
                    if iters_tmp == Param.Opt.iters
                        iters = Param.Opt.iters;
                    else
                        print_msg(['Warning: Setting "iterations" to: ',iters_tmp],Txt.msg,Txt.slider);
                        iters = iters_tmp;
                    end
                end

                if isfield(Param.Opt,'parameter')
                    parameter = eval(Param.Opt.parameter);
                end

                if isfield(Param.Opt,'invert')
                    if strcmp(Param.Opt.invert,'on')
                        invert = 1;
                    elseif strcmp(Param.Opt.invert,'off')
                        invert = 0;
                    else
                        %print_msg('Using default "invert": off.',Txt.msg,Txt.slider);
                    end
                end

                if isfield(Param.Opt,'errors')
                    if strcmp(Param.Opt.errors,'on')
                        errors = 1;
                    elseif strcmp(Param.Opt.errors,'off')
                        errors = 0;
                    else
                        %print_msg('Using default "errors": off.',Txt.msg,Txt.slider);
                    end
                end

                if isfield(Param.Opt,'savefig')
                    if strcmp(Param.Opt.savefig,'on')
                        savefig = 1;
                    elseif strcmp(Param.Opt.savefig,'off')
                        savefig = 0;
                    else
                        %print_msg('Using default "savefig": on.',Txt.msg,Txt.slider);
                    end
                end


                if isfield(Param.Opt,'figtype')
                    if iscell(Param.Opt.figtype)
                        if length(Param.Opt.figtype) == nAlg
                            figtype = Param.Opt.figtype;
                        else
                            %default option
                            figtype = cell(1,nAlg);
                            col     = 'bgrcmykw';
                            symb    = 'ox+*sdv^<>ph';
                            
                            for i = 1:nAlg
                                figtype{i} = [col(mod(i,length(col))) '-' symb(mod(i,length(symb)))];
                            end

                        end
                    elseif ischar(Param.Opt.figtype)          
                        %find the comma positions
                        cms = strfind(Param.Opt.figtype,',');
                        cms = [0 cms];

                        %calculate the number of cells needed
                        tmp = cell(length(cms),1);

                        %set the cell values
                        for i = 1:length(cms)-1
                            tmp{i} = Param.Opt.figtype(cms(i)+1:cms(i+1)-1);
                        end
                        tmp{end} = Param.Opt.figtype(cms(end)+1:end);

                        if length(tmp) == nAlg
                            figtype = tmp;
                        else
                            %default option
                           figtype = cell(1,nAlg);
                            col     = 'kbgrcmy';
                            symb    = 'ox+*sdv^<>ph';
                            
                            for i = 1:nAlg
                                figtype{i} = [col(mod(i,length(col))+1) '-' symb(mod(i,length(symb)))];
                            end
                        end

                    else
                        %default option
                         figtype = cell(1,nAlg);
                         col     = 'bgrcmykw';
                         symb    = 'ox+*sdv^<>ph';
                          
                         for i = 1:nAlg
                             figtype{i} = [col(mod(i,length(col))) '-' symb(mod(i,length(symb)))];
                         end
                    end
                end

                if isfield(Param.Opt,'figtitle')
                    if ischar(Param.Opt.figtitle)
                        figtitle = Param.Opt.figtitle;
                    else
                        print_msg(['Warning: Figtitle must be a string. Using default: ',figtitle]);
                    end
                end

                if isfield(Param.Opt,'figxlabel')
                    if ischar(Param.Opt.figxlabel)
                        figxlabel = Param.Opt.figxlabel;
                    else
                        print_msg('Warning: Figxlabel must be a string. Using default: none',Txt.msg,Txt.slider);
                    end
                end

                if isfield(Param.Opt,'figylabel')
                    if ischar(Param.Opt.figylabel)
                        figylabel = Param.Opt.figylabel;
                    else
                        print_msg('Warning: Figylabel must be a string. Using default: none',Txt.msg,Txt.slider);
                    end
                end

                if isfield(Param.Opt,'figlegend')
                    if iscell(Param.Opt.figlegend)
                        figlegend = Param.Opt.figlegend;
                    elseif ischar(Param.Opt.figlegend)
                        figlegend = {Param.Opt.figlegend};
                    else
                        print_msg('Warning: Figlegend must be a string or a cell of strings. Using default: automatic',Txt.msg,Txt.slider);
                    end
                end


            end

            %variable parameters
            vars = 1;
            if ~isempty(Param.Var)
                %Check if Var is of proper format. That is:
                %{ {1x2 cell} {1x2 cell} ... }
                if  not(all(eq(cellfun('length',Param.Var),2)))
                    vars = 0;
                    print_msg('Warning: "Variable Parameter" is not of proper format. No variables are used.',Txt.msg,Txt.slider);
                else
                    %if there is a non-string argument
                    if any(cell2mat(cellfun(@(x) cellfun(@ischar,x),Param.Var,'UniformOutput',false))==0)
                        vars = 0;
                        warning('[Warning: "Variable Parameter" should contain only strings. No variables are used.');
                    end
                end
            else
                vars = 0;
            end

            %%Calculate the user variables
            if vars
                %copy the variables
                Vars = Param.Var;

                %evaluate the variable values
                for i = 1:length(Vars)
                    if ~isempty(Vars{i}{2})
                        Vars{i}{2} = eval(Vars{i}{2});
                    else
                        Vars{i}{2} = [];
                    end
                end
                
            else
                %no variables - empty cell array
                Vars = cell(1,0);
            end

            %%Prepare the function strings

            %create graph
            fun.grf = [graph '('];
            for i = 1:(length(Param.Grf.par)-1)
                  d = strfind(Param.Grf.par{i},'parameter');
                  if ~isempty(d)
                     for k = d
                         tmp = [Param.Grf.par{i}(1:(k+8)), '(i)',Param.Grf.par{i}((k+9):end)];
                     end
                     fun.grf = [fun.grf tmp ','];
                  else
                      if ~isvar(Param.Grf.par{i},Vars)
                          fun.grf = [fun.grf Param.Grf.par{i} ','];
                      else
                          fun.grf = [fun.grf 'Vars{',...
                              num2str(find(cell2mat(cellfun(@(x) (strcmp(x{1},Param.Grf.par{i})),Vars,'UniformOutput',false)),1)) '}{2},'];
                      end
                  end
            end
            d = strfind(Param.Grf.par{end},'parameter');
            if ~isempty(d)
               for k = d
                   tmp = [Param.Grf.par{end}(1:(k+8)), '(i)',Param.Grf.par{end}((k+9):end)];
                end
                fun.grf = [fun.grf tmp ');'];
            else
                if ~isvar(Param.Grf.par{end},Vars)
                    fun.grf = [fun.grf Param.Grf.par{end} ');'];
                else
                    fun.grf = [fun.grf 'Vars{',...
                              num2str(find(cell2mat(cellfun(@(x) (strcmp(x{1},Param.Grf.par{end})),Vars,'UniformOutput',false)),1)) '}{2});'];
                end
             end


            %cluster number selection
            fun.cln = [clust_num,'('];
            for i = 1:(length(Param.Cln.par)-1)
                if ~isvar(Param.Cln.par{i},Vars)
                    fun.cln = [fun.cln Param.Cln.par{i} ','];
                else
                    fun.cln = [fun.cln 'Vars{',...
                              num2str(find(cell2mat(cellfun(@(x) (strcmp(x{1},Param.Cln.par{i})),Vars,'UniformOutput',false)),1)) '}{2},'];
                end
            end
            if ~isvar(Param.Cln.par{end},Vars)
                fun.cln = [fun.cln Param.Cln.par{end} ');'];
            else
                fun.cln = [fun.cln 'Vars{',...
                              num2str(find(cell2mat(cellfun(@(x) (strcmp(x{1},Param.Cln.par{end})),Vars,'UniformOutput',false)),1)) '}{2});'];
            end

            %clustering
            for i = 1:nAlg
                fun.alg{i} = [algorithm{i} '('];
                for j = 1:(length(Param.Alg.par{i})-1)
                    if ~isvar(Param.Alg.par{i}{j},Vars)
                        fun.alg{i} = [fun.alg{i} Param.Alg.par{i}{j} ','];
                    else
                        fun.alg{i} = [fun.alg{i} 'Vars{',...
                              num2str(find(cell2mat(cellfun(@(x) (strcmp(x{1},Param.Alg.par{i}{j})),Vars,'UniformOutput',false)),1)) '}{2},'];
                    end
                end
                if ~isvar(Param.Alg.par{i}{end},Vars)
                    fun.alg{i} = [fun.alg{i} Param.Alg.par{i}{end},');'];
                else
                    fun.alg{i} = [fun.alg{i} 'Vars{',...
                              num2str(find(cell2mat(cellfun(@(x) (strcmp(x{1},Param.Alg.par{i}{end})),Vars,'UniformOutput',false)),1)) '}{2});'];
                end
            end

            %evaluate clustering
            fun.eva = [evaluation '('];
            for j = 1:(length(Param.Eva.par)-1)
                if ~isvar(Param.Eva.par{j},Vars)
                    fun.eva = [fun.eva Param.Eva.par{j} ','];
                else
                    fun.eva = [fun.eva 'Vars{',...
                              num2str(find(cell2mat(cellfun(@(x) (strcmp(x{1},Param.Eva.par{j})),Vars,'UniformOutput',false)),1)) '}{2},'];
                end
            end
            if ~isvar(Param.Eva.par{end},Vars)
                fun.eva = [fun.eva Param.Eva.par{end} ');'];
            else
                fun.eva = [fun.eva 'Vars{',...
                              num2str(find(cell2mat(cellfun(@(x) (strcmp(x{1},Param.Eva.par{end})),Vars,'UniformOutput',false)),1)) '}{2});'];
            end

            %legend for the plot
            fun.legend = 'legend(';
            for i = 1:(length(figlegend)-1);
                fun.legend = [fun.legend '''' figlegend{i} '''' ','];
            end
            fun.legend = [fun.legend '''' figlegend{end} '''' ');'];

            %%Execute the experiment

            %set random seed
            set_seed(seed);
            
            %clear previous results
            Results = [];

            %store results here
            tmpa = zeros(nAlg,iters);         %temporary
            a    = zeros(nAlg,length(parameter)); %final

            %global variable to plot the adjacency matrix
            i = 1;
            G = eval(fun.grf);

            %experiment status - waitbar
            h = waitbar(0,'Status: 0%','Name','Clustering Experiment...',...
                          'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
            mn_iteration_time = 0; %mean iteration time
            
            %for each parameter point
            for i = 1:length(parameter)
                %for each algorithm
                for k = 1:nAlg
                    %for each iteration on every point
                    for j = 1:iters
                        tic; %start stopwatch
                        
                        %create the graph
                        if isvar('V0',Vars)
                            A = eval(fun.grf);
                        else
                            [A,V0] = eval(fun.grf);
                        end

                        %cluster with algorithm k
                        VV = eval(fun.alg{k});
                        
                        %Get the cluster number
                        CN = eval(fun.cln);
                        
                        %find the best clustering algorithm k returned
                        %(with respect to the cluster number)
                        %VV_size = size(VV);
                        %q = 1; %if q stays 1 => then perfect clustering for each k
                        %for l = 1:VV_size(2)
                        %    if CN == length(unique(VV(:,l)))
                        %        q = l;
                        %        break;
                        %    end
                        %end
                        
                        %V = VV(:,q);
                        V = VV(:,CN);
                        
                        %evaluate clustering
                        tmpa(k,j) = eval(fun.eva);
                        
                        %experiment status
                        % Check for Cancel button press
                        if getappdata(h,'canceling')
                            Results = [];
                            delete(h);
                            set(handle,'Enable','on');
                            set(Button.reseed,'Enable','on');
                            return;
                        end
                        
                        %update waitbar
                        iteration = (i-1)*nAlg*iters+(k-1)*iters+j;
                        overall   = length(parameter)*nAlg*iters;
                                               
                        iteration_time = toc; %stop stopwatch
                        
                        %calculate mean iteration time
                        if iteration == 1
                            mn_iteration_time = iteration_time;
                        else
                            mn_iteration_time = (mn_iteration_time*(overall-iteration-1)+iteration_time)/(overall-iteration);
                        end
                        
                        %calculate remaining time
                        remaining = mn_iteration_time * (overall - iteration);
                        if isnan(remaining)
                            remaining = 0;
                        end
                        [hr mn sec]   = sec2hms(remaining);
                        
                        tm = ' - Remaining: ';
                        if hr ~= 0
                            tm = [tm num2str(hr) ' h '];
                        end
                        if mn ~= 0
                            tm = [tm num2str(mn) ' min '];
                        end
                        tm  = [tm num2str(uint64(sec)) ' sec'];
                        if hr == 0 && mn == 0 && sec < 20
                            tm = '';
                        end
                        
                        waitbar(iteration/overall,h,...
                                    ['Status: ' num2str(floor(iteration/overall*100)) '%' tm]);

                    end
                    %take mean of the results
                    a(k,i) = mean(tmpa(k,:));
                    
                    %save results
                    Results(i,k).A=A;
                    Results(i,k).V0=V0;
                    Results(i,k).V=V;
                    Results(i,k).VV=VV;
                    Results(i,k).CN=CN;
                    Results(i,k).a=a(k,i);
                    
                end  

            end
            
            %close waitbar
            delete(h);

            %plot the results
            if length(figtype) == nAlg
                    for i = 1:nAlg
                        plot(Ax.Preview,parameter,a(i,:),figtype{i}); hold on;
                    end
            else
                  for i = 1:nAlg
                        plot(Ax.Preview,parameter,a(i,:),figtype{1}); hold on;
                  end
            end
            hold off;
            
            %set the axis
            if min(parameter)< max(parameter)
                if min(a(:)) < max(a(:))
                    axis([min(parameter) max(parameter) -0.05 1.05])
                end
            end
            
            %create the grid
            grid(Ax.Preview);

            %plotting options
            title(figtitle);

            %include xlabel?
            if ~isempty(figxlabel)
                xlabel(figxlabel);
            else
                xlabel('parameter');
            end
            %include ylabel?
            if ~isempty(figylabel)
                ylabel(figylabel);
            else
                ylabel(evaluation);
            end
            %include legend?
            if not(length(figlegend) == 1 && isempty(figlegend{1}))
                eval(fun.legend);
            else
                if ~iscell(algorithm)
                    legend(algorithm);
                else
                    legend(algorithm{:});
                end
            end
            
            %Done message
            print_msg('Experiment Completed.',Txt.msg,Txt.slider,0);
            print_msg(['Random Seed: ' num2str(seed)],Txt.msg,Txt.slider,1);
            print_msg('Export Data to save results.',Txt.msg,Txt.slider,1);
            
            
        catch ex
            %print message in MATLAB command line
            disp(['Exception: ' ex.message]);
            disp(['at: ' ex.stack.name]);
            %disp(['line: ' num2str(ex.stack.line{end})]);
            disp('line = '); ex.stack.line
            
            %print message in the gui screen
            print_msg(['Exception: ' ex.message],Txt.msg,Txt.slider);
            
            %enable the run button
            set(handle,'Enable','on');
            set(Button.reseed,'Enable','on');
            
            %close waitbar if the experiment failed
            if exist('h','var')
                if ishandle(h)
                    delete(h);
                end
            end
        end
        
        %enable the run button
        set(handle,'Enable','on');
        set(Button.reseed,'Enable','on');
    end

    function quick_start_callback(~,~)
       winopen('Help/QuickHelp.pdf')  
    end

    function user_manual_callback(~,~)
       winopen('Help/Manual.pdf')  
    end

    function plot_adjacency_callback(~,~)
        
        %callbacks to be used later
        function lnext_i_callback(~,~)
              if i < I
                  i = i + 1;
              else
                  i = 1;
              end
              plot_current();
        end

        function lprevious_i_callback(~,~)
             if i > 1
                 i = i - 1;
             else
                 i = I;
             end
             plot_current(); 
        end
        
        function plot_current()
            pcolor(Results(i,1).A); 
            shading flat;
            title(['The adjacency matrix used at parameter value no.' num2str(i)]);
        end
        
        
        %check if it is there are adjacency matricies available to plot
        if ~isempty(Results)
            
            %l declares local variable

            %%constants
            lPos.Gui      = [0    0   600   600   ]; %pixels (the rest are normalized)

            lPos.Panel1   = [0     0.06    1      0.94]; %panel 1
            lPos.Plot     = [0.045 0.045   0.91   0.91]; 

            lPos.Panel2   = [0     0     1      0.06]; %panel 2
            lPos.previous = [0.3   0     0.2    0.90];
            lPos.next     = [0.5   0     0.2    0.90]; 

            lColor.Gui    = Color.Gui; %warning: Gui_Color is a global variable
            lColor.msg    = Color.msg; %warning: msg_Color is a global variable

            [I ~]=size(Results);
            i = 1;        

            %Main Window
            Fig.adj    = figure    ('MenuBar'           ,'none',...
                                    'Name'              ,'Adjacency Matrices',...
                                    'NumberTitle'       ,'off',...
                                    'Position'          ,lPos.Gui,...
                                    'Resize'            ,'on',...
                                    'Toolbar'           ,'none',...
                                    'Units'             ,'pixels',...
                                    'Color'             ,lColor.Gui,...
                                    'Visible'           ,'off');

            lPanel.adj1= uipanel   ('Parent'             ,Fig.adj,....
                                    'FontSize'           ,10,...
                                    'BackgroundColor'    ,lColor.Gui,...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.Panel1);

            lAx.Plot       = axes    ('Parent'             ,lPanel.adj1,...
                                      'Units'              ,'normalized',...
                                      'XLim'               ,[0 1],...
                                      'YLim'               ,[-0.05 1.05],...
                                      'Position'           ,lPos.Plot); 

            lPanel.adj2= uipanel   ('Parent'             ,Fig.adj,....
                                    'FontSize'           ,10,...
                                    'BackgroundColor'    ,lColor.Gui,...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.Panel2);


            lButton.next = uicontrol ('Parent'           ,lPanel.adj2,...
                                    'Style'              ,'pushbutton',...
                                    'String'             ,'next',...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.next,...
                                    'Callback'           ,@lnext_i_callback);


            lButton.previous = uicontrol ('Parent'       ,lPanel.adj2,...
                                    'Style'              ,'pushbutton',...
                                    'String'             ,'previous',...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.previous,...
                                    'Callback'           ,@lprevious_i_callback);                            

            

            movegui(Fig.adj,'center');              
            set(Fig.adj,'Visible','on');
            
            plot_current();
            
        else
            msgbox('No Adjacency Matrix to plot.');
        end
        
    end

    function plot_graph_callback(~,~)
        
        %callbacks to be used later
        function lnext_i_callback(~,~)
              if i < I
                  i = i + 1;
              else
                  i = 1;
              end
              plot_current();
        end

        function lprevious_i_callback(~,~)
             if i > 1
                 i = i - 1;
             else
                 i = I;
             end
             plot_current(); 
        end
        
        function plot_current()
                
                %clear current axes
                cla(lAx.Plot,'reset');
                
                clr='bgrmcbgrmcbgrmcbgrmcbgrmc';
                clr=[clr clr clr clr clr clr];
                
                [x y N V0 A_new] = PlotGraph_gui(Results(i,1).A,Results(i,1).V);
                for n1=1:N
                     for n2=1:N
                        if A_new(n1,n2)>0
                            line([x(n1) x(n2)],[y(n1) y(n2)],'Color','k','LineStyle','-','LineWidth',1.5); hold on;
                        end
                     end
                end
                
                for n=1:N
                    plot(x(n),y(n),['ko'],'LineWidth',5,'MarkerSize',12);  hold on;
                    plot(x(n),y(n),[clr(V0(n)) '*'],'LineWidth',5,'MarkerSize',12);  hold on;
                end
                axis off; hold off;
                
                title(['The graph used at parameter value no.' num2str(i)]);
            
        end
        
        
        %check if it is there are adjacency matricies available to plot
        if ~isempty(Results)
            
            %l declares local variable

            %%constants
            lPos.Gui      = [0    0   600   600   ]; %pixels (the rest are normalized)

            lPos.Panel1   = [0     0.06    1      0.94]; %panel 1
            lPos.Plot     = [0.045 0.045   0.91   0.91]; 

            lPos.Panel2   = [0     0     1      0.06]; %panel 2
            lPos.previous = [0.3   0     0.2    0.90];
            lPos.next     = [0.5   0     0.2    0.90]; 

            lColor.Gui    = Color.Gui; %warning: Gui_Color is a global variable
            lColor.msg    = Color.msg; %warning: msg_Color is a global variable

            [I ~]=size(Results);
            i = 1;        


            %Main Window
            Fig.gra    = figure    ('MenuBar'           ,'none',...
                                    'Name'              ,'Graph',...
                                    'NumberTitle'       ,'off',...
                                    'Position'          ,lPos.Gui,...
                                    'Resize'            ,'on',...
                                    'Toolbar'           ,'none',...
                                    'Units'             ,'pixels',...
                                    'Color'             ,lColor.Gui,...
                                    'Visible'           ,'off');

            lPanel.gra1= uipanel   ('Parent'             ,Fig.gra,....
                                    'FontSize'           ,10,...
                                    'BackgroundColor'    ,lColor.Gui,...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.Panel1);

            lAx.Plot       = axes    ('Parent'             ,lPanel.gra1,...
                                      'Units'              ,'normalized',...
                                      'Position'           ,lPos.Plot); 

            lPanel.gra2= uipanel   ('Parent'             ,Fig.gra,....
                                    'FontSize'           ,10,...
                                    'BackgroundColor'    ,lColor.Gui,...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.Panel2);


            lButton.next = uicontrol ('Parent'           ,lPanel.gra2,...
                                    'Style'              ,'pushbutton',...
                                    'String'             ,'next',...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.next,...
                                    'Callback'           ,@lnext_i_callback);


            lButton.previous = uicontrol ('Parent'       ,lPanel.gra2,...
                                    'Style'              ,'pushbutton',...
                                    'String'             ,'previous',...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.previous,...
                                    'Callback'           ,@lprevious_i_callback);                            

            

            movegui(Fig.gra,'center');              
            set(Fig.gra,'Visible','on');
            
            plot_current();
            
        else
            msgbox('No Graph to plot.');
        end
        
    end

    function plot_best_partition_callback(~,~)
        
        %callbacks to be used later
        function lnext_i_callback(~,~)
              if j < J
                  j = j + 1;
              else
                  j = 1;
                  
                  if i < I
                      i = i + 1;
                  else
                      i = 1;
                  end
                  
              end
              plot_current();
        end

        function lprevious_i_callback(~,~)
             if j > 1
                 j = j - 1;
             else
                 j = J;
                 
                 if i > 1
                     i = i - 1;
                 else
                     i = I;
                 end
                 
             end
             plot_current(); 
        end
        
        function plot_current()
              plot(parameter,Results(i,j).V0,'b-o',parameter,Results(i,j).V,'r-*'); 
              legend('True Partition','Best Partition','Location','NorthEastOutside');
              title(['Obtained at parameter value no.' num2str(i) ' by algorithm no.' num2str(j)]);
        end
        
        
        %check if it is there are adjacency matricies available to plot
        if ~isempty(Results)
            
            %l declares local variable

            %%constants
            lPos.Gui      = [0    0   600   600   ]; %pixels (the rest are normalized)

            lPos.Panel1   = [0     0.06    1      0.94]; %panel 1
            lPos.Plot     = [0.045 0.045   0.91   0.91]; 

            lPos.Panel2   = [0     0     1      0.06]; %panel 2
            lPos.previous = [0.3   0     0.2    0.90];
            lPos.next     = [0.5   0     0.2    0.90]; 

            lColor.Gui    = Color.Gui; %warning: Gui_Color is a global variable
            lColor.msg    = Color.msg; %warning: msg_Color is a global variable

            i = 1; 
            j = 1;
            
            [I J]=size(Results);
            parameter=[1:length(Results(1,1).V0)];
            
            %Main Window
            Fig.pbp    = figure    ('MenuBar'           ,'none',...
                                    'Name'              ,'Best Partition',...
                                    'NumberTitle'       ,'off',...
                                    'Position'          ,lPos.Gui,...
                                    'Resize'            ,'on',...
                                    'Toolbar'           ,'none',...
                                    'Units'             ,'pixels',...
                                    'Color'             ,lColor.Gui,...
                                    'Visible'           ,'off');

            lPanel.pbp1= uipanel   ('Parent'             ,Fig.pbp,....
                                    'FontSize'           ,10,...
                                    'BackgroundColor'    ,lColor.Gui,...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.Panel1);

            lAx.Plot       = axes    ('Parent'             ,lPanel.pbp1,...
                                      'Units'              ,'normalized',...
                                      'XLim'               ,[0 1],...
                                      'YLim'               ,[-0.05 1.05],...
                                      'Position'           ,lPos.Plot); 

            lPanel.pbp2 = uipanel   ('Parent'            ,Fig.pbp,....
                                    'FontSize'           ,10,...
                                    'BackgroundColor'    ,lColor.Gui,...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.Panel2);


            lButton.next = uicontrol ('Parent'           ,lPanel.pbp2,...
                                    'Style'              ,'pushbutton',...
                                    'String'             ,'next',...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.next,...
                                    'Callback'           ,@lnext_i_callback);


            lButton.previous = uicontrol ('Parent'       ,lPanel.pbp2,...
                                    'Style'              ,'pushbutton',...
                                    'String'             ,'previous',...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.previous,...
                                    'Callback'           ,@lprevious_i_callback);                            

            

            movegui(Fig.pbp,'center');              
            set(Fig.pbp,'Visible','on');
            
            plot_current();
            
        else
            msgbox('No Partition to plot.');
        end
        
    end

    function plot_all_partitions_callback(~,~)
   
        %callbacks to be used later
        function lnext_i_callback(~,~)
              if j < J
                  j = j + 1;
              else
                  j = 1;
                  
                  if i < I
                      i = i + 1;
                  else
                      i = 1;
                  end
                  
              end
              plot_current();
        end

        function lprevious_i_callback(~,~)
             if j > 1
                 j = j - 1;
             else
                 j = J;
                 
                 if i > 1
                     i = i - 1;
                 else
                     i = I;
                 end
                 
             end
             plot_current(); 
        end
        
        function plot_current()
              plot(Results(i,j).VV); 
              title(['All partitions obtained by algorithm no.' num2str(j) ' at parameter value no.' num2str(i)]);
        end
        
        
        %check if it is there are adjacency matricies available to plot
        if ~isempty(Results)
            
            %l declares local variable

            %%constants
            lPos.Gui      = [0    0   600   600   ]; %pixels (the rest are normalized)

            lPos.Panel1   = [0     0.06    1      0.94]; %panel 1
            lPos.Plot     = [0.045 0.045   0.91   0.91]; 

            lPos.Panel2   = [0     0     1      0.06]; %panel 2
            lPos.previous = [0.3   0     0.2    0.90];
            lPos.next     = [0.5   0     0.2    0.90]; 

            lColor.Gui    = Color.Gui; %warning: Gui_Color is a global variable
            lColor.msg    = Color.msg; %warning: msg_Color is a global variable

            i = 1; 
            j = 1;
            
            [I J]=size(Results);
                        
            %Main Window
            Fig.pap    = figure    ('MenuBar'           ,'none',...
                                    'Name'              ,'All Partitions',...
                                    'NumberTitle'       ,'off',...
                                    'Position'          ,lPos.Gui,...
                                    'Resize'            ,'on',...
                                    'Toolbar'           ,'none',...
                                    'Units'             ,'pixels',...
                                    'Color'             ,lColor.Gui,...
                                    'Visible'           ,'off');

            lPanel.pap1= uipanel   ('Parent'             ,Fig.pap,....
                                    'FontSize'           ,10,...
                                    'BackgroundColor'    ,lColor.Gui,...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.Panel1);

            lAx.Plot       = axes    ('Parent'             ,lPanel.pap1,...
                                      'Units'              ,'normalized',...
                                      'XLim'               ,[0 1],...
                                      'YLim'               ,[-0.05 1.05],...
                                      'Position'           ,lPos.Plot); 

            lPanel.pap2 = uipanel   ('Parent'            ,Fig.pap,....
                                    'FontSize'           ,10,...
                                    'BackgroundColor'    ,lColor.Gui,...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.Panel2);


            lButton.next = uicontrol ('Parent'           ,lPanel.pap2,...
                                    'Style'              ,'pushbutton',...
                                    'String'             ,'next',...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.next,...
                                    'Callback'           ,@lnext_i_callback);


            lButton.previous = uicontrol ('Parent'       ,lPanel.pap2,...
                                    'Style'              ,'pushbutton',...
                                    'String'             ,'previous',...
                                    'Units'              ,'normalized',...
                                    'Position'           ,lPos.previous,...
                                    'Callback'           ,@lprevious_i_callback);                            

            

            movegui(Fig.pap,'center');              
            set(Fig.pap,'Visible','on');
            
            plot_current();
            
        else
            msgbox('No Partition to plot.');
        end
        
    end

    function results_to_cli_callback(~,~)
        %RESULTS_TO_CLI_CALLBACK assigns the result struct to the MATLAB
        %working environment
        
        if ~isempty(Results)
           assignin('base','Results',Results);
           print_msg('Results loaded to Command Line.',Txt.msg,Txt.slider,0);
        else
            msgbox('No Results to load.');
        end
    end

%%GUI Activation commands
default_callback([],[]);
movegui(Fig.main,'center');
set(Fig.main,'Visible','on');                
end