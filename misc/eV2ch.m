function ch = eV2ch(energy_loss_axis, eV, dim)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%       energy_loss_axis - Energy loss axis
%                     eV - Value of eV to which channel number is needed
%                    dim - Matrix dimension
% Output:
%                     ch - Channel number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
    dim = 1;
end

if isrow(energy_loss_axis)
    energy_loss_axis = energy_loss_axis';
end

if eV < energy_loss_axis(1)
    error('eV is BELOW the range of energy axis');
elseif eV > energy_loss_axis(end)
    error('eV is ABOVE the range of energy axis');
end

[~,ch] = min(abs(energy_loss_axis - eV), [], dim);