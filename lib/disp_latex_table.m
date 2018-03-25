function disp_latex_table(A,B)
%Displays A = [a1, a2, a3] and B = [b1, b2, b3] as C = [a1, b1, a2, ...] in
%latex table format
%   Created by Taeke de Haan
%   Date: 25-03-2018

% combine vecotrs
C = [A; B];
C = C(:);

% convert to string
tableLine = string([repmat('& ',size(C,1),1), num2str(C, '%10.2f')])';

% print line
fprintf([repmat('%s \t',1,14) '\n'], tableLine);
end

