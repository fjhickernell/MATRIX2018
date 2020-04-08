%% Produce tables of output for MVN Fixed Width Example
function MVNFixedWidthExOutput

gail.InitializeWorkspaceDisplay %clean up 
format long

load MVNProbFixedWidthExampleAllDataA-InfR-2D2
outputMat(1:8,1) = relTol; %relative Tolerance
outputMat(1:8,2) = ... %median error
   [errmedMVNProbIIDAg; 
   errmedMVNProbIIDGg
   errmedMVNProbUSobolGg;
   errmedMVNProbSobolGg;
   errmedMVNProbLatticeGg;
   errmedMVNProbMLELatticeGg;
   errmedMVNProbMLELattice4Gg;
   errmedMVNProbMLESobolGg;
   ];
outputMat(1:8,3) = ... %success rate
   100*[errSucceedIIDAg; 
   errSucceedIIDGg;
   errSucceedUSobolGg;
   errSucceedSobolGg;
   errSucceedLatticeGg;
   errSucceedMLELatticeGg;
   errSucceedMLELattice4Gg;
   errSucceedMLESobolGg;
   ];
outputMat(1:8,4) = ... %worst n
   [topNIIDAg; 
   topNIIDGg;
   topNUSobolGg;
   topNSobolGg;
   topNLatticeGg;
   topNMLELatticeGg;
   topNMLELattice4Gg;
   topNMLESobolGg;
   ];
outputMat(1:8,5) = ... %worst time
   [topTimeIIDAg; 
   topTimeIIDGg;
   topTimeUSobolGg;
   topTimeSobolGg;
   topTimeLatticeGg;
   topTimeMLELatticeGg;
   topTimeMLELattice4Gg;
   topTimeMLESobolGg;
   ];

outputMat = round(outputMat,2,'significant');

if exist('MVNFixedWidth.txt','file')
   delete MVNFixedWidth.txt
end
diary MVNFixedWidth.txt
disp('\only<1>{')
disp(gail.cleanString(sprintf('%2.0E & \\text{IID} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(2,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Sh.\\ Latt.} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(5,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Scr.\\ Sobol''} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(4,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Bayes.\\ Latt.} & %3.0E & %3.0f\\%% & %3.1E & %3.3f',outputMat(6,:))))
%disp(gail.cleanString(sprintf('%2.0E & \\text{Bayes.\\ Sobol''} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\[1ex]',outputMat(8,:))))
disp('}')

clearvars
load MVNProbFixedWidthExampleAllDataA-InfR-3D2
outputMat(1:7,1) = relTol; %relative Tolerance
outputMat(1:7,2) = ... %median error
   [errmedMVNProbIIDGg
   errmedMVNProbUSobolGg;
   errmedMVNProbSobolGg;
   errmedMVNProbLatticeGg;
   errmedMVNProbMLELatticeGg;
   errmedMVNProbMLELattice4Gg;
   errmedMVNProbMLESobolGg;
   ];
outputMat(1:7,3) = ... %success rate
   100*[errSucceedIIDGg;
   errSucceedUSobolGg;
   errSucceedSobolGg;
   errSucceedLatticeGg;
   errSucceedMLELatticeGg;
   errSucceedMLELattice4Gg;
   errSucceedMLESobolGg;
   ];
outputMat(1:7,4) = ... %worst n
   [topNIIDGg;
   topNUSobolGg;
   topNSobolGg;
   topNLatticeGg;
   topNMLELatticeGg;
   topNMLELattice4Gg;
   topNMLESobolGg;
   ];
outputMat(1:7,5) = ... %worst time
   [topTimeIIDGg;
   topTimeUSobolGg;
   topTimeSobolGg;
   topTimeLatticeGg;
   topTimeMLELatticeGg;
   topTimeMLELattice4Gg;
   topTimeMLESobolGg;
   ];

outputMat = round(outputMat,2,'significant');

disp('\only<2>{')
disp(gail.cleanString(sprintf('%2.0E & \\text{IID} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(1,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Sh.\\ Latt.} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(4,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Scr.\\ Sobol''} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(3,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Bayes.\\ Latt.} & %3.0E & %3.0f\\%% & %3.1E & %3.3f',outputMat(5,:))))
%disp(gail.cleanString(sprintf('%2.0E & \\text{Bayes.\\ Sobol''} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\[1ex]',outputMat(7,:))))
disp('}')

clearvars
load MVNProbFixedWidthExampleAllDataA-InfR-4D2
outputMat(1:6,1) = relTol; %relative Tolerance
outputMat(1:6,2) = ... %median error
   [errmedMVNProbUSobolGg;
   errmedMVNProbSobolGg;
   errmedMVNProbLatticeGg;
   errmedMVNProbMLELatticeGg;
   errmedMVNProbMLELattice4Gg;
   errmedMVNProbMLESobolGg;
   ];
outputMat(1:6,3) = ... %success rate
   100*[errSucceedUSobolGg;
   errSucceedSobolGg;
   errSucceedLatticeGg;
   errSucceedMLELatticeGg;
   errSucceedMLELattice4Gg;
   errSucceedMLESobolGg;
   ];
outputMat(1:6,4) = ... %worst n
   [topNUSobolGg;
   topNSobolGg;
   topNLatticeGg;
   topNMLELatticeGg;
   topNMLELattice4Gg;
   topNMLESobolGg;
   ];
outputMat(1:6,5) = ... %worst time
   [topTimeUSobolGg;
   topTimeSobolGg;
   topTimeLatticeGg;
   topTimeMLELatticeGg;
   topTimeMLELattice4Gg;
   topTimeMLESobolGg;
   ];

outputMat = round(outputMat,2,'significant');

disp('\only<3>{')
%disp(gail.cleanString(sprintf('%2.0E & \\text{IID} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(1,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Sh.\\ Latt.} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(3,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Scr.\\ Sobol''} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\',outputMat(2,:))))
disp(gail.cleanString(sprintf('%2.0E & \\text{Bayes.\\ Latt.} & %3.0E & %3.0f\\%% & %3.1E & %3.3f',outputMat(4,:))))
%disp(gail.cleanString(sprintf('%2.0E & \\text{Bayes.\\ Latt.\\ Smth.} & %3.0E & %3.0f\\%% & %3.1E & %3.3f',outputMat(5,:))))
%disp(gail.cleanString(sprintf('%2.0E & \\text{Bayes.\\ Sobol''} & %3.0E & %3.0f\\%% & %3.1E & %3.3f \\\\[1ex]',outputMat(6,:))))
disp('}')

diary off

