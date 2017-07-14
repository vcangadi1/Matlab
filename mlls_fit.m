clc
clear all

%% input variables

% pixel location
ii = 28;
jj = 5;

% load core-loss spectrum and energy-loss
load('C:\Users\elp13va.VIE\Desktop\EELS data\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat');
l = EELS.energy_loss_axis';
S = squeeze(EELS.SImage(ii,jj,:));
%S = feval(Spline(l,S),l);

% Load low-loss spectrum and energy-loss
EELZ = load('C:\Users\elp13va.VIE\Desktop\EELS data\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat');
EELZ = EELZ.EELS;
ll = resample(squeeze(EELZ.SImage(ii,jj,:)),1,round(EELS.dispersion/EELZ.dispersion));

% Atomic Num
Z = [29,31,33];

% Energy onset in eV
Energy_onset_eV = [923,1115,1323];

% Beam energy in kV
E0 = 197;

% Collection angle in mrad
beta = 16.6;

% Load differential cross sections
tic;
dfcCu = diffCS_L23(Z(1),Energy_onset_eV(1),E0,beta,l);
dfcGa = diffCS_L23(Z(2),Energy_onset_eV(2),E0,beta,l);
dfcAs = diffCS_L23(Z(3),Energy_onset_eV(3),E0,beta,l);
dfc = [dfcCu, dfcGa, dfcAs];
toc;

% Plural scattering
tic;
%dfc = plural_scattering(dfc, ll);
toc;

%% Get Residue of the spectrum
% model background with exponential function
rS = S - feval(Exponential_fit(l(1:63),S(1:63)),l);

%% define lb, ub, p0 for lsqcurvefit
lb = [0,0,0];
ub = [1E4,1E4,1E4];

p0 = [30,30,30];

%% fit background
fun = @(p,l) ([p(1),p(1)+p(2),p(1)+p(2)+p(3)] * dfc')';
options = optimset('UseParallel','true','display','off');
p = lsqcurvefit(fun,p0,l,rS,lb,ub,options);
R2 = rsquare(rS, fun(p,l));

%% display
disp(p);
disp(R2);
plotEELS(l,rS)
plotEELS(l,fun(p,l))