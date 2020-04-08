%%Plot Bernoulli polynomials

gail.InitializeWorkspaceDisplay
x = 0:0.001:1;

B2 = 1 + 5*bernoulli(2,abs(x-1/2));
B4 = 1 - 20*bernoulli(4,abs(x-1/2));
B6 = 1 + 30*bernoulli(6,abs(x-1/2));

figure
h = plot(x,B2,x,B4,x,B6);
xlabel('\(x\)')
%ylabel('\(1 - (-1)^{\theta_2} \theta_1 B_{\theta_2}(|x - 1/2|)\)') 
daspect([0.2 1 1])
legend(h,{'\(\theta_2 = 1\)', '\(\theta_2 = 2\)','\(\theta_2 = 3\)'});
legend boxoff
print -depsc BernoulliKernel.eps
