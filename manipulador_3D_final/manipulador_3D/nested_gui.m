function varargout=nested_gui(fig_file,table_file,mfile)
% nested_gui(input: FIG_file ...)
% Run options:
%  1) >> nested_gui file.fig
%     This option will generate an m-file named "file.m". The m-file is the
%     GUI executable that will use the FIG file. This option does not use
%     text layout mode. The only difference between the m-file produced by
%     GUIDE is that all the callbacks will be nested functions instead of
%     sub-functions.
%
%  2) >> nested_gui file.fig file.txt
%     This option will use "text layout mode". I had the need to replace
%     the FIG file that MATLAB GUIs usually use with a text file that
%     defines the layout of a GUI, but can be manually edited and be used
%     with a code repository. The "layout file" is a tab delimited text
%     file that includes a few important GUI properties. If the property
%     that you want is not in the text file, you will need to either set it
%     explicitly with handle graphics, or add the property to the file and
%     modify render_gui.m to support the added data.
%
%     This option will not produce an m-file; it is meant to be used if
%     there are changes to the FIG file that need to be incorporated into
%     the text layout file. To produce an m-file for text layout mode, use
%     option (4).
%
% Limitations to text layout mode:
% (a) The following possible GUI elements are not supported: uitable,
% uitab, uibuttongroup, uimenu, activeX, and Java widgets.
% (b) Multiple nested uipanels are also not currently supported. This code
% will not crash for these GUIs but the resulting layout file will not
% reproduce the GUI correctly.
% (c) If a frame (uicontrol with style frame) is rendered after the
% elements that were placed in the frame are rendered, the frame will
% obscure the elements.
%
% The above limitations could be addressed with additional work, but what I
% have here is sufficient for my needs.
%
%  3) >> nested_gui file.fig file.m
%     Allows you to specify the name of the m-file that will be used as the
%     GUI exectuable. This option is not associated with text layout mode.
%
%  4) >> nested_gui file.fig file.txt file.m
%     Allows you to specify both the names of the m-file and layout file
%     that will be used in layout mode. This option is only used for text
%     layout mode.
%
% Note that this file requires the files "varargin.bm" and
% "activate_callbacks.bm". Those files are meant to be modified according
% to your needs. Also note that when a FIG file is processed with this
% utility, it will be automatically changed to be compatible with the
% associated nested m-file. This requires deleting of GUIDE callback
% information, and removing of unsupported GUI objects. To prevent loss of
% data, a backup file called "<original_name>_backup.fig" is automatically
% created. The origianl FIG file will _NO LONGER_ work with GUIDE after
% being processed by this utility. To restore GUIDE functionality, you will
% need to manually change the backup FIG file back to the original
% filename.
%
% See also render_gui.m
%
% Sean Little
% sean.little@mathworks.com
%
% Disclaimer: I have used this code extensively for my own purposes, but I
% do not claim that it has no bugs. I am interested to hear feedback and
% suggestions, but I make no promises that I will support this code in any
% way, or fix those bugs. I assume that users of this code have a good
% familiarity with GUIDE and MATLAB programming.

if nargin && ischar(fig_file) && ~isempty(strfind(fig_file,'.fig'))
	s=read_fig_file(fig_file);
else
	error('The first input argument %s must be a FIG file.',fig_file);
end

if nargin==1
	table_file=strrep(fig_file,'.fig','.m');
	ok=write_mfile(table_file,fig_file,s);
else
	[p,n,ext]=fileparts(table_file);
	if strcmpi(ext,'.txt')
		ok=write_table(table_file,s);
	elseif strcmpi(ext,'.m')
		ok=write_mfile(table_file,fig_file,s);
	else
		ok=false;
		fprintf('Invalid table file extension.\n');
	end
end

if nargin==3 && ok
	ok=write_mfile(mfile,table_file,s);
end

if nargout
	varargout={ok};
