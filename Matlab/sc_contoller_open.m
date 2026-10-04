clc;
clear;
close all;
GidB0 = 8;
wziB  = 94;     % rad/s
w0B   = 428;    % rad/s
QB    = 9.04;

num = GidB0 * [1/wziB  1];
den = [1/w0B^2  1/(QB*w0B)  1];

GidB = tf(num, den);
% Bode Plot
figure;
bode(GidB);
grid on;
title('Bode Plot of G_{idB}(s)');


w = logspace(-1,6,1000);   % 10^-1 to 10^5 rad/s

figure;
bode(GidB,w);
grid on;
title('Bode Plot of G_{idB}(s)');

figure;
margin(GidB);
grid on;
title('Gain and Phase Margin');

[Gm,Pm,Wcg,Wcp] = margin(GidB);

fprintf('Gain Margin  = %.2f dB\n',20*log10(Gm));
fprintf('Phase Margin = %.2f deg\n',Pm);
fprintf('Gain Crossover Frequency = %.2f rad/s\n',Wcg);
fprintf('Phase Crossover Frequency = %.2f rad/s\n',Wcp);
