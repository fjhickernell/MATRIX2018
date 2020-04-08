%% Generate Examples of Multivariate Normal Probabilities
function MVNFixedWidthExample(redo,absTol,relTol,dim)
gail.InitializeDisplay %clean up 
format long

if nargin < 4
   dim = 2;
   if nargin < 3
      relTol = 1e-2;
      if nargin < 2
         absTol = 1e-2;
         if nargin < 1
            redo = false;
         end
      end
   end
end

if dim == 3
   C = [4 1 1 1; 0 1 0.5 0.5; 0 0 0.25 0.25; 0 0 0 0.25];
   Cov = C'*C;
   a = [-6 -2 -2 -2];
   b = [5 2 1 2];
else
   dim = 2;
   C = [4 1 1; 0 1 0.5; 0 0 0.25];
   Cov = C'*C;
   a = [-6 -2 -2];
   b = [5 2 1];
end

%mu = 0;
nRep = 100;
alpha = 0.1; %top of quantile
% absTol = 0;
% relTol = 1e-2;
dataFileName = ['MVNProbFixedWidthExampleAllDataA' ...
   int2str(log10(absTol)) 'R' int2str(log10(relTol)) ...
   'D' int2str(dim) '.mat'];

if exist(dataFileName,'file')
   load(dataFileName)
   MVNProbBestArch = MVNProbBest;
   nRepGoldArch = nRepGold;
   if absTol + relTol >= 0.001
      MVNProbIIDGgArch = MVNProbIIDGg;
   end
   if absTol + relTol >= 0.01
      MVNProbIIDAgArch = MVNProbIIDAg;
   end
   MVNProbSobolGgArch = MVNProbSobolGg;
   MVNProbUSobolGgArch = MVNProbUSobolGg;
   MVNProbLatticeGgArch = MVNProbLatticeGg;
   MVNProbMLELatticeGgArch = MVNProbMLELatticeGg;
   MVNProbMLELattice4GgArch = MVNProbMLELattice4Gg;
   MVNProbMLESobolGgArch = MVNProbMLESobolGg;
   if exist('MVNProbMLELatticeGn', 'var')
        MVNProbMLELatticeGnArch = MVNProbMLELatticeGg;
   end
end

% redo = true; %redo the calculation

%% First compute a high accuracy answer
nGold = 2^27;
nRepGold = nRep;
MVNProbBest = multivarGauss('a',a,'b',b,'Cov',Cov,'n',nGold, ...
   'errMeth','n','cubMeth','Sobol','intMeth','Genz');
compGold = true;
if exist(dataFileName,'file')
   if sameProblem(MVNProbBest,MVNProbBestArch) && ...
      nRepGoldArch == nRepGold
      disp('Already have gold standard answer')
      compGold = false;
   end
end
if compGold
   disp('(Re-)computing gold standard answer')
   muBestvec = zeros(1,nRepGold);
   tic 
   for i = 1:nRepGold
      gail.TakeNote(i,1)
      tic
      muBestvec(1,i) = compProb(MVNProbBest); 
      toc
   end
   toc
   muBest = mean(muBestvec);
end
disp(['mu  = ' num2str(muBest,15) ' +/- ' num2str(2*std(muBestvec),10)])

%% IID sampling using Genz transformation
if absTol + relTol >= 0.001
MVNProbIIDGg = multivarGauss('a',a,'b',b,'Cov',Cov, ...
   'errMeth','g','absTol',absTol,'relTol',relTol,...
   'cubMeth','IID','intMeth','Genz');
compIID = true;
if exist(dataFileName,'file')
   if sameProblem(MVNProbIIDGg,MVNProbIIDGgArch) && ...
      all(nRep == nRepArch)
      disp('Already have IID Genz answer')
      compIID = false;
   end
end
if compIID || redo
   tic
   muMVNProbIIDGg = zeros(nRep,1);
   IIDGgNrequired = zeros(nRep,1);
   IIDGgTime = zeros(nRep,1);
   for i = 1:nRep
      gail.TakeNote(i,10)
      [muMVNProbIIDGg(i),out] = compProb(MVNProbIIDGg);
      IIDGgNrequired(i) = out.ntot;
      IIDGgTime(i) = out.time;
   end
   errvecMVNProbIIDGg = abs(muBest - muMVNProbIIDGg);
   errmedMVNProbIIDGg = median(errvecMVNProbIIDGg);
   errtopMVNProbIIDGg = quantile(errvecMVNProbIIDGg,1-alpha);
   errSucceedIIDGg = mean(errvecMVNProbIIDGg <= max(absTol,relTol*abs(muBest)));
   topNIIDGg = quantile(IIDGgNrequired,1-alpha);
   topTimeIIDGg = quantile(IIDGgTime,1-alpha);
   toc
