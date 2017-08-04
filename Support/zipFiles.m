function success = zipFiles()
% Zip all .meta and .data files in the specified folder
%
% Joseph Messou
% 06/19/2017

%Ask user for the directory with all sigMF files
S1 = getappdata(0,'S1');
if isempty(S1) || ~isfield(S1,'DataPaths') || ~isfield(S1.DataPaths,'DataStorage')
    basePath = '';
else
    basePath = S1.DataPaths.DataStorage;
end

dirName = uigetdir(basePath,'Select the Directory With the SigMF Files');
if ~dirName
    return
end

try
    dateTime = datetime('now','Timezone','local','Format','yyyy-MM-dd''T''HH:mm:ss,SSSSXXX');              

    %File name
    fileName = ['sigMF_', num2str(dateTime.Year,'%04d'),...
        num2str(dateTime.Month,'%02d'),...
        num2str(dateTime.Day,'%02d'),...
        '_',...
        num2str(dateTime.Hour,'%02d'),...
        num2str(dateTime.Minute,'%02d'),...
        strrep(num2str(dateTime.Second,'%5.2f'), '.', '_')];  

    fullfileName = fullfile(dirName, fileName);

    msg = sprintf('Compressing sigMF files...');
    ziph = msgbox(msg,'Zip Files');   
    
    fprintf('Compressing sigMF files...\n');
    tic;
    %Zip files
    allFiles = zip(fullfileName,{'*.meta','*.data'},dirName);
    toc;
    
    %Close message box
    if exist('ziph', 'var')
        delete(ziph);
        clear('h');
    end

    %Success message
    msg = sprintf('Zip file created using %d sigMF files: %s', length(allFiles), fullfileName);
    msgbox(msg,'Zip Files');
    success = 1;
   
    
catch err
    toc;
    %Close message box
    if exist('ziph', 'var')
        delete(ziph);
        clear('h');
    end    
    uiwait(msgbox(err.message));
end


end

