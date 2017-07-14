clc
clear all

%% Load SI of high loss and low loss

load('C:\Users\elp13va.VIE\Desktop\EELS data\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat');
l = EELS.energy_loss_axis';

EELZ = load('C:\Users\elp13va.VIE\Desktop\EELS data\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat');
EELZ = EELZ.EELS;

%% Load differential cross sections

tic;
dfcCu = diffCS_L23(29,923,197,16.6,l);
dfcGa = diffCS_L23(31,1115,197,16.6,l);
dfcAs = diffCS_L23(33,1323,197,16.6,l);
dfc = [dfcCu, dfcGa, dfcAs];
toc;
%dc = [dfcCu, dfcGa, dfcAs];

%% define lb, ub, p0 for lsqcurvefit
lb = [0,0,0];
ub = [1E4,1E4,1E4];

p0 = [30,30,30];

%% fit background
tic;
for ii = 90:-1:1
    for jj = 43:-1:1
        fprintf('Fitting (%d,%d)\n',ii,jj);
        S = squeeze(EELS.SImage(ii,jj,:));
        % smooth spectrum with spline function
        S = feval(Spline(l,S),l);
        Sm(ii,jj,1:EELS.SI_z) = S;
        % correct dispersion
        Z = resample(squeeze(EELZ.SImage(ii,jj,:)),1,round(EELS.dispersion/EELZ.dispersion));
        % plural scatter differential cross-section
        %pdfcCu = plural_scattering(dfcCu, Z);
        %pdfcGa = plural_scattering(dfcGa, Z);
        %pdfcAs = plural_scattering(dfcAs, Z);
        pdfc = plural_scattering(dfc, Z);
        % model background with exponential function
        B(ii,jj,1:EELS.SI_z) = S - feval(Exponential_fit(l(1:63),S(1:63)),l);
        rS = squeeze(B(ii,jj,:));
        %fun = @(p,l) p(1)*pdfcCu + (p(2)+p(1))*pdfcGa + (p(3)+p(2)+p(1))*pdfcAs;% + (p(4)+p(3)+p(2)+p(1))*pdfcAl;
        fun = @(p,l) ([p(1),p(1)+p(2),p(1)+p(2)+p(3)] * pdfc')';
        p = lsqcurvefit(fun,p0,l,rS,lb,ub);
        %A(ii,jj) = p(1);
        %r(ii,jj) = p(2);
        Cu(ii,jj) = p(1);
        Ga(ii,jj) = p(2);
        As(ii,jj) = p(3);
        %Al(ii,jj) = p(4);
        %R2(ii,jj) = rsquare(rS, p(1)*pdfcCu + (p(2)+p(1))*pdfcGa + (p(3)+p(2)+p(1))*pdfcAs);
        R2(ii,jj) = rsquare(rS, fun(p,l));
    end
end
toc;

%%
EELB = EELS;
EELB.SImage = B;

plotEELS(EELB)