end
end

%% IID sampling using affine transformation
if absTol + relTol >= 0.01
MVNProbIIDAg = multivarGauss('a',a,'b',b,'Cov',Cov, ...
   'errMeth','g','absTol',absTol,'relTol',relTol,...
   'cubMeth','IID','intMeth','aff');
compIIDA = true;
if exist(dataFileName,'file')
   if sameProblem(MVNProbIIDAg,MVNProbIIDAgArch) && ...
      all(nRep == nRepArch)
      disp('Already have IID affine answer')
      compIIDA = false;
   end
end
if compIIDA || redo
   tic
   muMVNProbIIDAg = zeros(nRep,1);
   IIDAgNrequired = zeros(nRep,1);
   IIDAgTime = zeros(nRep,1);
   for i = 1:nRep
      gail.TakeNote(i,10)
      [muMVNProbIIDAg(i),out] = compProb(MVNProbIIDAg);
      IIDAgNrequired(i) = out.ntot;
      IIDAgTime(i) = out.time;
   end
   errvecMVNProbIIDAg = abs(muBest - muMVNProbIIDAg);
   errmedMVNProbIIDAg = median(errvecMVNProbIIDAg);
   errtopMVNProbIIDAg = quantile(errvecMVNProbIIDAg,1-alpha);
   errSucceedIIDAg = mean(errvecMVNProbIIDAg <= max(absTol,relTol*abs(muBest)));
   topNIIDAg = quantile(IIDAgNrequired,1-alpha);
   topTimeIIDAg = quantile(IIDAgTime,1-alpha);
   toc
end
end

%% Scrambled Sobol sampling
MVNProbSobolGg = multivarGauss('a',a,'b',b,'Cov',Cov, ...
   'errMeth','g','absTol',absTol,'relTol',relTol,...
   'cubMeth','Sobol','intMeth','Genz');
compSobol = true;
if exist(dataFileName,'file')
   if sameProblem(MVNProbSobolGg,MVNProbSobolGgArch)
      disp('Already have Scrambled Sobol answer')
      compSobol = false;
   end
end
if compSobol || redo
   tic 
   muMVNProbSobolGg = zeros(nRep,1);
   SobolGgNrequired = zeros(nRep,1);
   SobolGgTime = zeros(nRep,1);
   for i = 1:nRep
      gail.TakeNote(i,10)
      [muMVNProbSobolGg(i), out] = compProb(MVNProbSobolGg); 
      SobolGgNrequired(i) = out.n;
      SobolGgTime(i) = out.time;
   end
   errvecMVNProbSobolGg = abs(muBest - muMVNProbSobolGg);
   errmedMVNProbSobolGg = median(errvecMVNProbSobolGg);
   errtopMVNProbSobolGg = quantile(errvecMVNProbSobolGg,1-alpha);
   errSucceedSobolGg = mean(errvecMVNProbSobolGg <= max(absTol,relTol*abs(muBest)));
   topNSobolGg = quantile(SobolGgNrequired,1-alpha);
   topTimeSobolGg = quantile(SobolGgTime,1-alpha);
   toc
end

%% Unscrambled Sobol sampling
MVNProbUSobolGg = multivarGauss('a',a,'b',b,'Cov',Cov, ...
   'errMeth','g','absTol',absTol,'relTol',relTol,...
   'cubMeth','uSobol','intMeth','Genz');
compUSobol = true;
if exist(dataFileName,'file')
   if sameProblem(MVNProbUSobolGg,MVNProbUSobolGgArch)
      disp('Already have Unscrambled Sobol answer')
      compUSobol = false;
   end
