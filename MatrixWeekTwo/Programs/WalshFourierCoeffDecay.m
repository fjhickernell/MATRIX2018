function WalshFourierCoeffDecay(printc)
%[~,~,~,MATLABVERSION] = GAILstart(false);

%if usejava('jvm') || MATLABVERSION <= 7.12
    %% Garbage collection and initialization
    format compact %remove blank lines from output
    format long e %lots of digits
    %clearvars %clear all variables
    close all %close all figures
    gail.InitializeDisplay
    ColorOrder=get(gca,'ColorOrder'); close all
    set(0,'defaultaxesfontsize',28,'defaulttextfontsize',28) %make font larger
    set(0,'defaultLineLineWidth',3) %thick lines
    set(0,'defaultTextInterpreter','latex') %latex axis labels
    set(0,'defaultLegendInterpreter','latex') %latex axis labels
    set(0,'defaultLineMarkerSize',40) %latex axis labels
    if nargin < 1; printc='color'; end

    %% Initialize parameters
    rng(147)
    mmax = 20; %maximum number of points is 2^mmax
    nmax = 2^mmax;
    mdualvec = 11;
    mplot=16;
    % mmax=16; %maximum number of points is 2^mmax
    % mdualvec=11;
    % mplot=14;
    mlag=4;
    testfun=@(x) exp(-3*x).*sin(10*x.^2); d=1; %test function
    sobstr=sobolset(d);
    sobstr=scramble(sobstr,'MatousekAffineOwen');
    %sobol=qrandstream(sobstr);

    %% Plot function
    figure
    xplot=(0:0.002:1);
    yplot=testfun(xplot);
    if strcmp(printc,'color')
       plot(xplot,yplot,'-');
    else
       plot(xplot,yplot,'-k');
    end
    yminf=1.1*min(yplot);
    ymaxf=1.1*max(yplot);
    axis([0 1 yminf ymaxf])
    xlabel('\(x\)','interpreter','latex')
    ylabel('\(f(x)\)','interpreter','latex')
    text(0.05,-0.05,'\(f \in \mathcal{C}\)','color',MATLABBlue)
    print('FunctionWalshFourierCoeffDecay','-depsc');

    %% Evaluate Function and FWT
    n=2^mmax;
    xpts=sobstr(1:n,1:d);
    y=testfun(xpts);
    yval=y;
    %yfwt=fwht(y);

    %% Compute FWT
    for l=0:mmax-1
       nl=2^l;
       nmmaxlm1=2^(mmax-l-1);
       ptind=repmat([true(nl,1); false(nl,1)],nmmaxlm1,1);
       evenval=y(ptind);
       oddval=y(~ptind);
       y(ptind)=(evenval+oddval)/2;
       y(~ptind)=(evenval-oddval)/2;
    end

    %% Create kappanumap
    kappanumap=(1:n)'; %initialize map
    for l=mmax-1:-1:1
      nl=2^l;
      oldone=abs(y(kappanumap(2:nl))); %earlier values of kappa, don't touch first one
      newone=abs(y(kappanumap(nl+2:2*nl))); %later values of kappa, 
      flip=find(newone>oldone); %which in the pair are the larger ones
      if ~isempty(flip)
          flipall=bsxfun(@plus,flip,0:2^(l+1):2^mmax-1);
          flipall=flipall(:);
          temp=kappanumap(nl+1+flipall); %then flip 
          kappanumap(nl+1+flipall)=kappanumap(1+flipall); %them
          kappanumap(1+flipall)=temp; %around
      end
    end
    ymap=y(kappanumap);  

    %% Plot FW coefficients
    ltgray=0.8*ones(1,3);
    gray=0.5*ones(1,3);
    nplot=2^mplot;
    yfwtabs=abs(ymap);
    yfwtabsplot = yfwtabs(1:nplot);
    ymin=max(1e-15,min(yfwtabsplot));
    ymax=max([1; yfwtabsplot]);
    for mdual=mdualvec
       ndual=2^mdual;
       whdual=ndual*(1:2^(mplot-mdual)-1); %actual k values, +1 to get the positions
       whsmall=1:ndual-1;
       whbig=ndual:nplot-1;
       muse=mdual-mlag;
       nuse=2^muse;
       whuse=nuse/2:nuse-1;
       figure
       switch printc
           case 'color'
               loglog(1:nplot-1,yfwtabs(2:nplot),'.','MarkerSize',20, ...
                  'color', MATLABBlue);
