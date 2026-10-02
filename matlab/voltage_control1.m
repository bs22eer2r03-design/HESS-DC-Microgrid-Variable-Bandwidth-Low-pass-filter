clc;
clear;
close all;

%% ============================================================
% OUTER VOLTAGE CONTROL LOOP
% Uncompensated vs PI Compensated
%
% Given:
% Gidb_cl  = 1
% Gidsc_cl = 1
%
% Gvdc_OL(s) =
% GVBWF(s)*Gvib(s) + (1-GVBWF(s))*Gvis(s)
% ============================================================

s = tf('s');

%% ------------------------------------------------------------
% 1. SYSTEM PARAMETERS
% ------------------------------------------------------------

Rl  = 58;          % Load resistance (Ohm)
         % Resistance used in plant model (Ohm)
L   = 3.1e-3;      % Inductor (H)
Cdc = 430e-6;      % DC-link capacitor (F)

Dbat = 0.52;       % Battery converter duty ratio
Dsc  = 0.33;       % Supercapacitor converter duty ratio

% Variable bandwidth of VBW filter
w_variable = 125;  % rad/s

% Voltage feedback gain
Hv = 1;


%% ------------------------------------------------------------
% 2. VARIABLE BANDWIDTH LOW-PASS FILTER
% ------------------------------------------------------------

GVBWF = w_variable/(s + w_variable);


%% ------------------------------------------------------------
% 3. BATTERY-SIDE DC-LINK TRANSFER FUNCTION
%
% Gvib =
% Rl(1-Dbat)[1 - L/(R(1-Dbat)^2)]
% --------------------------------
%          2 + Rl*Cdc*s
% ------------------------------------------------------------

Gvib = (Rl*(1-Dbat) * ...
       (1 - L/(Rl*(1-Dbat)^2))) / ...
       (2 + Rl*Cdc*s);


%% ------------------------------------------------------------
% 4. SUPERCAPACITOR-SIDE DC-LINK TRANSFER FUNCTION
%
% Gvis =
% Rl(1-Dsc)[1 - L/(R(1-Dsc)^2)]
% ------------------------------
%          2 + Rl*Cdc*s
% ------------------------------------------------------------

Gvis = (Rl*(1-Dsc) * ...
       (1 - L/(Rl*(1-Dsc)^2))) / ...
       (2 + Rl*Cdc*s);


%% ------------------------------------------------------------
% 5. INNER CURRENT CLOSED-LOOP GAINS
% ------------------------------------------------------------

Gidb_cl  = 1;
Gidsc_cl = 1;


%% ============================================================
% PART 1: UNCOMPENSATED OUTER VOLTAGE CONTROL LOOP
% ============================================================

% Combined voltage-control plant
Gvdc_OL = GVBWF*Gidb_cl*Gvib + ...
          (1-GVBWF)*Gidsc_cl*Gvis;

% Include voltage feedback
Gvdc_OL = Gvdc_OL*Hv;


%% ------------------------------------------------------------
% UNCOMPENSATED BODE PLOT
% ------------------------------------------------------------

figure(1);

opts = bodeoptions;
opts.FreqUnits = 'Hz';
opts.Grid = 'on';

bodeplot(Gvdc_OL,{0.1,1e5},opts);
title('Uncompensated Outer Voltage Loop');


%% ------------------------------------------------------------
% UNCOMPENSATED STABILITY MARGINS
% ------------------------------------------------------------

[GM_unc,PM_unc,Wcg_unc,Wcp_unc] = margin(Gvdc_OL);

GM_unc_dB = 20*log10(GM_unc);

fprintf('\n');
fprintf('============================================================\n');
fprintf('       1. UNCOMPENSATED OUTER VOLTAGE CONTROL LOOP\n');
fprintf('============================================================\n');

fprintf('Gain Margin (GM)     = %.4f dB\n',GM_unc_dB);
fprintf('Phase Margin (PM)    = %.4f deg\n',PM_unc);
fprintf('Gain Crossover (Wgc) = %.4f rad/s\n',Wcg_unc);
fprintf('Phase Crossover (Wpc)= %.4f rad/s\n',Wcp_unc);

fprintf('Gain Crossover       = %.4f Hz\n',Wcg_unc/(2*pi));
fprintf('Phase Crossover      = %.4f Hz\n',Wcp_unc/(2*pi));


%% ============================================================
% PART 2: COMPENSATED OUTER VOLTAGE CONTROL LOOP
%           USING PI CONTROLLER
% ============================================================

% ------------------------------------------------------------
% Voltage PI controller
%
% Gpiv(s) = Kpv + Kiv/s
% ------------------------------------------------------------

Kpv = 0.339;
Kiv = 202;

Gpiv = Kpv + Kiv/s;


