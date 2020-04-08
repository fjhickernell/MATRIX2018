%% Produce tables of output for Asian Option Fixed Width Example
function AsianArithMeanOptionAutoOutput
gail.InitializeWorkspaceDisplay %clean up 
format long

load PierreAsianCallExampleAllDataA-2R-Inf
outputMat(1:5,1) = absTol; %relative Tolerance
outputMat(1:5,2) = ... %median error
   [errmedAsianCallIIDDiffAuto 
   errmedAsianCallSobDiffAuto 
   errmedAsianCallSobPCAAuto 
   errmedAsianCallSobPCACVAuto
   errmedAsianCallBayesPCAAuto];
outputMat(1:5,3) = ... %success rate
   100*[successAsianCallIIDDiffAuto
   successAsianCallSobDiffAuto
   successAsianCallSobPCAAuto
   successAsianCallSobPCACVAuto
   successAsianCallBayesPCAAuto];
outputMat(1:5,4) = ... %worst n
   [ntopAsianCallIIDDiffAuto
   ntopAsianCallSobDiffAuto
   ntopAsianCallSobPCAAuto
   ntopAsianCallSobPCACVAuto
   ntopAsianCallBayesPCAAuto];
outputMat(1:5,5) = ... %worst time
   [timetopAsianCallIIDDiffAuto
   timetopAsianCallSobDiffAuto
   timetopAsianCallSobPCAAuto
   timetopAsianCallSobPCACVAuto
   timetopAsianCallBayesPCAAuto];

outputMat = round(outputMat,2,'significant');

if exist('AsianOutput.txt','file')
   delete AsianOutput.txt
end
diary AsianOutput.txt
disp(gail.cleanString(sprintf('%2.0E & \\text{IID} & \\text{diff} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(1,:))))
%disp(gail.cleanString(sprintf('%2.0E & \\text{Scr.\\ Sobol''} & \\text{diff} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(2,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Scr.\\ Sobol''} & \\text{PCA} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(3,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Scr.\\ Sob.\\ cont.\\ var.} & \\text{PCA} & %3.0E &  %3.0f \\%% & %3.1E & %3.3f \\\\',outputMat(4,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Bayes.\\ Latt.} & \\text{PCA} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(5,:))))
diary off
return