end
if compUSobol || redo
   tic 
   [muMVNProbUSobolGg, out] = compProb(MVNProbUSobolGg); 
   USobolGgNrequired = out.n;
   USobolGgTime = out.time;
   errvecMVNProbUSobolGg = abs(muBest - muMVNProbUSobolGg);
   errmedMVNProbUSobolGg = errvecMVNProbUSobolGg;
   errtopMVNProbUSobolGg = errvecMVNProbUSobolGg;
   errSucceedUSobolGg = errvecMVNProbUSobolGg <= max(absTol,relTol*abs(muBest));
   topNUSobolGg = USobolGgNrequired;
   topTimeUSobolGg = USobolGgTime;
   toc
end

%% Lattice sampling
MVNProbLatticeGg = multivarGauss('a',a,'b',b,'Cov',Cov, ...
   'errMeth','g','absTol',absTol,'relTol',relTol,...
   'cubMeth','Lattice','intMeth','Genz');
compLattice = true;
if exist(dataFileName,'file')
   if sameProblem(MVNProbLatticeGg,MVNProbLatticeGgArch)
      disp('Already have Lattice answer')
      compLattice = false;
   end
end
if compLattice || redo
   tic 
   muMVNProbLatticeGg = zeros(nRep,1);
   LatticeGgNrequired = zeros(nRep,1);
   LatticeGgTime = zeros(nRep,1);
   for i = 1:nRep
      gail.TakeNote(i,10)
      [muMVNProbLatticeGg(i), out] = compProb(MVNProbLatticeGg); 
      LatticeGgNrequired(i) = out.n;
      LatticeGgTime(i) = out.time;
   end
   errvecMVNProbLatticeGg = abs(muBest - muMVNProbLatticeGg);
   errmedMVNProbLatticeGg = median(errvecMVNProbLatticeGg);
   errtopMVNProbLatticeGg = quantile(errvecMVNProbLatticeGg,1-alpha);
   errSucceedLatticeGg = mean(errvecMVNProbLatticeGg <= max(absTol,relTol*abs(muBest)));
   topNLatticeGg = quantile(LatticeGgNrequired,1-alpha);
   topTimeLatticeGg = quantile(LatticeGgTime,1-alpha);
   toc
end


%% Try MLE Bayseian cubature with Fourier kernel and Rank1 Lattice points
%whBayes = 'MLELattice'; %Jags' version
whBayes = 'BayesLattice'; %Fred's version
MVNProbMLELatticeGg = multivarGauss('a',a,'b',b,'Cov',Cov,'n',nvecMLE, ...
  'errMeth','g','cubMeth',whBayes,'intMeth','Genz', ...
  'BernPolyOrder',2,'ptransform','Baker', ...
  'fName','','figSavePath','','arbMean',true,...
  'absTol',absTol, 'relTol', relTol, 'stopAtTol',true);
compMLELattice = true;
if exist(dataFileName,'file') % force to compute all the time
   if sameProblem(MVNProbMLELatticeGg,MVNProbMLELatticeGgArch)
      disp('Already have MLE Fourier Lattice answer')
      compMLELattice = false;
   end
end
if compMLELattice || redo
   tic
   muMVNProbMLELatticeGg = zeros(nRep,1);
   MLELatticeGgNrequired = zeros(nRep,1);
   MLELatticeGgTime = zeros(nRep,1);
   errbdvecMBVProbMLELatticeGg(nRep,1) = 0;
   for i = 1:nRep
      gail.TakeNote(i,10)
      [muMVNProbMLELatticeGg(i), out] = compProb(MVNProbMLELatticeGg);       %Fred's version
      errbdvecMBVProbMLELatticeGg(i) = out.ErrBd;
      MLELatticeGgNrequired(i) = out.n;
      MLELatticeGgTime(i) = out.time;
   end
   errvecMVNProbMLELatticeGg = abs(muBest - muMVNProbMLELatticeGg);
   errmedMVNProbMLELatticeGg = median(errvecMVNProbMLELatticeGg);
   errtopMVNProbMLELatticeGg = quantile(errvecMVNProbMLELatticeGg,1-alpha);
   errSucceedMLELatticeGg = mean(errvecMVNProbMLELatticeGg <= max(absTol,relTol*abs(muBest)));
   topNMLELatticeGg = quantile(MLELatticeGgNrequired,1-alpha);
   topTimeMLELatticeGg = quantile(MLELatticeGgTime,1-alpha);
   toc
end