else
	if ok
		fprintf('Success!\n');
	else
		fprintf('A problem has occurred.\n');
	end
end
end
% keyboard

function output=read_fig_file(fig_file)
[pth,name,ext]=fileparts(fig_file);
backup=fullfile(pth,sprintf('%s_backup%s',name,ext));
copyfile(fig_file,backup);
fprintf('Created %s backup file. See help header for details.\n',backup);

h=hgload(fig_file);
set(h,'visible','off');

% note that all of the following cell arrays must be the same size, and
% each field corresponds the the same entry in the other fields
field_names={'positions','tags','units','enables','align','strings','values'};

figure_flds={'position','tag','units','','','',''};
uicontrol_flds={'position','tag','units','enable','horizontalalignment','string','value'};
axes_flds={'position','tag','units','','','',''};
uipanel_flds={'position','tag','units','','titleposition','title',''};

sf = get_info('figure', h, field_names, figure_flds, 0);

child_flg=0;
panel_child=false;
so = process_parent_object(h);

output=[sf, so];

% [pth,file,ext]=fileparts(fig_file);
% hgsave(h,fullfile(pth,sprintf('%s_mod%s',file,ext)));
hgsave(h,fig_file);
delete(h);
% keyboard

% using a recursive nested function to account for the child_flg field
	function s=process_parent_object(h)
		ch=get(h,'children');
		n=1;
		for i=1:length(ch)
			object_type=get(ch(i),'type');
			switch object_type
				case 'uipanel'
					panel_child=true;
					child_flg=child_flg+1;

					s(n)=get_info(object_type, ch(i), field_names, uipanel_flds, compute_flg());%#ok
					ss=process_parent_object(ch(i));% recursive call
					s(n+1:n+length(ss))=ss;
					n=n+length(ss);
				case 'uicontrol'
					s(n)=get_info(object_type, ch(i), field_names, uicontrol_flds, compute_flg());%#ok
					set(ch(i),'callback','','createfcn','');
				case 'axes'
					s(n)=get_info(object_type, ch(i), field_names, axes_flds, compute_flg());%#ok
				otherwise
					fprintf('Warning: GUI elements of type "%s" are not supported. This object will be deleted from %s.\n',object_type,fig_file);
					delete(ch(i));
					continue;
			end
			n=n+1;
		end
		panel_child=false;
	end

	function flg=compute_flg()
		if panel_child
			flg=child_flg;
		else
			flg=0;
		end
	end

end

function s=get_info(object_type,h,field_names,object_fields,child_flg)
if strcmpi(object_type,'uicontrol')
	s.styles=get(h,'style');
else
	s.styles=object_type;
end

for i=1:length(field_names)
	if isempty(object_fields{i})
		s.(field_names{i})='na';
	else
		s.(field_names{i})=get(h,object_fields{i});
	end
end
s.child_flg=child_flg;
end

function varargout=errfun1(s,varargin)%#ok
[varargout{1:nargout}]=deal('na');
end

function ok=write_table(file,s)
ok=false;
fid=fopen(file,'wt');
if fid==-1
	return;
end
cols=13;
pos=vertcat(s.positions);
table=cell(length(s),cols);

% build table
table(:,1)={s.styles};
table(:,2:5)=num2cell(pos);

have_string={'pushbutton','uipanel','text','edit','popupmenu','listbox','togglebutton','checkbox','radiobutton'};
table(:,6)=process_field(have_string,s,'strings');

table(:,7)={s.tags};
table(:,8)=cellfun(@(s) sprintf('@%s',s),{s.tags},'uniformoutput',false);

have_value={'checkbox','popupmenu','listbox','togglebutton','radiobutton','slider'};
vals=process_field(have_value,s,'values');
% painful conversion!
convert_indx=cellfun(@(c) isnumeric(c),vals);
table(:,9)=vals;
table(convert_indx,9)=cellfun(@(c) num2str(c),vals(convert_indx),'uniformoutput',false);

