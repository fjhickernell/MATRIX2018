gail.InitializeWorkspaceDisplay %initialize the workspace and the display parameters
format long

visiblePlot=true;

%
% https://www.mathworks.com/matlabcentral/answers/98969-how-can-i-temporarily-avoid-figures-to-be-displayed-in-matlab
%
% if visiblePlot==false
%   set(0,'DefaultFigureVisible','off')
% else
%   set(0,'DefaultFigureVisible','on')
% end

if false
  %sampling='Lattice';
  sampling = 'Sobol';
  figSavePath = strcat(figSavePath, sampling, '/');
  [muhat,aMLE,err,out] = TestExpCosBayesianCubature(1,2,'none',...
    strcat(figSavePath, 'zeroMean/'),visiblePlot,false,false,sampling)
  
  [muhat,aMLE,err,out] = TestExpCosBayesianCubature(2,2,'none',...
    strcat(figSavePath, 'zeroMean/'),visiblePlot,false,false,sampling)
  
  [muhat,aMLE,err,out] = TestMVN_BayesianCubature(2,2,'Baker',...
    strcat(figSavePath, 'zeroMean/'),visiblePlot,false,false,sampling)
  fprintf('done')
end

stopAtTol = false;

tstart=tic;
pdTx = {'C1','C1sin', 'C2sin', 'C0', 'none', 'Baker'};
arbMeanType = true;
samplingMethod = {'Sobol', 'Lattice', }; % };
newPath = '.';
for sampling = samplingMethod

 for arbMean=arbMeanType

    if strcmp(sampling,'Sobol')
      transforms={'none'}; % no periodization used for Sobol points based algorithm
      bernOrder=[2]
    else
      transforms=pdTx;
      bernOrder=[2 4]
    end
    for tx=transforms
       tx
      for dim=[2 3 4]
         dim
        for bern=bernOrder
           bern
          TestKeisterBayesianCubature(dim,bern,tx{1},newPath,visiblePlot,arbMean,stopAtTol,sampling)
          %TestExpCosBayesianCubature(dim,bern,tx{1},newPath,visiblePlot,arbMean,stopAtTol,sampling)
          if dim~=4
            TestMVN_BayesianCubature(dim,bern,tx{1},newPath,visiblePlot,arbMean,stopAtTol,sampling)
          end
        end
      end
    end
  end
end
toc(tstart)

