%% Generate Examples of Asian Arithmetic Mean Option Pricing
function AsianArithmeticMeanOptionAutoExample(redo,absTol,relTol)

gail.InitializeDisplay %clean up 
format long

if nargin < 3
   relTol = 0;
   if nargin < 2
      absTol = 1e-2;
      if nargin < 1
         redo = false;
      end
   end
end

whichExample = 'Pierre'
dataFileName = [whichExample 'AsianCallExampleAllDataA' ...
   int2str(log10(absTol)) 'R' int2str(log10(relTol)) '.mat'];

if exist(dataFileName,'file')
   load(dataFileName)
%    ArchEuroCallSobPCA = EuroCallSobPCA;
   ArchAsianCallIIDDiff = AsianCallIIDDiff;
   ArchAsianCallSobDiff = AsianCallSobDiff;
   ArchAsianCallSobPCA = AsianCallSobPCA;
  ArchAsianCallBayesLatticePCA = AsianCallBayesLatticePCA;
  ArchAsianCallBayesSobolPCA = AsianCallBayesSobolPCA;
   ArchAsianCallSobCV = AsianCallSobCV;
   Archnvec = nvec;
   ArchabsTolGold = absTolGold;
   ArchnGoldRep = nGoldRep;
   ArchAbsTol = absTol;
   ArchRelTol = relTol;
   ArchnRepAuto = nRepAuto;
   ArchnRep = nRep;
end
absTol = 1e-2;
relTol = 0;
dataFileName = [whichExample 'AsianCallExampleAllDataA' ...
   int2str(log10(absTol)) 'R' int2str(log10(relTol)) '.mat'];



%% Parameters for the Asian option, Fred's Original
if strcmp(whichExample,'Fred')
   inp.timeDim.timeVector = 1/52:1/52:1/4; %weekly monitoring for one quarter 
   inp.assetParam.initPrice = 100; %initial stock price
   inp.assetParam.interest = 0.01; %risk-free interest rate
   inp.assetParam.volatility = 0.5; %volatility
   inp.payoffParam.strike = 100; %strike price
   inp.priceParam.absTol = absTol; %absolute tolerance of a penny
   inp.priceParam.relTol = relTol; %zero relative tolerance
   inp.priceParam.cubMethod = 'Sobol'; %Sobol sampling
   inp.bmParam.assembleType = 'PCA';
   inp.payoffParam.putCallType = {'call'};
   nvec = 2.^(7:17)';
   absTolGold = 1e-6;

%% Parameters for the Asian option, Pierre's Example
elseif strcmp(whichExample,'Pierre')
   inp.timeDim.timeVector = 1/12:1/12:1; %weekly monitoring for one quarter 
   inp.assetParam.initPrice = 100; %initial stock price
   inp.assetParam.interest = 0.05; %risk-free interest rate
   inp.assetParam.volatility = 0.5; %volatility
   inp.payoffParam.strike = 100; %strike price
   inp.priceParam.absTol = absTol; %absolute tolerance of a penny
   inp.priceParam.relTol = relTol; %zero relative tolerance
   inp.priceParam.cubMethod = 'Sobol'; %Sobol sampling
   inp.bmParam.assembleType = 'PCA';
   inp.payoffParam.putCallType = {'call'};
   absTolGold = 1e-5;
   nvec = 2.^(7:17)';
end
nmax = max(nvec);
nRep = 100;
nlarge = nmax*2;
nn = numel(nvec);
alpha = 0.1;

%% Construct some different options
EuroCallSob = optPrice(inp); %construct a European optPrice object
AsianCallSobPCA = optPrice(EuroCallSob); %construct an Asian optPrice object
AsianCallSobPCA.payoffParam = struct( ...
	'optType',{{'amean'}},...
	'putCallType',{{'call'}});
AsianCallSobCV = optPrice(EuroCallSob); %construct an Asian and European optPayoff object for CV
AsianCallSobCV.payoffParam = struct( ...
	'optType',{{'amean','gmean'}},...
	'putCallType',{{'call','call'}});