%% Try MLE Bayseian cubature with SMOOTHER Fourier kernel and Rank1 Lattice points
%whBayes = 'MLELattice'; %Jags' version
whBayes = 'BayesLattice'; %Fred's version
MVNProbMLELattice4Gg = multivarGauss('a',a,'b',b,'Cov',Cov,'n',nvecMLE, ...
  'errMeth','g','cubMeth',whBayes,'intMeth','Genz', ...
  'BernPolyOrder',4,'ptransform','C1sin', ...
  'fName','','figSavePath','','arbMean',true,...
  'absTol',absTol, 'relTol', relTol, 'stopAtTol',true);
compMLELattice4 = true;
if exist(dataFileName,'file') % force to compute all the time
   if sameProblem(MVNProbMLELattice4Gg,MVNProbMLELattice4GgArch)
      disp('Already have MLE Fourier Lattice4 answer')
      compMLELattice4 = false;
   end
end
if compMLELattice4 || redo || true
   tic
   muMVNProbMLELattice4Gg = zeros(nRep,1);
   MLELattice4GgNrequired = zeros(nRep,1);
   MLELattice4GgTime = zeros(nRep,1);
   errbdvecMBVProbMLELattice4Gg(nRep,1) = 0;
   for i = 1:nRep
      gail.TakeNote(i,10)
      [muMVNProbMLELattice4Gg(i), out] = compProb(MVNProbMLELattice4Gg); 
      errbdvecMBVProbMLELattice4Gg(i) = out.ErrBd;
      MLELattice4GgNrequired(i) = out.n;
      MLELattice4GgTime(i) = out.time;
   end
   errvecMVNProbMLELattice4Gg = abs(muBest - muMVNProbMLELattice4Gg);
   errmedMVNProbMLELattice4Gg = median(errvecMVNProbMLELattice4Gg);
   errtopMVNProbMLELattice4Gg = quantile(errvecMVNProbMLELattice4Gg,1-alpha);
   errSucceedMLELattice4Gg = mean(errvecMVNProbMLELattice4Gg <= max(absTol,relTol*abs(muBest)));
   topNMLELattice4Gg = quantile(MLELattice4GgNrequired,1-alpha);
   topTimeMLELattice4Gg = quantile(MLELattice4GgTime,1-alpha);
   toc
end

%% Try MLE Bayseian cubature with Walsh kernel and Sobol 
MVNProbMLESobolGg = multivarGauss('a',a,'b',b,'Cov',Cov,'n',nvecMLE, ...
  'errMeth','g','cubMeth','MLESobol','intMeth','Genz', ...
  'ptransform','none', ...
  'fName','','figSavePath','','arbMean',true,...
  'absTol',absTol, 'relTol', relTol, 'stopAtTol',true);
compMLESobol = true;
if exist(dataFileName,'file') % force to compute all the time
   if sameProblem(MVNProbMLESobolGg,MVNProbMLESobolGgArch)
      disp('Already have MLE Sobol answer')
      compMLESobol = false;
   end
end
if compMLESobol || redo
   tic
   muMVNProbMLESobolGg = zeros(nRep,1);
   MLESobolGgNrequired = zeros(nRep,1);
   MLESobolGgTime = zeros(nRep,1);
   errbdvecMBVProbMLESobolGg(nRep,1) = 0;
   for i = 1:nRep
      gail.TakeNote(i,10)
      [muMVNProbMLESobolGg(i), out] = compProb(MVNProbMLESobolGg); 
      errbdvecMBVProbMLESobolGg(i) = out.ErrBd;
      MLESobolGgNrequired(i) = out.n;
      MLESobolGgTime(i) = out.time;
   end
   errvecMVNProbMLESobolGg = abs(muBest - muMVNProbMLESobolGg);
   errmedMVNProbMLESobolGg = median(errvecMVNProbMLESobolGg);
   errtopMVNProbMLESobolGg = quantile(errvecMVNProbMLESobolGg,1-alpha);
   errSucceedMLESobolGg = mean(errvecMVNProbMLESobolGg <= max(absTol,relTol*abs(muBest)));
   topNMLESobolGg = quantile(MLESobolGgNrequired,1-alpha);
   topTimeMLESobolGg = quantile(MLESobolGgTime,1-alpha);
   toc
end


%% Save output
clear redo
save(dataFileName)
return

