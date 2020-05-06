%%
d=dir('*RYG.mat');
repeats = 1;
FR = zeros(length(d)/repeats,63*63);
if repeats == 1
    for ii = 1:length(d)/repeats
        try
            R = load(fullfile(d(ii).folder,d(ii).name),'spike_hist');
            FR(ii,:) = sum(R.spike_hist{1},2)./size(R.spike_hist{1},2).*1e4;
        catch
            PostProcessGC_Random([d(ii).name(1:end-8),'.h5'])
            R = load(fullfile(d(ii).folder,d(ii).name),'spike_hist');
            FR(ii,:) = sum(R.spike_hist{1},2)./size(R.spike_hist{1},2).*1e4;
        end
        
    end
else
    for ii = 1:length(d)/repeats
        kk = 1;
        FR_temp = zeros(repeats,63*63);
        for jj = ((ii-1)*repeats+1):(ii*repeats)
            R = load(fullfile(d(ii).folder,d(ii).name),'spike_hist');
            FR_temp(kk,:) = sum(R.spike_hist{1},2);
            kk = kk + 1;
        end
        FR(ii,:) = nanmean(FR_temp,1)./size(R.spike_hist{1},2).*1e4;
    end
end
[COEFF, SCORE, LATENT, TSQUARED, EXPLAINED] = pca(zscore(FR));s
save('eigen_spectrum2.mat','FR')
figure
loglog(EXPLAINED)
xlabel('PCs')
ylabel('Explained Var')
title('my model')
saveas(gca,'eigenspectrum2.fig')
x = FR;
D=sqdist(x',x');
ndims=1000;
options.dims=1:ndims;
[Y, R, E] = IsoMap(D, 'k',5,options);


figure
plot(100*(1-cumsum(EXPLAINED(1:ndims-1))./sum(EXPLAINED)),'Color',[.7 .7 .7],'LineWidth',3)
hold on
plot(100*R,'Color',[0 0 0],'LineWidth',3)
legend({'PCA','Isomap'})
xlabel('num. dimensions')
ylabel('residual var. (%)')
saveas(gca,'pca_vs_isomap.fig')

figure
Ne = 63*63;
i=randi(Ne);
j=randi(Ne);
k=randi(Ne);
% surf(reshape(FR(:,i),[10,10]),reshape(FR(:,j),[10,10]),reshape(FR(:,k),[10,10]))
plot3(FR(:,i),FR(:,j),FR(:,k),'.-')

i=randi(Ne);
figure
surf(0.1:0.1:1,0.1:0.1:1,1000*reshape(FR(:,i),[10,10]))
set(gca,'LineWidth',1)
axis tight
xlabel('\sigma_1')
ylabel('\sigma_2')


