function handles=render_gui(table, fig_name, fig_num)
% handles = render_gui('table.txt', ['figure title'], [figure_handle]);
%  - or -
% handles = render_gui('file.fig', ['figure title']);
% where
% 1) table.txt is a tab-delimited text file with the figure information
% 2) figure title is an optional input
% 3) figure handle is an optional input
%
% This function is part of a group of tools that are designed to replace
% the Matlab GUIDE with functionality that uses nested callback functions.
% The option to use an ASCII text file instead of a FIG file is also
% available.

% note that callbacks are initialized with strings. the strings will need
% to be converted using the eval command when the callback functions are in
% scope.

white_bgnd={'edit','listbox','popupmenu'};

if nargin<2
	fig_name='';
end

if ~isempty(strfind(table,'.fig'))
	handles=render_fig(table, fig_name, white_bgnd);
	return;
end

% nfields=find_nfields(table);
nfields=13;% there is no reason anymore to detect automatically the number of fields
[style, pos, str, tag, callback, value, enable, align, units, chld_flg]=read_table(table,nfields);

if nargin<3
	fig_num=figure('visible','off');
else
	set(fig_num,'visible','off');
end

% the following is the list of supported UI controls...note that if the
% "style" field is not one of these, and is also not a figure, axes or
% uipanel, an error will be thrown. uitable, uitab, uibuttongroup objects
% are not supported...i should mention that these could be supported, i
% just do not have time right now to do it...
uicontrols={'checkbox','edit','frame','listbox','popupmenu','pushbutton',...
	'radiobutton','slider','text','togglebutton','text'};

% build GUI and initialize handles struct
for i=1:length(style)
	if strcmpi(style{i},'figure')
		set(fig_num,'name',fig_name,...
			'numbertitle','off',...
			'units',units{i},...
			'toolbar','figure',...'none'
			'menubar','figure',...'none'
			'position',pos(i,:));
		handles.fig=fig_num;
		
		parent_flg=0;
		parent_handle=fig_num;
	elseif strcmpi(style{i},'axes')
		if chld_flg(i)==parent_flg
			h=parent_handle;
		else
			h=fig_num;
		end
		handles.(tag{i})=axes( ...
			'parent',h,...
			'units',process_entry(units{i},'normalized'),...
			'position',pos(i,:),...
			'tag',tag{i} );
	elseif strcmpi(style{i},'uipanel')
		parent_handle=uipanel( ...
			'parent',fig_num,...
			'units',units{i},...
			'position',pos(i,:),...
			'tag',tag{i},...
			'title',process_str(str{i}) );
		parent_flg=chld_flg(i);
		
		handles.(tag{i})=parent_handle;
	elseif any(strcmpi(style{i},uicontrols))
		if chld_flg(i)==parent_flg
			h=parent_handle;
		else
			h=fig_num;
		end

		control_handle=uicontrol( ...
			'style',style{i},...
			'parent',h,...
			'units',units{i},...
			'position',pos(i,:),...
			'tag',tag{i},...
			'string',process_str(str{i}),...
			'callback',process_entry(callback{i},''),...
			'value',get_value(value{i}),...
			'enable',process_entry(enable{i},'on'),...
			'horizontalalignment',process_entry(align{i},'center') );
		
		if any(strcmpi(style{i},white_bgnd))
			set(control_handle,'backgroundcolor',ones(1,3));
		end
		handles.(tag{i})=control_handle;
	else
		error('Unsupported GUI element style: %s.',style{i});
	end
end
end

function nfields=find_nfields(table)%#ok
% this code is not currently called. it is useful to automatically
% determine the number of fields in a give GUI table file (that was
% generated using build_gui_table.m). this way tables of differing length
% can be supported.
fid=fopen(table,'rt');

s=fgetl(fid);
while strcmp(s(1),'%') && ~feof(fid)
	s=fgetl(fid);
end
err=fclose(fid);%#ok
nfields=length(strfind(s,sprintf('\t')))+1;
end

function [style, pos, str, tag, callback, value, enable, align, units, chld_flg]=read_table(table, nfields)
% read table file and load appropriate fields
pattern=['%s\t',repmat('%f\t',1,4),repmat('%s\t',1,7),'%d'];
field_cell=cell(1,nfields);
[field_cell{:}]=textread(table,pattern,'commentstyle','matlab','delimiter','\t');

if nfields==13
	[style,str,tag,callback,value,enable,align,units,chld_flg]=deal(field_cell{[1,6:end]});
else
	error('Invalid number of fields, %d.',nfields);
end
pos=[field_cell{2:5}];
end

function out=process_str(str)
% check if input string is a cell array string
if ~isempty(str) && str(1)=='{'
	out=eval(str);
else
	out=str;
end
end

function str=process_entry(str,naval)
if strcmpi(str,'na')
	str=naval;
end
end

function val=get_value(str)
if strcmpi(str,'na')
	val=1;
else
	val=str2double(str);
end
end

function handles=render_fig(fig_file, fig_name, white_bgnd)
% this is alternative functionality, if for some reason the user does not
% want to use the ASCII table functionality...
f=hgload(fig_file);
set(f,'name',fig_name,'visible','off');
handles.fig=f;

recursive_types={'uipanel','uibuttongroup'};

get_children(f);

	function get_children(parent_handle)
		ch=get(parent_handle,'children');
		for i=1:length(ch)
			tag=get(ch(i),'tag');
			handles.(tag)=ch(i);
	
			t=get(ch(i),'type');
			if any(strcmpi(t,recursive_types))
				get_children(ch(i));
			end
			
			if strcmpi(t,'uicontrol')
				if any(strcmpi(get(ch(i),'style'),white_bgnd))
				% could set this to defaultbackgroundcolor like the
				% annoying create functions do in guide, but it really
				% isn't that important to be able to change the default
				% background. and if the programmer really does care about
				% this, they can do it later using handle graphics
					set(ch(i),'backgroundcolor',ones(1,3));
				end
				% this string will need to be converted to a function
				% handle when the nested callback function is in scope.
				set(ch(i),'callback',['@',tag]);
			end
		end
	end

end