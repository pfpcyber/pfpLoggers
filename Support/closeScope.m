%10/27/2014
%Derek Liu

function [S1, exitcode] = closeScope(S1)
a = instrfind('Status','open');
if ~isempty(a)
    S1.P2Scan.stopStatus = invoke(a, 'ps3000aStop');
    disconnect(a);
    clear a;
end
exitcode = 1;
end
