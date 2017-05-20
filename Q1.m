% Allison, Alexander, Jasmine, Saba
% PK model

clc, clear all, close all,

% time span domain
f_ex_hr = 10;            %time for final examination [hr]
f_ex    = f_ex_hr*3600;  %time for final examination [sec]
tspan   = 0:.1:f_ex;

% parameters
kg0=1.88e-03;
kgg=1.85e-03;
ksg=4.13;
kgl=0.458;
ksl=1.01e-02;
kls=0.910;
ks0=0.509;

params=[kg0, kgg, ksg, kgl, ksl, kls, ks0];

% ICs
X10=0;
X20=0;
X30=0;
X40=0;

IC=[X10;X20;X30;X40];

options=[];

[T,X] = ode45(@differential,tspan, IC,options,params);


figure (1)
plot(tspan,X(:,1)); hold on;
plot(tspan,X(:,2)); hold on;
plot(tspan,X(:,3)); hold on;
plot(tspan,X(:,4)); hold on;
xlabel('time (sec)')
ylabel('Metformin Amount')
