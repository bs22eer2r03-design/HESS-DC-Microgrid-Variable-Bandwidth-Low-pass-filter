clc;
clear;
close all;

%% ==========================
% Parameters
%% ==========================

HB = 1;
VM = 1;

fc = 5000;                 % Desired crossover frequency (Hz)

%% -------- Plant Parameters ----------
% Replace these with your calculated values

GidB0   = 8;             % DC gain
wziB     = 94;              % Resonant frequency (Hz)
QB       = 9;            % Quality factor
w0B    = 421;            % RHP/LHP zero frequency (Hz)

%% Angular frequencies

% w0B  = 2*pi*f0B;
% wziB = 2*pi*fziB;

%% Laplace variable

s = tf('s');

%% ====================================
% Battery Plant
%% ====================================

GidB = GidB0 * ...
      (1 + s/wziB) / ...
      (1 + s/(QB*w0B) + (s^2)/(w0B^2));

%% ====================================
% Uncompensated Open Loop
%% ====================================

TuB = (HB/VM)*GidB;

%% ====================================
% PI Compensator
%% ====================================

%wzc = 2*pi*fc/10;
%wpc = 2*pi*fc*10;

%% Controller gain
%
% Tune this until crossover becomes 5 kHz
%
kpsc=1.2;
kisc=1300;
wzc=kisc/kpsc;
GciB0 = kpsc;

GciB = GciB0 * ...
       (1 + wzc/s);

%% ====================================
% Compensated Open Loop
%% ====================================

TcB = GciB*TuB;

%% ====================================
% Bode Plot
%% ====================================

opts = bodeoptions;
opts.Grid = 'on';
opts.FreqUnits = 'Hz';
opts.XLim = [0.1 1e5];

figure
bodeplot(TuB,'b--',TcB,'r',opts)
legend('T_u_B','T_c_B')

%% ====================================
% Stability Margins
%% ====================================

disp('------------ Uncompensated ----------------')
margin(TuB)

figure
margin(TuB)
grid on

disp('------------ Compensated ------------------')
margin(TcB)

figure
margin(TcB)
grid on

%% ====================================
% Bode Plot (Both in One Figure)
%% ====================================

opts = bodeoptions;
opts.FreqUnits = 'Hz';       % Frequency in Hz
opts.Grid = 'on';
opts.XLim = [0.1 1e5];       % Frequency range
opts.MagUnits = 'dB';
opts.PhaseVisible = 'on';

figure;

h = bodeplot(TuB, TcB, opts);

% Line properties
setoptions(h,'FreqUnits','Hz','Grid','on');

% Add legend
legend('T_{uB}(s) - Uncompensated','T_{cB}(s) - Compensated',...
       'Location','southwest');

title('Battery Current Control Loop Bode Plot');