% Compensated open-loop gain
T_vdc_comp = Gpiv*Gvdc_OL;


%% ------------------------------------------------------------
% COMPENSATED BODE PLOT
% ------------------------------------------------------------

figure(2);

bodeplot(T_vdc_comp,{0.1,1e5},opts);
title('PI Compensated Outer Voltage Loop');


%% ------------------------------------------------------------
% COMPENSATED STABILITY MARGINS
% ------------------------------------------------------------

[GM_comp,PM_comp,Wcg_comp,Wcp_comp] = margin(T_vdc_comp);

GM_comp_dB = 20*log10(GM_comp);

fprintf('\n');
fprintf('============================================================\n');
fprintf('       2. PI COMPENSATED OUTER VOLTAGE CONTROL LOOP\n');
fprintf('============================================================\n');

fprintf('Voltage PI: Kp = %.4f, Ki = %.4f\n',Kpv,Kiv);

fprintf('Gain Margin (GM)     = %.4f dB\n',GM_comp_dB);
fprintf('Phase Margin (PM)    = %.4f deg\n',PM_comp);
fprintf('Gain Crossover (Wgc) = %.4f rad/s\n',Wcg_comp);
fprintf('Phase Crossover (Wpc)= %.4f rad/s\n',Wcp_comp);

fprintf('Gain Crossover       = %.4f Hz\n',Wcg_comp/(2*pi));
fprintf('Phase Crossover      = %.4f Hz\n',Wcp_comp/(2*pi));


%% ============================================================
% PART 3: UNCOMPENSATED AND COMPENSATED BODE PLOTS TOGETHER
% ============================================================

figure(3);

h1 = bodeplot(Gvdc_OL,{0.1,1e5},opts);
hold on;

h2 = bodeplot(T_vdc_comp,{0.1,1e5},opts);

grid on;

legend('Uncompensated','PI Compensated','Location','best');

title('Outer Voltage Loop: Uncompensated vs PI Compensated');


%% ============================================================
% PART 4: STABILITY COMPARISON
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('              3. STABILITY COMPARISON\n');
fprintf('============================================================\n');

fprintf('\n');
fprintf('Parameter              Uncompensated       PI Compensated\n');
fprintf('------------------------------------------------------------\n');

fprintf('GM (dB)                %10.4f          %10.4f\n', ...
        GM_unc_dB,GM_comp_dB);

fprintf('PM (deg)               %10.4f          %10.4f\n', ...
        PM_unc,PM_comp);

fprintf('Wgc (rad/s)            %10.4f          %10.4f\n', ...
        Wcg_unc,Wcg_comp);

fprintf('Wpc (rad/s)            %10.4f          %10.4f\n', ...
        Wcp_unc,Wcp_comp);

fprintf('Wgc (Hz)                %10.4f          %10.4f\n', ...
        Wcg_unc/(2*pi),Wcg_comp/(2*pi));

fprintf('Wpc (Hz)                %10.4f          %10.4f\n', ...
        Wcp_unc/(2*pi),Wcp_comp/(2*pi));

fprintf('------------------------------------------------------------\n');


%% ------------------------------------------------------------
% STABILITY INTERPRETATION
% ------------------------------------------------------------

if PM_unc > 0 && GM_unc_dB > 0
    fprintf('Uncompensated loop : STABLE based on positive GM and PM.\n');
else
    fprintf('Uncompensated loop : NOT STABLE / INSUFFICIENT MARGIN.\n');
end

if PM_comp > 0 && GM_comp_dB > 0
    fprintf('PI compensated loop: STABLE based on positive GM and PM.\n');
else
    fprintf('PI compensated loop: NOT STABLE / INSUFFICIENT MARGIN.\n');
end


%% ------------------------------------------------------------
% CHANGE IN STABILITY MARGINS
% ------------------------------------------------------------

fprintf('\n');
fprintf('============================================================\n');
fprintf('                 IMPROVEMENT WITH PI\n');
fprintf('============================================================\n');

fprintf('Change in GM = %.4f dB\n',GM_comp_dB - GM_unc_dB);
fprintf('Change in PM = %.4f deg\n',PM_comp - PM_unc);
fprintf('Change in Wgc = %.4f rad/s\n',Wcg_comp - Wcg_unc);
fprintf('Change in Wpc = %.4f rad/s\n',Wcp_comp - Wcp_unc);

fprintf('============================================================\n');


%% ------------------------------------------------------------
% DISPLAY TRANSFER FUNCTIONS
% ------------------------------------------------------------

fprintf('\n');
fprintf('Uncompensated Gvdc_OL(s):\n');
Gvdc_OL

fprintf('\nPI Controller Gpiv(s):\n');
Gpiv

fprintf('\nCompensated Open-Loop Gain:\n');
T_vdc_comp