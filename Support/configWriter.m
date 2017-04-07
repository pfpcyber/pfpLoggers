function configWriter(filename,Structure)
% Writes P2Scan .ini and .pfpproj files
%
% Derek Liu
% 11/11/14

% Based on struct2ini by Dirk Lohse

%% Write string
s = '';
Sections = fieldnames(Structure);
for i=1:length(Sections)
    Section = char(Sections(i));
    if ~strcmp(Section,'P2Scan')
        s = sprintf('%s[%s]\n',s,Section);
        member_struct = Structure.(Section);
        if ~isempty(member_struct)
            member_names = fieldnames(member_struct);
            for j=1:length(member_names)
                member_name = char(member_names(j));
                member_value = Structure.(Section).(member_name);
                if ~ischar(member_value)
                    switch length(member_value)
                        case 1
                            s = sprintf('%s%s = %g\n',s,member_name,member_value);
                        case 2
                            s = sprintf('%s%s = [%g %g]\n',s,member_name,member_value(1),member_value(2));
                        case 0
                            s = sprintf('%s%s = \n',s,member_name);
                    end
                else
                    s = sprintf('%s%s = %s\n',s,member_name,member_value);
                end
            end
        end
        s = sprintf('%s\n',s);
    end
end


%% Write file
fid = fopen(filename,'w');
fprintf(fid,'%c',s);
fclose(fid); % close file