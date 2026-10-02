clc;
clear;
close all;

%% Battery converter parameters
Vo = 96;          % DC-link/output voltage (V)
C  = 430e-6;      % Output capacitor (F)
R  = 48;          % Load resistance (Ohm)
LBatt = 3.1e-3;   % Battery-side inductance (H)
DBatt = 0.52;     % Battery converter duty ratio

%% Define Laplace variable
s = tf('s');

%% Battery current-to-duty transfer function
Gid_Batt1 = (Vo*C*s + 2*Vo/R) / ...
           (LBatt*C*s^2 + (LBatt/R)*s + (1-DBatt)^2)

%% Display transfer function
disp('Battery current-to-duty transfer function:')
Gid_Batt1



w = logspace(1,5,1000);   % 10^1 to 10^5 rad/s

figure;
bode(Gid_Batt1,w);
grid on;
title('Bode Plot of G_{idB}(s)');


figure;
margin(Gid_Batt1);
grid on;
title('Gain and Phase Margin');

[Gm,Pm,Wcg,Wcp] = margin(Gid_Batt1);

fprintf('Gain Margin  = %.2f dB\n',20*log10(Gm));
fprintf('Phase Margin = %.2f deg\n',Pm);
fprintf('Gain Crossover Frequency = %.2f rad/s\n',Wcg);
fprintf('Phase Crossover Frequency = %.2f rad/s\n',Wcp);



%% PI controller
Kp = 0.168;
Ki = 570;

Gpibat = Kp + Ki/s;
%% %% Compensated open-loop transfer function
Gopen_Batt = Gpibat * Gid_Batt1;