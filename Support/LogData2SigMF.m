function [Flag] = LogData2SigMF( S1,ObjSigMF,traceNum,Opt )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Flag = 0;
for idx = 1:4
    if isequal(S1.channelSettings(idx).Enabled,true)
        switch idx
            case 1
                traces{1,1} = S1.P2Scan.pBufferChAFinal.Value;
            case 2
                traces{1,2} = S1.P2Scan.pBufferChBFinal.Value;
            case 3
                traces{1,3} = S1.P2Scan.pBufferChCFinal.Value;
            case 4
                traces{1,4} = S1.P2Scan.pBufferChDFinal.Value;
        end
    elseif isequal(S1.channelSettings(idx).Enabled,false)
        switch idx
            case 1
                traces{1,1} = [];
            case 2
                traces{1,2} = [];
            case 3
                traces{1,3} = [];
            case 4
                traces{1,4} = [];
        end
    end
end



%  traces = {S1.P2Scan.pBufferChAFinal.Value,S1.P2Scan.pBufferChBFinal.Value,S1.P2Scan.pBufferChCFinal.Value,S1.P2Scan.pBufferChDFinal.Value};

ObjSigMF.core_0x3A_global.core_0x3A_sha512 = DataHash([traces{1,1}; traces{1,2}; traces{1,3} ;traces{1,4}],Opt);
% SigMF meta data
DateTime = datetime('now','Timezone','local','Format','yyyy-MM-dd''T''HH:mm:ss,SSSSXXX');



switch S1.ActiveChans
    case 1
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_start = 0;
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.P2Scan.FsDefaults(S1.TimeTrace.SampleFreq+1);
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_time = char(DateTime);
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_length = length(traces{1,1});
        % annotations
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_count = length(traces{1,1}) ;
        ObjSigMF.core_0x3A_annotations{1,2} = [];
        ObjSigMF.core_0x3A_annotations{1,3} = [];
        ObjSigMF.core_0x3A_annotations{1,4} = [];
        ObjSigMF.core_0x3A_annotations = ObjSigMF.core_0x3A_annotations(~cellfun('isempty',ObjSigMF.core_0x3A_annotations));


    case 2
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_start = 0;
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.P2Scan.FsDefaults(S1.TimeTrace.SampleFreq+1);
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_time = char(DateTime);
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_length = length(traces{1,1});

        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_count = length(traces{1,1}) ;

        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_start = length(traces{1,2});
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_time = char(DateTime);
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_length = length(traces{1,2});
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_rate = S1.P2Scan.FsDefaults(S1.TimeTrace.SampleFreq+1);


        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_count = length(traces{1,2}) ;
        
        ObjSigMF.core_0x3A_annotations{1,3} = [];
        ObjSigMF.core_0x3A_annotations{1,4} = [];
        ObjSigMF.core_0x3A_annotations = ObjSigMF.core_0x3A_annotations(~cellfun('isempty',ObjSigMF.core_0x3A_annotations));

    
    case 3
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_start = 0;
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.P2Scan.FsDefaults(S1.TimeTrace.SampleFreq+1);
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_time = char(DateTime);
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_length = length(traces{1,1});
        
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_count = length(traces{1,1}) ;

        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_start = length(traces{1,1});
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_time = char(DateTime);
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_length = length(traces{1,2});
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_rate = S1.P2Scan.FsDefaults(S1.TimeTrace.SampleFreq+1);

        
        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_count = length(traces{1,2}) ;

        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_start = length(traces{1,1})+length(traces{1,2});
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_time = char(DateTime);
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_length = length(traces{1,3});
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_rate = S1.P2Scan.FsDefaults(S1.TimeTrace.SampleFreq+1);

        ObjSigMF.core_0x3A_annotations{1,3}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,3}.core_0x3A_sample_count = length(traces{1,3}) ;

        ObjSigMF.core_0x3A_annotations{1,4} = [];
        ObjSigMF.core_0x3A_annotations = ObjSigMF.core_0x3A_annotations(~cellfun('isempty',ObjSigMF.core_0x3A_annotations));

    case 4
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_start = 0;
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.P2Scan.FsDefaults(S1.TimeTrace.SampleFreq+1);
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_time = char(DateTime);
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_length = length(traces{1,1});

        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_count = length(traces{1,1}) ;

        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_start = length(traces{1,1});
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_time = char(DateTime);
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_length = length(traces{1,2});
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_rate = S1.P2Scan.FsDefaults(S1.TimeTrace.SampleFreq+1);

        
        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_count = length(traces{1,2}) ;

        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_start = length(traces{1,1})+length(traces{1,2});
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_time = char(DateTime);
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_length = length(traces{1,3});
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_rate = S1.P2Scan.FsDefaults(S1.TimeTrace.SampleFreq+1);

        
        ObjSigMF.core_0x3A_annotations{1,3}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,3}.core_0x3A_sample_count = length(traces{1,3}) ;

        
        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_sample_start = length(traces{1,1})+length(traces{1,2})+ length(traces{1,2});
        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_time = char(DateTime);
        ObjSigMF.core_0x3A_capture{1,4}.PFP_0x3A_length = length(traces{1,4});
        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_sample_rate = S1.P2Scan.FsDefaults(S1.TimeTrace.SampleFreq+1);

        ObjSigMF.core_0x3A_annotations{1,4}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,4}.core_0x3A_sample_count = length(traces{1,4}) ;

end

%        DateTime = datetime('now','Timezone','local','Format','yyyy-MM-dd''T''HH:mm:ss,SSSSXXX');
%        ObjSigMF.core_0x3A_capture.core_0x3A_time = char(DateTime);
ObjSigMF.core_0x3A_global.PFP_0x3A_sequence = traceNum;

% Base file name
FileName = [num2str(DateTime.Year,'%04d'),...
    num2str(DateTime.Month,'%02d'),...
    num2str(DateTime.Day,'%02d'),...
    '_',...
    num2str(DateTime.Hour,'%02d'),...
    num2str(DateTime.Minute,'%02d'),...
    strrep(num2str(DateTime.Second,'%5.2f'), '.', '_')];
DataFileName = [FileName '.data']; % Add .data extension
DataFullPath = [S1.DataPaths.DataStorage DataFileName];
MetaFileName = [FileName '.meta'];%  Add .meta extension
MetaFullPath = [S1.DataPaths.DataStorage MetaFileName];

ObjSigMF.core_0x3A_global.core_0x3A_datapath = DataFileName;

DataFileWriter(DataFullPath,[traces{1,1}; traces{1,2}; traces{1,3} ;traces{1,4}], ObjSigMF.core_0x3A_global.core_0x3A_datatype);
JsonFileWriter(MetaFullPath,ObjSigMF);


end

