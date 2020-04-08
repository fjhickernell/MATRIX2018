%% Example
stopObj = CLTStopping %stopping criterion
distribObj = IIDDistribution; %IID sampling with uniform distribution
[sol, out] = integrate(KeisterFun, distribObj, stopObj)
stopObj.absTol = 1e-3; %decrease tolerance
[sol, out] = integrate(KeisterFun, distribObj, stopObj)