AsianCallSobCV.priceParam.cubMethod = 'SobolCV';
AsianCallSobDiff = optPrice(AsianCallSobPCA); %construct an Asian optPrice object with time differencing
AsianCallSobDiff.bmParam.assembleType = 'diff';
AsianCallIIDDiff = optPrice(AsianCallSobDiff); %construct an Asian optPrice object with time differencing
AsianCallIIDDiff.inputType = 'n';
AsianCallIIDDiff.wnParam = struct('sampleKind', 'IID', 'xDistrib','Gaussian');
AsianCallIIDDiff.priceParam.cubMethod = 'IID_MC';
AsianCallBayesLatticePCA = optPayoff(AsianCallSobPCA);
AsianCallBayesLatticePCA.wnParam.sampleKind = 'lattice';
AsianCallBayesSobolPCA = optPayoff(AsianCallSobPCA);

%% Construct a very accurate answer
disp('Gold standard')
compGold = true;
nGoldRep = 100;
if exist('callPriceExact','var') && ...
   absTolGold == ArchabsTolGold && nGoldRep == ArchnGoldRep && ...
   all(ArchAsianCall.timeDim.timeVector == AsianCall.timeDim.timeVector) && ...
   ArchAsianCall.assetParam.initPrice == AsianCall.assetParam.initPrice && ... %initial stock price
   ArchAsianCall.payoffParam.strike == ArchAsianCall.payoffParam.strike %strike price   
   compGold = false;
   disp('Already have gold standard Asian Call')
end
 
if compGold
   fCV.func = @(x) genOptPayoffs(AsianCallSobPCACV,x);
   fCV.cv = AsianCallSobPCACV.exactPrice(2:end); 
   d = AsianCallSobPCACV.timeDim.nSteps;
   callPriceGold(nGoldRep,1) = 0;  
   tic
   for ii = 1:nGoldRep
      gail.TakeNote(ii,1) %print out every 10th ii
      callPriceGold(ii) = ...
         cubSobol_g(fCV,[zeros(1,d); ones(1,d)],'uniform',absTolGold,relTol);
%       x = net(scramble(sobolset(AsianCall.timeDim.nSteps), ...
%          'MatousekAffineOwen'),nGold);
%       payoffAsianEuro = genOptPayoffs(AsianCall,x);
%       callPriceGold(ii) = mean(payoffAsianEuro(:,1));
%       payoffAsianEuro = genOptPayoffs(AsianCallSobPCACV,x);
%       temp = payoffAsianEuro(:,1) - AsianCallSobPCACV.exactPrice(2) + payoffAsianEuro(:,2);
%       callPriceGold(ii) = mean(temp);
   end
   callPriceExact = mean(callPriceGold);
   toc
end
disp(['mu  = ' num2str(callPriceExact,15) ' +/- ' num2str(2*std(callPriceGold),10)])
%return

%% Try automatic Sobol' PCA cubature
disp('Automatic Sobol'' PCA cubature')
nRepAuto = 100;
timeVecAsianCallSobPCAAuto(nRepAuto,1) = 0;
nVecAsianCallSobPCAAuto(nRepAuto,1) = 0;
compCallAuto = true;
if exist(dataFileName,'file')
   if exist('muAsianCallSobPCAAuto','var') && ...
      numel(nRepAuto) == numel(ArchnRepAuto) && ...
      ArchAbsTol == absTol && ...
      ArchRelTol == relTol 
      compCallAuto = false;
      disp('Already have automatic scrambled Sobol PCA Asian Call')
   end
end
if compCallAuto || redo
   muAsianCallSobPCAAuto(nRepAuto,1) = 0;
   tic
   for i =  1:nRepAuto
      gail.TakeNote(i,10)
      [muAsianCallSobPCAAuto(i),outCall] = genOptPrice(AsianCallSobPCA);
      timeVecAsianCallSobPCAAuto(i) = outCall.time;
      nVecAsianCallSobPCAAuto(i) = outCall.nPaths;    
   end
   toc