%                h=loglog(whsmall,yfwtabs(whsmall+1),'.',...
%                   whbig,yfwtabs(whbig+1),'.',...
%                   whuse,yfwtabs(whuse+1),'.',...
%                   whdual,yfwtabs(whdual+1),'.','MarkerSize',20);
%                set(h([3 4]),'MarkerSize',40)
%                set(h(1),'Color','k');
%                set(h(2),'Color',0.7*[1 1 1]);
%                set(h(3),'Color',ColorOrder(5,:));
%                set(h(4),'Color',ColorOrder(2,:));
           case 'bw'
               h=zeros(4,1);
               h(1)=loglog(whsmall,yfwtabs(whsmall+1),'.',...
                  'MarkerSize',20,'MarkerFaceColor',ltgray,'MarkerEdgeColor',ltgray);
               hold on
               h(2)=loglog(whbig,yfwtabs(whbig+1),'.','MarkerSize',20,...
                  'MarkerFaceColor',gray,'MarkerEdgeColor',gray);
               h(3)=loglog(whuse,yfwtabs(whuse+1),'sk','MarkerSize',14,...
                  'MarkerFaceColor','k');
               h(4)=loglog(whdual,yfwtabs(whdual+1),'.k','MarkerSize',50);
       end
       maxexp=floor(log10(nplot-1));
       set(gca,'Xtick',10.^(0:maxexp))
       axis([1 nplot-1 ymin ymax])
       xlabel('\(\kappa\)','interpreter','latex')
       ylabel('\(|\hat{f}(k(\kappa))|\)','interpreter','latex')
%        legend(h([4 3]),{'error bound',...
%           ['$S_{' int2str(mdual-mlag) '}(f)$']},...
%           'location','southwest','interpreter','latex')
%       legend('boxoff')
       text(2,1e-12,'\(f \in \mathcal{C}\)','color',MATLABBlue)
       set(gca,'Position',[0.2 0.175 0.75 0.77])
       print(['WalshFourierCoeffDecay' int2str(nuse) '.eps'], '-depsc');
    end
 
    
    tailsum = sum(yfwtabs(ndual+1:end));
    sumuse = sum(yfwtabs(whuse+1));
    disp(['    Tail Sum = ' num2str(tailsum,'%4.15e')])
    disp(['Sum to Bound = ' num2str(sumuse,'%4.15e')])
    
    %% Plot filtered functions Fourier coefficients
    ydwt=y; %save original coefficients
    whkill=kappanumap(whuse+1); %choose ones to shrink
    y(whkill)=1e-6*y(whkill); %shrink them
    yfwtabs=abs(y(kappanumap));
    figure
    loglog(1:nplot-1,yfwtabs(2:nplot),'.','MarkerSize',20, ...
       'color',MATLABOrange);
    maxexp=floor(log10(nplot-1));
    set(gca,'Xtick',10.^(0:maxexp))
    axis([1 nplot-1 ymin ymax])
    xlabel('\(\kappa\)','interpreter','latex')
    ylabel('\(|\hat{f}(k(\kappa))|\)','interpreter','latex')
    text(2,1e-13,'\(f \notin \mathcal{C}\)','color',MATLABOrange)
    set(gca,'Position',[0.2 0.175 0.75 0.77])
    print('WalshFourierCoeffDecayFilter.eps', '-depsc');
    
    %% Compute FWT to get filtered function, plot it
    for l=0:mmax-1
       nl=2^l;
       nmmaxlm1=2^(mmax-l-1);
       ptind=repmat([true(nl,1); false(nl,1)],nmmaxlm1,1);
       evenval=y(ptind);
       oddval=y(~ptind);
       y(ptind)=(evenval+oddval)/2;
       y(~ptind)=(evenval-oddval)/2;
    end
    yfilter=(2.^mmax)*y;
    nplotf=2^10;
    [xsort,ii]=sort(xpts(1:nplotf));
    figure; 
    h=plot(xsort,yfilter(ii(1:nplotf)),'-','color',MATLABOrange);
    if strcmp(printc,'color')
       set(h,'Color',ColorOrder(2,:));
    end
    xlabel('\(x\)','interpreter','latex')
    ylabel('\(f(x)\)','interpreter','latex')
    axis([0 1 yminf ymaxf])
    text(0.05,-0.05,'\(f \notin \mathcal{C}\)','color',MATLABOrange)
    print('FilteredFunctionWalshFourierCoeffDecay', '-depsc');
    
    %% Plot error of filtered function
    err=abs(testfun(xsort)-yfilter(ii(1:nplotf)));
    figure;     
    h = plot(xsort,err,'k-');
    if strcmp(printc,'color')
       set(h,'Color',ColorOrder(1,:));
    end

    filteredtailsum = sum(yfwtabs(ndual+1:end));
    filteredsumuse = sum(yfwtabs(whuse+1));
    disp(['    Filtered Tail Sum = ' num2str(filteredtailsum,'%4.15e')])
    disp(['Filtered Sum to Bound = ' num2str(filteredsumuse,'%4.15e')])

    %close all
%end
end



