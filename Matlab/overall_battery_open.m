%%=======================================================================
%  Bode Plot of Battery Current Control Loop
%  1. Open-loop Plant: GidB(s)
%  2. PI Compensator: GcB(s)
%  3. Open-loop Compensated System
%  4. Closed-loop Compensated System
%=======================================================================

clc;
clear;
close all;

%%--------------------- Plant Parameters --------------------------------
GidB0 = 8;
wziB  = 94;     % rad/s
w0B   = 428;    % rad/s
QB    = 9.04;
%%--------------------- PI Controller Gains -----------------------------
Kp = 0.6;             % Proportional gain
Ki = 235;             % Integral gain

%%--------------------- Transfer Functions ------------------------------
s = tf('s');

% Plant Transfer Function
GidB = GidB0*(1 + s/wziB) / ...
      (1 + s/(QB*w0B) + (s^2)/(w0B^2));

% PI Compensator
GcB = Kp + Ki/s;

% Open-loop Compensated Transfer Function
Gol = GcB*GidB;

% Closed-loop Transfer Function (Unity Feedback)
Gcl = feedback(Gol,1);

%%--------------------- Frequency Range ---------------------------------
% Frequency range: 0.1 rad/s to 10^5 rad/s
w = logspace(-1,5,1000);

opts = bodeoptions;
opts.Grid = 'on';
opts.FreqUnits = 'rad/s';
opts.XLim = {[1e-1 1e5]};

%%=======================================================================
% 1. Open-loop Plant
%%=======================================================================
figure;
bodeplot(GidB,w,opts);
title('Open-loop Plant Transfer Function G_{idB}(s)');

%%=======================================================================
% 2. PI Compensator
%%=======================================================================
figure;
bodeplot(GcB,w,opts);
title('PI Compensator G_c(s)');

%%=======================================================================
% 3. Open-loop Compensated System
%%=======================================================================
figure;
margin(Gol);
grid on;
title('Open-loop Compensated System G_c(s)G_{idB}(s)');

% Display Stability Margins
[GM,PM,Wcg,Wcp] = margin(Gol);

fprintf('\n========== Open-loop Stability Margins ==========\n');
fprintf('Gain Margin      = %.2f dB\n',20*log10(GM));
fprintf('Phase Margin     = %.2f deg\n',PM);
fprintf('Gain Cross-over  = %.2f rad/s\n',Wcg);
fprintf('Phase Cross-over = %.2f rad/s\n',Wcp);

%%=======================================================================
% 4. Closed-loop Transfer Function
%%=======================================================================
figure;
bodeplot(Gcl,w,opts);
title('Closed-loop Transfer Function');

%%--------------------- Optional Comparison -----------------------------
figure;
bodeplot(GidB,Gol,Gcl,w,opts);
grid on;
legend('Plant','Open-loop Compensated','Closed-loop',...
       'Location','southwest');
title('Comparison of Plant, Open-loop and Closed-loop');