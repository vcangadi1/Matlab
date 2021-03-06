function Ep_map = plasmon_map(EELS)
%% PARALLEL ROUTINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%       EELS - EELS data structure. Low-loss spectrum data cube.
%
% Output:
%    plasmon - Plasmon map. Each pixel value is plasmon position value of
%              the respective spectrum.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Check for parallel workers
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    poolobj = parpool;
end

%% Plasmon map
if isfield(EELS, 'calibrated_energy_loss_axis')
    llow = EELS.calibrated_energy_loss_axis;
else
    if iscolumn(EELS.energy_loss_axis)
        E(1,1,1:length(EELS.energy_loss_axis)) = EELS.energy_loss_axis;
        llow = repmat(E, EELS.SI_x, EELS.SI_y);
    else
        E(1,1,1:length(EELS.energy_loss_axis)) = EELS.energy_loss_axis';
        llow = repmat(E, EELS.SI_x, EELS.SI_y);
    end
end

S = @(ii,jj) squeeze(EELS.SImage(ii,jj,:));
l = @(ii,jj) squeeze(llow(ii,jj,:));

Ep_map = zeros(EELS.SI_x,EELS.SI_y);

%%
id = zeros(EELS.SI_x, 1);
s = id;
f = id;

parfor_progress(EELS.SI_x);

c = parallel.pool.Constant(1:EELS.SI_y);
tic;
parfor ii = 1:EELS.SI_x
    s(ii) = now; % plotIntervals data
    Ep_map(ii,:) = arrayfun(@(jj) plasmon(l,S,ii,jj), c.Value);
    f(ii) = now; % plotIntervals data
    id(ii) = getMyTaskID; % plotIntervals data % getMyTaskID.m required
    
    parfor_progress;
end
parfor_progress(0);
toc;

% delete parallel pool object
delete(poolobj);

%%
%%
figure;
plotIntervals(s, f, id, min(s)); % plotIntervals
end

function Ep = plasmon(l,S,ii,jj)

fprintf('Fitting Spectrum (%d,%d)',ii,jj);
[~, Ep, ~, ~] = plasmon_fit(l(ii,jj), S(ii,jj));

end