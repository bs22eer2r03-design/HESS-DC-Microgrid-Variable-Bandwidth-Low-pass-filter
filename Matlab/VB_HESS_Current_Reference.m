function [Ibat_ref, Isc_ref, BW] = VB_HESS_Current_Reference(Ihess_ref, Vsc)
% Variable-bandwidth HESS current-reference generation
%
% Inputs:
%   Ihess_ref : Total HESS current reference [A]
%   Vsc       : Supercapacitor voltage [V]
%
% Outputs:
%   Ibat_ref  : Battery current reference [A]
%   Isc_ref   : Supercapacitor current reference [A]
%   BW        : Variable LPF bandwidth [rad/s]

%% Supercapacitor parameters
Vsc_max = 16;          % Rated SC voltage [V]

%% Variable-bandwidth limits
BW_min = 125;          % Minimum bandwidth [rad/s]
BW_mid = 1000;         % Intermediate bandwidth [rad/s]
BW_max = 5000;         % Maximum bandwidth [rad/s]

%% SC voltage regions
Vsc_high = 0.50*Vsc_max;     % 50% of rated voltage
Vsc_low  = 0.25*Vsc_max;     % 25% of rated voltage

%% Select bandwidth according to SC voltage
if Vsc > Vsc_high

    % SC has sufficient energy
    BW = BW_min;

elseif Vsc > Vsc_low

    % Medium SC voltage
    BW = BW_mid;

else

    % Low SC voltage
    % SC current is restricted; battery supplies more power
    BW = BW_max;

end

%% LPF calculation
% This part should be implemented using a discrete LPF in Simulink.
% For a continuous-time representation:
%
%       Ibat_ref(s) = BW/(s + BW) * Ihess_ref(s)
%
%       Isc_ref = Ihess_ref - Ibat_ref

persistent Ibat_previous
if isempty(Ibat_previous)
    Ibat_previous = 0;
end

%% Discrete-time LPF
Ts = 1e-4;       % Sampling time [s]

alpha = (BW*Ts)/(1 + BW*Ts);

Ibat_ref = Ibat_previous + alpha*(Ihess_ref - Ibat_previous);

Ibat_previous = Ibat_ref;

%% SC reference current
Isc_ref = Ihess_ref - Ibat_ref;

end