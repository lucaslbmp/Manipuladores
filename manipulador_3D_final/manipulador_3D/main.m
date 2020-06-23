%Integrantes:
%Lucas Barboza Moreira Pinheiro - RA: 11017015
%Gilmar Correia Jerônimo 
%Ana Laura Belotto Claudio

function varargout=gui(varargin)
% mfile generated on 19-Apr-2019 20:32:40.
% note that many of the hard-coded values should be replaced with calls to default_settings.m.

% Do input processing here...The following is just an example
filename='';
if ~nargin

%	[filename,root]=uigetfile('*.bin','Select Input BIN File',['default_dir',filesep]);
%	if isnumeric(filename)
%		fprintf('Selection cancelled by user.\n');
%		return;
%	end

elseif nargin==1

%	[root,filename,ext]=fileparts(varargin{1});
%	filename=[filename,ext];
%	clear ext;

else

end

clc;

handles=render_gui('gui.fig',filename);
activate_callbacks();

i=1;
qJ1=[0];
qJ2=[0];
qJ3=[0];
a=[str2double(handles.a1.String) str2double(handles.a2.String) str2double(handles.a3.String)];
alpha=[str2double(handles.alpha1.String) str2double(handles.alpha2.String) str2double(handles.alpha3.String)]*pi/180;
d_cte=[str2double(handles.d1_cte.String) str2double(handles.d2_cte.String) str2double(handles.d3_cte.String)];
theta_cte=[str2double(handles.th1_cte.String) str2double(handles.th2_cte.String) str2double(handles.th3_cte.String)]*pi/180;
d=d_cte;
theta=theta_cte;
a_handles=[handles.a1 handles.a2 handles.a3];
alpha_handles=[handles.alpha1 handles.alpha2 handles.alpha3];
d_cte_handles=[handles.d1_cte handles.d2_cte handles.d3_cte];
theta_cte_handles=[handles.th1_cte handles.th2_cte handles.th3_cte];
tipoRot_handles=[handles.tipo_j1 handles.tipo_j2 handles.tipo_j3];
lim=8.4;
tipoRot=[0 0 0];
set(handles.q1,'Enable','off');
set(handles.q2,'Enable','off');
set(handles.q3,'Enable','off');
set(handles.q1_disp,'Enable','off');
set(handles.q2_disp,'Enable','off');
set(handles.q3_disp,'Enable','off');
set(handles.add_pt,'Enable','off');
set(handles.rem_pt,'Enable','off');
set(handles.sim_btn,'Enable','off');
set(handles.x1,'Enable','off');
set(handles.x2,'Enable','off');
set(handles.x3,'Enable','off');
set(handles.x4,'Enable','off');
set(handles.x5,'Enable','off');
set(handles.y1,'Enable','off');
set(handles.y2,'Enable','off');
set(handles.y3,'Enable','off');
set(handles.y4,'Enable','off');
set(handles.y5,'Enable','off');
set(handles.z1,'Enable','off');
set(handles.z2,'Enable','off');
set(handles.z3,'Enable','off');
set(handles.z4,'Enable','off');
set(handles.z5,'Enable','off');



set(handles.fig,'visible','on');

