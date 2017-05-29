% Allison, Alexander, Jasmine, Saba
% Combined model

clear all; close all; clc

%% PK model
% time span domain
f_ex_hr = 48;            %time for final examination [hr]
f_ex    = f_ex_hr*3600;  %time for final examination [sec]
tspan   = 0:.1:f_ex;

% parameters
kg0=(1.88e-03)/60;
kgg=(1.85e-03)/60;
ksg=4.13/60;
kgl=0.458/60;
ksl=(1.01e-02)/60;
kls=0.910/60;
ks0=0.509/60;

params=[kg0, kgg, ksg, kgl, ksl, kls, ks0];

% ICs
X10=0;
X20=0;
X30=0;
X40=0;

IC=[X10;X20;X30;X40];

options=[];

[T,X] = ode45(@differential,tspan, IC,options,params);
hrs = tspan./60./60;


figure (1)
plot(hrs,X(:,1)); hold on;
plot(hrs,X(:,2)); hold on;
plot(hrs,X(:,3)); hold on;
plot(hrs,X(:,4)); hold on;
xlabel('time (hours)')
ylabel('Metformin Amount')
legend('gut lumen', 'gut wall', 'liver', 'plasma');

%% Inhibition of Glucose production in liver

I_max_L= 0.378;       % maximum effect [dimensionless]
I_A_50_L=521;         % metformin amount at the biophase
                      % that produces 50% of maximal effect [micro-gram]
n_L=5;                % shape factor

PBF=5.92;             % plasma blood flow  ml/min/ 100 g body weight

Q_gl=kgl.*X(:,2)+PBF.*X(:,4);              % metformin amount--for test [mg]

I_liver=(I_max_L.*(Q_gl).^n_L)./((kgl*I_A_50_L).^n_L+(Q_gl).^n_L);       


%% Stimulation of glucose utilization in GI tract

E_max_GI= 0.486;       % maximum effect [dimensionless]
E_A_50_GI=431;         % metformin amount at the biophase
                       % that produces 50% of maximal effect [micro-gram]
n_GI=2;                % shape factor

A_GI=400;              % metformin amount--for test [mg]

Q_gg=kgg.*X(:,1);      % flux into GI wall

S_GI=(E_max_GI.*(Q_gg).^n_GI)./((kgg*E_A_50_GI).^n_GI+(Q_gg).^n_GI);

%% Stimulation of glucose utilization in muscles and fat tissues

E_max_S= 0.486;       % maximum effect [dimensionless]
E_A_50_S=431;         % metformin amount at the biophase
                       % that produces 50% of maximal effect [micro-gram]
n_S=2;                % shape factor

% A_S=400;              % metformin amount--for test [mg]

S_S=(E_max_S.*(X(:,4)).^n_S)./((E_A_50_S).^n_S+(X(:,4)).^n_S);

%% metformin-related change and Feeding-related change in glucose blood concentration
% parameters
kin_min=2.08;       % [mg/dl/min] zero-order rate of glucose into the body
kin=kin_min/60;     % [mg/dl/sec]
kout_min=5.42e-03;  % [1/min] first-order rate of glucose utilization
kout=kout_min/60;   % [1/sec]

% Defining the ODE function
% N.B. Our group assumes that there should be a typo in the first term of
% equation. Because, according to Dayenka et al. (1993), the first term 
% should most probably be (1-I_liver) instead of (I-I_liver) 
% dRdt= @(t,r)[
%             kin.*(1-I_liver)-kout.*(1+S_GI+S_S).*r;
%             ];
% 
% tspan=0:0.1:20;
% R0=zeros(length(Q_gg),1);
% [T,R] = ode45(dRdt,tspan,R0,[]);


w=9000;       % sec-width of every pulse
             % [ref: Postparandial ...]
amount = 42; % grams

R=zeros(length(tspan),1);
F=zeros(length(tspan),1);


R(1)=400;
% G(1)=R(1)+Feed(1);

for i=1:(length(tspan)-1)
    F(i) = feeding(i,w,amount);
    R(i+1)=R(i)+(kin.*(1-I_liver(i))-kout.*(1+S_GI(i)+S_S(i)).*R(i)+feeding(tspan(i),w,amount));
%   G(i+1)=R(i+1)
end


figure(2)
plot(hrs,R)
xlabel('time (hours)')
ylabel('Glucose (mg/dL)')

figure(3)
plot(hrs,F)
xlabel('time (hours)')
ylabel('Glucose fed (mg/dL/s)')

