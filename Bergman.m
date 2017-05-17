% Allison, Alexander, Jasmine, Saba
% Bioen 485 model

%% Bergman Model

% initial conditions
G0 = 256;
I0 = 99;
IDR0 = 0;

initCond = [G0 I0 I0 IDR0];

% scale factor; sensitivity of 2nd phase insulin release
gamma = 3.42/(10^3);
% threshold for insulin release (glucose conc)
h = 153;
% clearance rate of insulin
n = 0.13;

p1 = -1.8/(10^2);
p2 = -1.08/(10^2);
p3 = 2.29/(10^4);

% X = (k4 + k6)*Iinterst;

% dG = (p1 - X)*G + p4;
% dX = p2*X + p3*I;
% dI = IDR - n*I;
% dIDR = gamma*(G - h)*t - n*I;

% 1)dG, 2)dX, 3)dI, 4)dIDR
% f = @(t,y) [(p1 - y(2))*y(1) - (p1*G0), p2*y(2) + p3*y(3), y(4) - n*y(3), gamma*(y(1) - h)*t - n*y(3)];

tspan = [0 100];

[t,y] = ode45(@(t,y) [(p1 - y(2))*y(1) - (p1*G0); p2*y(2) + p3*y(3); y(4) - n*y(3); gamma*(y(1) - h)*t - n*y(3)], tspan, initCond);
