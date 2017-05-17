% Allison, Alexander, Jasmine, Saba
% Bioen 485 model

%% Bergman Model
clear all; close all; clc;

% initial conditions
G0 = 256;
I0 = .99;
X0 = 0;
IDR0 = 0;
Gb = 100;

% for model containing IDR
initCond = [G0 I0 I0 IDR0];

% scale factor; sensitivity of 2nd phase insulin release
gamma = 3.42/(10^3);
% threshold for insulin release (glucose conc)
h = 153;
% clearance rate of insulin
n = 0.13;

% parameters
p1 = -1.8/(10^2);
p2 = -1.08/(10^2);
p3 = 2.29/(10^6);

% dG = (p1 - X)*G + p4;
% dX = p2*X + p3*I;
% dI = IDR - n*I;
% dIDR = gamma*(G - h)*t - n*I;

tspan = [0 250];
% including IDR
% 1)dG, 2)dX, 3)dI, 4)dIDR
% [t,y] = ode45(@(t,y) [(p1 - y(2))*y(1) - (p1*Gb); p2*y(2) + p3*y(3); y(4) - n*y(3); gamma*(y(1) - h)*t - n*y(3)], tspan, initCond);

% without IDR
% 1)dG, 2)dX, 3)dI, 4)dIDR
[t,y] = ode45(@(t,y) [(p1 - y(2))*y(1) - (p1*Gb); p2*y(2) + p3*y(3); 0.01*(gamma*(y(1) - h)*t - n*y(3))], tspan, [G0 X0 I0]);

% plot of all curves on one graph (without IDR)
plot(t,y);
legend('G','X','I');

% plot individual curves
figure;
plot(t,y(:,1));
xlabel('G');
figure;
plot(t,y(:,2));
xlabel('X');
figure;
plot(t,y(:,3));
xlabel('I');