end
errvecAsianCallSobPCAAuto = abs(callPriceExact - muAsianCallSobPCAAuto);
errmedAsianCallSobPCAAuto = median(errvecAsianCallSobPCAAuto);
errtopAsianCallSobPCAAuto = quantile(errvecAsianCallSobPCAAuto,1-alpha);
rangeAsianCallSobPCAAuto = range(muAsianCallSobPCAAuto);
timetopAsianCallSobPCAAuto = quantile(timeVecAsianCallSobPCAAuto,1-alpha);
ntopAsianCallSobPCAAuto = quantile(nVecAsianCallSobPCAAuto,1-alpha);
successAsianCallSobPCAAuto = mean(errvecAsianCallSobPCAAuto <= absTol);

%% Try automatic Sobol PCA control variates
disp('Automatic Sobol'' PCA control variates')
timeVecAsianCallSobPCACVAuto(nRepAuto,1) = 0;
nVecAsianCallSobPCACVAuto(nRepAuto,1) = 0;
compCallCVAuto = true;
if exist(dataFileName,'file')
   if exist('muAsianCallSobPCACVAuto','var') && ...
      numel(nRepAuto) == numel(ArchnRepAuto) && ...
      ArchAbsTol == absTol && ...
      ArchRelTol == relTol 
      compCallCVAuto = false;
      disp('Already have automatic scrambled Sobol Asian Call with control variates')
   end
end
if compCallCVAuto || redo
   muAsianCallSobPCACVAuto(nRepAuto,1) = 0;
   tic
   for i =  1:nRepAuto
      gail.TakeNote(i,10)
      [muAsianCallSobPCACVAuto(i),outCallCV] = genOptPrice(AsianCallSobCV);
      timeVecAsianCallSobPCACVAuto(i) = outCallCV.time;
      nVecAsianCallSobPCACVAuto(i) = outCallCV.nPaths;    
   end
   toc
end
errvecAsianCallSobPCACVAuto = abs(callPriceExact - muAsianCallSobPCACVAuto);
errmedAsianCallSobPCACVAuto = median(errvecAsianCallSobPCACVAuto);
errtopAsianCallSobPCACVAuto = quantile(errvecAsianCallSobPCACVAuto,1-alpha);
rangeAsianCallSobPCACVAuto = range(muAsianCallSobPCACVAuto);
timetopAsianCallSobPCACVAuto = quantile(timeVecAsianCallSobPCACVAuto,1-alpha);
ntopAsianCallSobPCACVAuto = quantile(nVecAsianCallSobPCACVAuto,1-alpha);
successAsianCallSobPCACVAuto = mean(errvecAsianCallSobPCACVAuto <= absTol);

%% Try automatic Sobol' time differencing cubature
disp('Automatic Sobol'' time differencing cubature')
nRepAuto = 100;
timeVecAsianCallSobDiffAuto(nRepAuto,1) = 0;
nVecAsianCallSobDiffAuto(nRepAuto,1) = 0;
compCallSobDiffAuto = true;
if exist(dataFileName,'file')
   if exist('muAsianCallSobDiffAuto','var') && ...
      numel(nRepAuto) == numel(ArchnRepAuto) && ...
      ArchAbsTol == absTol && ...
      ArchRelTol == relTol 
      compCallSobDiffAuto = false;
      disp('Already have automatic scrambled Sobol Diff Asian Call')
   end
end
if compCallSobDiffAuto || redo
   muAsianCallSobDiffAuto(nRepAuto,1) = 0;
   tic
   for i =  1:nRepAuto
      gail.TakeNote(i,10)
      [muAsianCallSobDiffAuto(i),outCall] = genOptPrice(AsianCallSobDiff);
      timeVecAsianCallSobDiffAuto(i) = outCall.time;
      nVecAsianCallSobDiffAuto(i) = outCall.nPaths;    
   end
   toc