% callbacks
    function x1(varargin)

	end
	function y1(varargin)

	end
	function z1(varargin)

	end
	function x2(varargin)

	end
	function y2(varargin)

	end
	function z2(varargin)

	end
	function x3(varargin)

	end
	function y3(varargin)

	end
	function z3(varargin)

	end
	function x4(varargin)

	end
	function y4(varargin)

	end
	function z4(varargin)

	end
	function x5(varargin)

	end
	function y5(varargin)

	end
	function z5(varargin)

	end

	function exemplo3(varargin)
        a=[0 3 0];
        alpha=[90 -90 0]*pi/180;
        d_cte=[2 0 2];
        theta_cte=[0 0 0]*pi/180;
        tipoRot=[1 1 0];
        for j=1:3
           set(a_handles(j),'String',a(j)); 
           set(alpha_handles(j),'String',alpha(j)*180/pi);
           set(d_cte_handles(j),'String',d_cte(j));
           set(theta_cte_handles(j),'String',theta_cte(j)*180/pi);
           set(tipoRot_handles(j),'Value',1.+tipoRot(j));
        end
        d=d_cte;
        theta=theta_cte;
        coord=cinematica(a,alpha,d,theta); 
        Robo_plot(coord,lim,length(a));
	end
	function exemplo2(varargin)
        a=[0 2 3];
        alpha=[0 90 -90]*pi/180;
        d_cte=[2 0 0];
        theta_cte=[0 0 90]*pi/180;
        tipoRot=[0 1 1];
        d=d_cte;
        theta=theta_cte;
        for j=1:3
           set(a_handles(j),'String',a(j)); 
           set(alpha_handles(j),'String',alpha(j)*180/pi);
           set(d_cte_handles(j),'String',d_cte(j));
           set(theta_cte_handles(j),'String',theta_cte(j)*180/pi);
           set(tipoRot_handles(j),'Value',1.+tipoRot(j));
        end
        coord=cinematica(a,alpha,d,theta); 
        Robo_plot(coord,lim,length(a));
	end
	function exemplo1(varargin)
        a=[0 0 0];
        alpha=[-90 0 0]*pi/180;
        d_cte=[3 2 1];
        theta_cte=[-90 0 0]*pi/180;
        tipoRot=[0 0 0];
        for j=1:3
           set(a_handles(j),'String',a(j)); 
           set(alpha_handles(j),'String',alpha(j)*180/pi);
           set(d_cte_handles(j),'String',d_cte(j));
           set(theta_cte_handles(j),'String',theta_cte(j)*180/pi);
           set(tipoRot_handles(j),'Value',1.+tipoRot(j));
        end
        d=d_cte;
        theta=theta_cte;
        coord=cinematica(a,alpha,d,theta); 
        Robo_plot(coord,lim,length(a));
	end
	function sim_btn(varargin)
        %disp(tipoRot);
        set(handles.q1,'Enable','off');
        set(handles.q2,'Enable','off');
        set(handles.q3,'Enable','off');
        set(handles.q1_disp,'Enable','off');
        set(handles.q2_disp,'Enable','off');
        set(handles.q3_disp,'Enable','off')
        set(handles.add_pt,'Enable','off');
        set(handles.rem_pt,'Enable','off');
        set(handles.sim_btn,'Enable','off');
        desenhaTraj(a,alpha,d,theta,qJ1,qJ2,qJ3,tipoRot);
	end
	function rem_pt(varargin)
        coord_handles=[handles.x1 handles.y1 handles.z1;handles.x2 handles.y2 handles.z2;handles.x3 handles.y3 handles.z3;handles.x4 handles.y4 handles.z4;handles.x5 handles.y5 handles.z5];
        if i>1
           i=i-1; 
           qJ1(i)=[];
            qJ2(i)=[];
            qJ3(i)=[];
        end
        
        for j=1:3
            set(coord_handles(i,j),'Enable','off');
            set(coord_handles(i,j),'String',num2str(0));
        end
        if i<=2
           set(handles.sim_btn,'Enable','off');
        end
        if i<=5
            set(handles.add_pt,'Enable','on');
        end 
        
	end
	function add_pt(varargin)
        qJ1(i)=d(1).*(~tipoRot(1))+(theta(1).*(tipoRot(1)));
        qJ2(i)=d(2).*(~tipoRot(2))+(theta(2).*(tipoRot(2)));
        qJ3(i)=d(3).*(~tipoRot(3))+(theta(3).*(tipoRot(3)));
        coord=cinematica(a,alpha,d,theta);
        coord_handles=[handles.x1 handles.y1 handles.z1;handles.x2 handles.y2 handles.z2;handles.x3 handles.y3 handles.z3;handles.x4 handles.y4 handles.z4;handles.x5 handles.y5 handles.z5];
        for j=1:3
            set(coord_handles(i,j),'Enable','on');
            set(coord_handles(i,j),'String',num2str(coord(length(a)+1,j)));
        end 
        if i>=2
           set(handles.sim_btn,'Enable','on');
        end
        if i>=5
            set(handles.add_pt,'Enable','off');
        end 
        i=i+1;
	end
	function q3(varargin)
        d(3)=d_cte(3)+handles.q3.Value*1.5.*(~tipoRot(3));
        theta(3)=theta_cte(3)+handles.q3.Value*(pi).*(tipoRot(3));
        set(handles.q3_disp,'String',num2str(d(3).*(~tipoRot(3))+(theta(3).*(tipoRot(3)))*180/pi));
        coord=cinematica(a,alpha,d,theta); 
        Robo_plot(coord,lim,length(a));
	end
	function q3_disp(varargin)
       
	end
	function q2(varargin)
        d(2)=d_cte(2)+handles.q2.Value*1.5.*(~tipoRot(2));
        theta(2)=theta_cte(2)+handles.q2.Value*(pi).*(tipoRot(2));
        set(handles.q2_disp,'String',num2str(d(2).*(~tipoRot(2))+(theta(2).*(tipoRot(2)))*180/pi))
        coord=cinematica(a,alpha,d,theta); 
        Robo_plot(coord,lim,length(a));
	end
	function q2_disp(varargin)

	end
	function q1_disp(varargin)

	end
	function q1(varargin)
        d(1)=d_cte(1)+handles.q1.Value*1.5.*(~tipoRot(1));
        theta(1)=theta_cte(1)+handles.q1.Value*(pi).*(tipoRot(1));
        set(handles.q1_disp,'String',num2str(d(1).*(~tipoRot(1))+(theta(1).*(tipoRot(1)))*180/pi))
        coord=cinematica(a,alpha,d,theta); 
        Robo_plot(coord,lim,length(a));
	end
	function tipo_j3(varargin)
        contents=cellstr(handles.tipo_j3.String);
        pop_choice=contents(handles.tipo_j3.Value);
        if strcmp(pop_choice,'prismática')
            tipoRot(3)=false;
            set(handles.a3,'String','0');
        elseif strcmp(pop_choice,'rotativa')
            tipoRot(3)=true;
        end
	end
	function tipo_j2(varargin)
        contents=cellstr(handles.tipo_j2.String);
        pop_choice=contents(handles.tipo_j2.Value);
        if strcmp(pop_choice,'prismática')
            tipoRot(2)=false;
            set(handles.a2,'String','0');
        elseif strcmp(pop_choice,'rotativa')
            tipoRot(2)=true;
        end
	end
	function tipo_j1(varargin)
        contents=cellstr(handles.tipo_j1.String);
        pop_choice=contents(handles.tipo_j1.Value);
        if strcmp(pop_choice,'prismática')
            tipoRot(1)=false;
            set(handles.a1,'String','0');
        elseif strcmp(pop_choice,'rotativa')
            tipoRot(1)=true;
        end
        %disp(tipoRot);
	end
	function th3_cte(varargin)
        theta_cte(3)=str2double(handles.th3_cte.String)*pi/180;
        coord=cinematica(a,alpha,d_cte,theta_cte); 
        Robo_plot(coord,lim,length(a));
	end
	function th2_cte(varargin)
        theta_cte(2)=str2double(handles.th2_cte.String)*pi/180;
        coord=cinematica(a,alpha,d_cte,theta_cte);  
        Robo_plot(coord,lim,length(a));
	end
	function th1_cte(varargin)
        theta_cte(1)=str2double(handles.th1_cte.String)*pi/180;
        coord=cinematica(a,alpha,d_cte,theta_cte); 
        Robo_plot(coord,lim,length(a));
	end
	function d3_cte(varargin)
        d_cte(3)=str2double(handles.d3_cte.String);
        set(handles.a3,'String','0');
        a(3)=str2double(handles.a3.String);
        coord=cinematica(a,alpha,d_cte,theta_cte); 
        Robo_plot(coord,lim,length(a));
	end
	function d2_cte(varargin)
        d_cte(2)=str2double(handles.d2_cte.String);
        set(handles.a2,'String','0');
        a(2)=str2double(handles.a2.String);
        coord=cinematica(a,alpha,d_cte,theta_cte); 
        Robo_plot(coord,lim,length(a));
	end
	function d1_cte(varargin)
        d_cte(1)=str2double(handles.d1_cte.String); 
        set(handles.a1,'String','0');
        a(1)=str2double(handles.a1.String);
        coord=cinematica(a,alpha,d_cte,theta_cte); 
        Robo_plot(coord,lim,length(a));
       
	end
	function alpha3(varargin)
        alpha(3)=str2double(handles.alpha3.String)*pi/180;
        coord=cinematica(a,alpha,d_cte,theta_cte); 
        Robo_plot(coord,lim,length(a));
	end
	function alpha2(varargin)
        alpha(2)=str2double(handles.alpha2.String)*pi/180;
        coord=cinematica(a,alpha,d_cte,theta_cte); 
        Robo_plot(coord,lim,length(a));
	end
	function alpha1(varargin)
        alpha(1)=str2double(handles.alpha1.String)*pi/180;
        coord=cinematica(a,alpha,d_cte,theta_cte); 
        Robo_plot(coord,lim,length(a));
	end
	function a3(varargin)
        a(3)=str2double(handles.a3.String);
        set(handles.d3_cte,'String',0);
        d_cte(3)=str2double(handles.d3_cte.String); 
        coord=cinematica(a,alpha,d_cte,theta_cte); 
        Robo_plot(coord,lim,length(a));
	end
	function a2(varargin)
        a(2)=str2double(handles.a2.String);
        set(handles.d2_cte,'String',0);
        d_cte(2)=str2double(handles.d2_cte.String); 
        coord=cinematica(a,alpha,d_cte,theta_cte); 
        Robo_plot(coord,lim,length(a));
	end
	function a1(varargin)
        a(1)=str2double(handles.a1.String);
        set(handles.d1_cte,'String',0);
        d_cte(1)=str2double(handles.d1_cte.String); 
        coord=cinematica(a,alpha,d_cte,theta_cte); 
        Robo_plot(coord,lim,length(a));
        
	end
	function ok_btn(varargin)
          set(handles.a1,'Enable','off');
          set(handles.a2,'Enable','off');
          set(handles.a3,'Enable','off');
          set(handles.alpha1,'Enable','off');
          set(handles.alpha2,'Enable','off');
          set(handles.alpha3,'Enable','off');
          set(handles.d1_cte,'Enable','off');
          set(handles.d2_cte,'Enable','off');
          set(handles.d3_cte,'Enable','off');
          set(handles.th1_cte,'Enable','off');
          set(handles.th2_cte,'Enable','off');
          set(handles.th3_cte,'Enable','off');
          set(handles.tipo_j1,'Enable','off');
          set(handles.tipo_j2,'Enable','off');
          set(handles.tipo_j3,'Enable','off');
          set(handles.ok_btn,'Enable','off');
          set(handles.exemplo1,'Enable','off');
          set(handles.exemplo2,'Enable','off');
          set(handles.exemplo3,'Enable','off');

          
          set(handles.q1,'Enable','on');
          set(handles.q2,'Enable','on');
          set(handles.q3,'Enable','on');
          set(handles.q1_disp,'Enable','on');
          set(handles.q2_disp,'Enable','on');
          set(handles.q3_disp,'Enable','on');
          set(handles.add_pt,'Enable','on');
          set(handles.rem_pt,'Enable','on');
          
          d=d_cte;
          theta=theta_cte;
	end

% generated function required to convert GUI object callback string to function handle.
	function activate_callbacks()
		hands=struct2cell(handles);
		for i=1:length(hands)
			if ~any(strcmpi(get(hands{i},'type'),{'figure','axes','uipanel','text'})) && ...
					~isempty(get(hands{i},'callback'))
				set(hands{i},'callback',eval(get(hands{i},'callback')));
			end	
		end
	end
end