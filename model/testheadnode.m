dataroot = '/headnode1/dnao/stringer_data/';        
useGPU = 0;
addpath(genpath('/headnode1/dnao/stringer-pachitariu-et-al-2018b'));
for K = 1:2
    if K==1
        K=1;
        dat=load([dataroot,'natimg2800_M160825_MP027_2016-12-14.mat']);
        % discard responses from red cells (GAD+ neurons)
        nPCspont = 32;
        keepNAN = 0;
        if isfield(dat.stat,'redcell')
            stim = dat.stim;
            stim.resp = stim.resp(:, ~[dat.stat.redcell]);%
            stim.spont = stim.spont(:, ~[dat.stat.redcell]);
            %sum(~[dat.stat.redcell])
        else
            stim = dat.stim;
        end

        [respB,wstim] = loadProc2800(stim, nPCspont, keepNAN, 0);
        respAll{K}  = single(respB);
        istimAll{K} = single(wstim);
        nshuff = 10;
        A = double(respAll{K});
        ss0 = shuffledSpectrum(A, nshuff);
        ss  = nanmean(ss0,2);
        ss  = ss(:) / sum(ss);
        figure(1);
        loglog(ss/ss(1)); hold on;
    else
        [COEFF, SCORE, LATENT, TSQUARED, EXPLAINED] = pca(zscore([A(:,:,1),A(:,:,2)]));
        figure(1);loglog(EXPLAINED/EXPLAINED(1));hold off;
    end

end
legend('cvPCA eigenspectrum','PCA eigenspectrum');
xlabel('Dimension');ylabel('Variance');