end
errvecAsianCallSobDiffAuto = abs(callPriceExact - muAsianCallSobDiffAuto);
errmedAsianCallSobDiffAuto = median(errvecAsianCallSobDiffAuto);
errtopAsianCallSobDiffAuto = quantile(errvecAsianCallSobDiffAuto,1-alpha);
rangeAsianCallSobDiffAuto = range(muAsianCallSobDiffAuto);
timetopAsianCallSobDiffAuto = quantile(timeVecAsianCallSobDiffAuto,1-alpha);
ntopAsianCallSobDiffAuto = quantile(nVecAsianCallSobDiffAuto,1-alpha);
successAsianCallSobDiffAuto = mean(errvecAsianCallSobDiffAuto <= absTol);

%% Try automatic IID time differencing cubature
disp('Automatic IID time differencing cubature')
nRepAuto = 100;
timeVecAsianCallIIDDiffAuto(nRepAuto,1) = 0;
nVecAsianCallIIDDiffAuto(nRepAuto,1) = 0;
compCallIIDDiffAuto = true;
if exist(dataFileName,'file')
   if exist('muAsianCallIIDDiffAuto','var') && ...
      numel(nRepAuto) == numel(ArchnRepAuto) && ...
      ArchAbsTol == absTol && ...
      ArchRelTol == relTol 
      compCallIIDDiffAuto = false;
      disp('Already have automatic IID Diff Asian Call')
   end
end
if compCallIIDDiffAuto || redo
   muAsianCallIIDDiffAuto(nRepAuto,1) = 0;
   tic
   for i =  1:nRepAuto
      gail.TakeNote(i,1)
      [muAsianCallIIDDiffAuto(i),outCall] = genOptPrice(AsianCallIIDDiff);
      timeVecAsianCallIIDDiffAuto(i) = outCall.time;
      nVecAsianCallIIDDiffAuto(i) = outCall.nPaths;    
   end
   toc
end
errvecAsianCallIIDDiffAuto = abs(callPriceExact - muAsianCallIIDDiffAuto);
errmedAsianCallIIDDiffAuto = median(errvecAsianCallIIDDiffAuto);
errtopAsianCallIIDDiffAuto = quantile(errvecAsianCallIIDDiffAuto,1-alpha);
rangeAsianCallIIDDiffAuto = range(muAsianCallIIDDiffAuto);
timetopAsianCallIIDDiffAuto = quantile(timeVecAsianCallIIDDiffAuto,1-alpha);
ntopAsianCallIIDDiffAuto = quantile(nVecAsianCallIIDDiffAuto,1-alpha);
successAsianCallIIDDiffAuto = mean(errvecAsianCallIIDDiffAuto <= absTol);

%% Try automatic Bayesian lattice cubature
disp('Automatic Bayesian lattice cubature')
nRepAuto = 100;
timeVecAsianCallBayesLatticePCAAuto(nRepAuto,1) = 0;
nVecAsianCallBayesLatticePCAAuto(nRepAuto,1) = 0;
compCallBayesLatticePCAAuto = true;
if exist(dataFileName,'file')
   if exist('muAsianCallBayesLatticePCAAuto','var') && ...
      numel(nRepAuto) == numel(ArchnRepAuto) && ...
      ArchAbsTol == absTol && ...
      ArchRelTol == relTol 
      compCallBayesLatticePCAAuto = false;
      disp('Already have automatic Bayesian lattice Asian Call')
   end
end
if compCallBayesLatticePCAAuto || redo || true
   muAsianCallBayesLatticePCAAuto(nRepAuto,1) = 0;
   arbMean = true;
   tic
   for i = 1:nRepAuto
      gail.TakeNote(i,10)
      %Here is my version
      [muAsianCallBayesLatticePCAAuto(i),outCall] ...
         = cubBayesLattice(@(x) genOptPayoffs(AsianCallBayesLatticePCA,x), ...
         numel(AsianCallBayesLatticePCA.timeDim.timeVector),absTol,relTol,2,arbMean);
      %Here is your version
