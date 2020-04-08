%% Produce tables of output for MVN Fixed Width Example
function MVNFixedWidthExOutput

gail.InitializeWorkspaceDisplay %clean up 
format long

load MVNProbFixedWidthExampleAllDataA-InfR-2
outputMat(1:5,1) = relTol; %relative Tolerance
outputMat(1:5,2) = ... %median error
   [errmedMVNProbIIDAg; 
   errmedMVNProbIIDGg
   errmedMVNProbUSobolGg;
   errmedMVNProbSobolGg;
   errmedMVNProbMLELatticeGg];
outputMat(1:5,3) = ... %success rate
   100*[errSucceedIIDAg; 
   errSucceedIIDGg;
   errSucceedUSobolGg;
   errSucceedSobolGg;
   errSucceedMLELatticeGg];
outputMat(1:5,4) = ... %worst n
   [topNIIDAg; 
   topNIIDGg;
   topNUSobolGg;
   topNSobolGg;
   topNMLELatticeGg];
outputMat(1:5,5) = ... %worst time
   [topTimeIIDAg; 
   topTimeIIDGg;
   topTimeUSobolGg;
   topTimeSobolGg;
   topTimeMLELatticeGg];

outputMat = round(outputMat,2,'significant');

if exist('MVNFixedWidth.txt','file')
   delete MVNFixedWidth.txt
end
diary MVNFixedWidth.txt
disp(gail.cleanString(sprintf('%2.0E & \\text{IID} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(2,:))))
disp('\uncover<2->{')
disp(gail.cleanString(sprintf('%2.0E & \\text{Scr.\\ Sobol''} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(4,:))))
disp('\uncover<3->{')
disp(gail.cleanString(sprintf('%2.0E & \\text{\\alert<2>{Bayes.\\ Latt.}} & %3.0E & %3.0f\\%% & \\alert<2>{%3.1E} & \\alert<2>{%3.3f} \\\\[1ex]',outputMat(5,:))))
disp('}}')

clearvars
load MVNProbFixedWidthExampleAllDataA-InfR-3
outputMat(1:4,1) = relTol; %relative Tolerance
outputMat(1:4,2) = ... %median error
   [errmedMVNProbIIDGg
   errmedMVNProbUSobolGg;
   errmedMVNProbSobolGg;
   errmedMVNProbMLELatticeGg];
outputMat(1:4,3) = ... %success rate
   100*[errSucceedIIDGg;
   errSucceedUSobolGg;
   errSucceedSobolGg;
   errSucceedMLELatticeGg];
outputMat(1:4,4) = ... %worst n
   [topNIIDGg;
   topNUSobolGg;
   topNSobolGg;
   topNMLELatticeGg];
outputMat(1:4,5) = ... %worst time
   [topTimeIIDGg;
   topTimeUSobolGg;
   topTimeSobolGg;
   topTimeMLELatticeGg];

outputMat = round(outputMat,2,'significant');

disp(gail.cleanString(sprintf('%2.0E & \\text{IID}  & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(1,:))))
disp('\uncover<2->{')
disp(gail.cleanString(sprintf('%2.0E & \\text{Scr.\\ Sobol''} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(3,:))))
disp('\uncover<3->{')
disp(gail.cleanString(sprintf('%2.0E & \\text{\\alert<2>{Bayes.\\ Latt.}} & %3.0E & %3.0f\\%% & \\alert<2>{%3.1E} & \\alert<2>{%3.3f} \\\\[1ex]',outputMat(4,:))))
disp('}}')

clearvars
load MVNProbFixedWidthExampleAllDataA-InfR-4
outputMat(1:3,1) = relTol; %relative Tolerance
outputMat(1:3,2) = ... %median error
   [errmedMVNProbSobolGg;
   errmedMVNProbMLELatticeGg;
   errmedMVNProbMLELattice4Gg];
outputMat(1:3,3) = ... %success rate
   100*[errSucceedSobolGg;
   errSucceedMLELatticeGg;
   errSucceedMLELattice4Gg];
outputMat(1:3,4) = ... %worst n
   [topNSobolGg;
   topNMLELatticeGg;
   topNMLELattice4Gg];
outputMat(1:3,5) = ... %worst time
   [topTimeSobolGg;
   topTimeMLELatticeGg;
   topTimeMLELattice4Gg];

outputMat = round(outputMat,2,'significant');

% disp('\uncover<5->{')
disp('\uncover<2->{')
disp(gail.cleanString(sprintf('%2.0E & \\text{Scr.\\ Sobol''} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(1,:))))
disp('\uncover<3->{')
disp(gail.cleanString(sprintf('%2.0E & \\text{\\alert<2>{Bayes.\\ Latt.}} & %3.0E & %3.0f\\%% & \\alert<2>{%3.1E} & \\alert<2>{%3.3f} \\\\',outputMat(2,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{\\alert<3>{Bayes.\\ Latt.\\ Smth.}} & %3.0E & %3.0f\\%% & \\alert<3>{%3.1E} & \\alert<3>{%3.3f}',outputMat(3,:))))
disp('}}')
diary off