table(:,10)={s.enables};
table(:,11)={s.align};
table(:,12)={s.units};
table(:,13)={s.child_flg};

% write file
fprintf(fid,'%s',build_header());
for i=1:size(table,1)
% style, xpos, ypos	wpos, hpos, string, tag, callback, default_value,
% default_enable, align	units, child_flg
	fprintf(fid,['%s\t',repmat('%.3f\t',1,4),repmat('%s\t',1,6),'%s\t%d\n'],table{i,:});
end
fclose(fid);
ok=true;
end

function c=process_field(include,s,fld)
c=cell(size(s));
for i=1:length(s)
	if ~any(strcmpi(s(i).styles,include))
		c{i}='na';
	else
		entry=s(i).(fld);
		if iscellstr(entry)
			str=sprintf(repmat('''%s'';',1,length(entry)),entry{:});
			c{i}=['{',str(1:end-1),'}'];
		elseif iscell(entry)
			% i hope this will never happen, but if it does, it needs to be
			% addressed. i'm not sure what the conditions would be for this
			% to happen, but it will cause an error downstream, so better
			% to stop here where the error is actually happening.
			fprintf('There is a strange entry for GUI element. This needs to be debugged.\n');
			keyboard
		else
			c{i}=entry;
		end
	end
end
end

function header=build_header()
version=3;
line1=sprintf('%% GUI settings file, generated on %s by version %d of %s.m.\n',datestr(now),version,mfilename());
line2=['% read command: [table{:}]=textread(''file'',[''%s\t'',repmat(''%f\t'',1,4),repmat(''%s\t'',1,7),%d''],''commentstyle'',''matlab'',''delimiter'',''\t'');',sprintf('\n')];
line3=sprintf('%%\n%% style\txpos\typos\twpos\thpos\tstring\ttag\tcallback\tdefault_value\tdefault_enable\talign\tunits\tchild_flg\n');
header=[line1,line2,line3];
end

function ok=write_mfile(mfile,table_file,s)
if exist(mfile,'file')
	if ~strcmpi(questdlg(sprintf('%s already exists. Do you want to replace this file?',mfile),...
			'WARNING','Yes','No','No'),'yes')
		ok=false;
		return;
	end
end
	
[root,name,ext]=fileparts(mfile);
if isempty(ext) || ~strcmpi(ext,'.m')
	mfile=fullfile(root,[name,'.m']);
end
fid=fopen(mfile,'wt');

% write executable mfile
fprintf(fid,'function varargout=%s(varargin)\n',name);
fprintf(fid,'%% mfile generated on %s.\n%% note that many of the hard-coded values should be replaced with calls to default_settings.m.\n\n',datestr(now));
if ~file_dump(fid,'varargin.bm')
	warning('Unable to write varargin block.');%#ok
end

fprintf(fid,'handles=render_gui(''%s'',filename);\n',table_file);
fprintf(fid,'activate_callbacks();\n\n');
fprintf(fid,'set(handles.fig,''visible'',''on'');\n');
fprintf(fid,'%% callbacks\n');

% write callback functions
for i=1:length(s)
	if ~any(strcmpi(s(i).styles,{'figure','axes','text','frame','uipanel'}))
		fprintf(fid,'\tfunction %s(varargin)\n\n\tend\n',s(i).tags);
	end
end

fprintf(fid,'\n%% generated function required to convert GUI object callback string to function handle.\n');

% dump activate_callbacks function string
if ~file_dump(fid,'activate_callbacks.bm')
	warning('Unable to write activate_callbacks block.');%#ok
end
fprintf(fid,'end');
fclose(fid);
ok=true;
end

function ok=file_dump(fid,bm_file)
fid2=fopen(bm_file,'rt');
s=fscanf(fid2,'%c',inf);
fclose(fid2);

ok=fprintf(fid,'%s\n',s)==(length(s)+1);
end