%       objCubMLE = cubMLELattice('f',@(x) genOptPayoffs(AsianCallBayesLatticePCA,x), ...
%          'dim', numel(AsianCallBayesLatticePCA.timeDim.timeVector), ...
%          'absTol', absTol,'relTol', relTol, 'order', 2, ...
%          'ptransform', 'Baker', 'arbMean', arbMean,'stopAtTol',true);
%       [muAsianCallBayesLatticePCAAuto(i),outCall] = compInteg(objCubMLE);
      timeVecAsianCallBayesLatticePCAAuto(i) = outCall.time;
      nVecAsianCallBayesLatticePCAAuto(i) = outCall.n;    
   end
   toc
end
errvecAsianCallBayesLatticePCAAuto = abs(callPriceExact - muAsianCallBayesLatticePCAAuto);
errmedAsianCallBayesLatticePCAAuto = median(errvecAsianCallBayesLatticePCAAuto);
errtopAsianCallBayesLatticePCAAuto = quantile(errvecAsianCallBayesLatticePCAAuto,1-alpha);
rangeAsianCallBayesLatticePCAAuto = range(muAsianCallBayesLatticePCAAuto);
timetopAsianCallBayesLatticePCAAuto = quantile(timeVecAsianCallBayesLatticePCAAuto,1-alpha);
ntopAsianCallBayesLatticePCAAuto = quantile(nVecAsianCallBayesLatticePCAAuto,1-alpha);
successAsianCallBayesLatticePCAAuto = mean(errvecAsianCallBayesLatticePCAAuto <= absTol);

%% Try automatic Bayesian Sobol cubature
disp('Automatic Bayesian Sobol cubature')
nRepAuto = 100;
timeVecAsianCallBayesSobolPCAAuto(nRepAuto,1) = 0;
nVecAsianCallBayesSobolPCAAuto(nRepAuto,1) = 0;
compCallBayesSobolPCAAuto = true;
if exist(dataFileName,'file')
   if exist('muAsianCallBayesSobolPCAAuto','var') && ...
      numel(nRepAuto) == numel(ArchnRepAuto) && ...
      ArchAbsTol == absTol && ...
      ArchRelTol == relTol 
      compCallBayesSobolPCAAuto = false;
      disp('Already have automatic Bayesian Sobol Asian Call')
   end
end
if compCallBayesSobolPCAAuto || redo
   muAsianCallBayesSobolPCAAuto(nRepAuto,1) = 0;
   arbMean = true;
   tic
   for i = 1:nRepAuto
      gail.TakeNote(i,10)
      [muAsianCallBayesSobolPCAAuto(i),outCall] ...
         = cubBayesSobol(@(x) genOptPayoffs(AsianCallBayesSobolPCA,x), ...
         numel(AsianCallBayesSobolPCA.timeDim.timeVector),absTol,relTol,2,arbMean);
      timeVecAsianCallBayesSobolPCAAuto(i) = outCall.time;
      nVecAsianCallBayesSobolPCAAuto(i) = outCall.n;    
   end
   toc
end
errvecAsianCallBayesSobolPCAAuto = abs(callPriceExact - muAsianCallBayesSobolPCAAuto);
errmedAsianCallBayesSobolPCAAuto = median(errvecAsianCallBayesSobolPCAAuto);
errtopAsianCallBayesSobolPCAAuto = quantile(errvecAsianCallBayesSobolPCAAuto,1-alpha);
rangeAsianCallBayesSobolPCAAuto = range(muAsianCallBayesSobolPCAAuto);
timetopAsianCallBayesSobolPCAAuto = quantile(timeVecAsianCallBayesSobolPCAAuto,1-alpha);
ntopAsianCallBayesSobolPCAAuto = quantile(nVecAsianCallBayesSobolPCAAuto,1-alpha);
successAsianCallBayesSobolPCAAuto = mean(errvecAsianCallBayesSobolPCAAuto <= absTol);

%% Save output
clear redo
save(dataFileName)

