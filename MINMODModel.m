% Allison, Alexander, Jasmine, Saba
% Bioen 485 model

%% MINMOD Model

clear all; close all; clc;

% initial conditions
G0 = 287;
I0 = 403.4/100;
X0 = 0;
Ib = 11/100;
Gb = 92; % mg/dL

initCond = [G0 I0 X0];

% scale factor; sensitivity of 2nd phase insulin release
gamma = 0.335e-2;
% threshold for insulin release (glucose conc)
h = 89.5;
% clearance rate of insulin
n = 0.3;

% parameters
p1 = 0.399e-1;
p2 = 0.2e-1;
p3 = 0.4e-4;

% dG = (p1 - X)*G + p4;
% dX = p2*X + p3*I;
% dI = IDR - n*I;
% dIDR = gamma*(G - h)*t - n*I;

tspan = [0 2000];
% including IDR
% 1)dG, 2)dX, 3)dI, 4)dIDR
% [t,y] = ode45(@(t,y) [(p1 - y(2))*y(1) - (p1*Gb); p2*y(2) + p3*y(3); y(4) - n*y(3); gamma*(y(1) - h)*t - n*y(3)], tspan, initCond);

% without IDR
% 1)dG, 2)dX, 3)dI, 4)dIDR
[t,y] = ode45(@(t,y) [-(p1 + y(3))*y(1)+(p1*Gb); 
                         0.01*(gamma*(y(1) - h)*t - n*y(2));
                         -p2*y(3)+p3*(y(2) - Ib)], tspan, [G0 I0 X0]);

% plot of all curves on one graph (without IDR)
plot(t,y);
legend('G','X','I');

% plot individual curves
figure;
plot(t,y(:,1));
xlabel('G');
title('Glucose Concentration (mg/dL)');
figure;
plot(t,y(:,2));
xlabel('X');
title('Deep Compartment Insulin Concentration (mg/dL)');
figure;
plot(t,y(:,3));
xlabel('I');
title('Plasma Insulin Concentration (mg/dL)');