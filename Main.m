% Allison, Alexander, Jasmine, Saba
% Combined model

clc; clear all; close all;

%% PK model
% time span domain
f_ex_hr = 72;            %time for final examination [hr]
f_ex    = f_ex_hr*60;  %time for final examination [sec]
tspan   = 0:.1:f_ex;

% parameters
kg0=(1.88e-03);
kgg=(1.85e-03);
ksg=4.13;
kgl=0.458;
ksl=(1.01e-02);
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

[T,X] = ode45(@differential,tspan,IC,options,params);


figure (1)
plot(tspan./60,X); hold on;
xlabel('time (hr)')
ylabel('Metformin Amount (mg)')
legend('gut lumen','gut wall', 'liver', 'plasma');
title('Metformin Amount in Response to Pulse Train');

%% Inhibition of Glucose production in liver

I_max_L= 0.378;       % maximum effect [dimensionless]
I_A_50_L=0.521;       % metformin amount at the biophase
                      % that produces 50% of maximal effect [micro-gram]
n_L=5;                % shape factor

PBF=5.92;             % plasma blood flow  ml/min/ 100 g body weight

Vc=70.23;

% Q_gl=kgl.*X(:,2)+PBF.*X(:,4)*10./Vc;              % metformin amount--for test [mg]
% % kgg.*X(:,1)-
% I_liver=(I_max_L.*(Q_gl).^n_L)./((kgl*I_A_50_L).^n_L+(Q_gl).^n_L);       
I_liver=(I_max_L.*(X(:,3)).^n_L)./((I_A_50_L).^n_L+(X(:,3)).^n_L);

%% Stimulation of glucose utilization in GI tract

E_max_GI= 0.486;       % maximum effect [dimensionless]
E_A_50_GI=0.431;       % metformin amount at the biophase
                       % that produces 50% of maximal effect [micro-gram]
n_GI=2;                % shape factor

% A_GI=400;            % metformin amount--for test [mg]

% Q_gg=kgg.*X(:,1);      % flux into GI wall
% 
% S_GI=(E_max_GI.*(Q_gg).^n_GI)./((kgg*E_A_50_GI).^n_GI+(Q_gg).^n_GI);
S_GI=(E_max_GI.*(X(:,2)).^n_GI)./((E_A_50_GI).^n_GI+(X(:,2)).^n_GI);

%% Stimulation of glucose utilization in muscles and fat tissues

E_max_S= 0.148;       % maximum effect [dimensionless]
E_A_50_S=1.024;        % metformin amount at the biophase
                      % that produces 50% of maximal effect [micro-gram]
n_S=5;                % shape factor


% A_S=400;              % metformin amount--for test [mg]

S_S=(E_max_S.*(X(:,4)).^n_S)./((E_A_50_S).^n_S+(X(:,4)).^n_S);

%% metformin-related change in glucose blood concentration
% parameters
kin_min=2.08;       % [mg/dl/min] zero-order rate of glucose into the body
kin=kin_min;        % [mg/dl/sec]
kout_min=5.42e-03;  % [1/min] first-order rate of glucose utilization
kout=kout_min;      % [1/sec]

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

R=zeros(length(tspan),1);
F=zeros(length(tspan),1);

R(1)=400;

%     mealGlucose = 100; %arbitrary, for now
%     w=15;
%     T_hr = 6; % hour period
%     T = T_hr*60; % minute period
%     Obs_hr = 10; % hour observation time
%     Obs = Obs_hr*60; % minute observation time
%     d=w:T:Obs;
%     D=mealGlucose/w*pulstran(tspan,d,'rectpuls',w);
absorptionFactor = 3; % Parameter can be fit
for i=1:(length(tspan)-1)
     F(i) = feeding(tspan(i),15,42);
     R(i+1)=R(i)+(kin.*(1-I_liver(i))-kout.*(1+S_GI(i)+S_S(i)).*R(i)).*(tspan(i+1)-tspan(i))+(F(i)./absorptionFactor);%+...
%     D(i);
%    R(i+1)=R(i)+(kin.*(1-I_liver(i))-kout.*(1+S_GI(i)+S_S(i)).*R(i)).*(tspan(i+1)-tspan(i));
end

norm_LB=zeros(length(tspan),1);            % Normal range--lower bound
norm_LB(:,1)=90;
norm_HB=zeros(length(tspan),1);            % Normal range--higher bound
norm_LB(:,1)=130;

figure(2)
plot(tspan./60,R); hold on;
plot(tspan./60,norm_LB,'b--');
plot(tspan./60,norm_HB,'b--');
xlabel('time (hr)')
ylabel('R (mg/dL)')
title('Differential Change in Glucose due to Metformin');
figure(3)
% plot(tspan/60,F)
% %ylim([0 400]);
% xlabel('time (hr)')
% ylabel('F (mg/dL)')
% title('Glucose Added by Feeding');