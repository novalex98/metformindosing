% Allison, Alexander, Jasmine, Saba
% PK model
function X = Arino_Diabetes()
clc, clear all, close all,

% time span domain
minmax = 240; % number of mintues
tspan   = 0:.1:minmax;

% parameters
% Subject 1
% Gb = 69; %mg/dL 
% b1 = .0226; % 1/min
% b2 = .0437; % 1/min
% b3 = 2.57; %pM/(mg/dl)
% b4 = 3.8*10^(-8); % 1/(min*pM)
% b5 = 20; % min
% b6 = 0.045; % pM/(min*(mg/dl))
% b7 = 1.56; % mg/(dl*min)
% b0 = 170; %mg/dl
% Ib = 71.3; %pM


% Subject 7
Gb = 87; %mg/dL 
b1 = .0001; % 1/min
b2 = .2196; % 1/min
b3 = .64; %pM/(mg/dl)
b4 = 3.73*10^(-4); % 1/(min*pM)
b5 = 23; % min
b6 = 0.096; % pM/(min*(mg/dl))
b7 = 1.24; % mg/(dl*min)
b0 = 311; %mg/dl
Ib = 37.9; %pM

% ICs
X10=Gb+b0;
X20=Ib+b3*b0;
X30=Gb*b5;

IC=[X10;X20;X30];

options=[];

len = length(tspan);

global T1
T1 = ones(len,1);
global X1
X1 = ones(len,1);
global count;
count = 0;


params=[b1, b2, b3, b4, b5, b6, b7, Gb];

[T,X] = ode45(@dGdI,tspan, IC,options,params);

glucose = X(:,1);
insulin = X(:,2);
integral = X(:,3);
figure (1)
plot(tspan,glucose); hold on;
plot(tspan,insulin); hold on;
%plot(tspan,integral); hold on;
xlabel('time (sec)')
ylabel('Amount')
legend('Glucose (mg/dl)', 'Insulin (pM)', 'integral of glucose');

end
function dx=dGdI(t,x,p)
    global T1
    global X1
    global count
    count = count + 1;
    T1(count) = t;
    X1(count) = x(1);
    dx(1)=-p(1)*x(1)-p(4).*x(2).*x(1)+p(7); % G(t)
    dx(2)=-p(2)*x(2)+(p(6)/p(5))*x(3); % I(t)
    dx(3)=x(1)-G(t-p(5),p); % integral of G(t). Y(t)
    
    dx=[dx(1);
        dx(2);
        dx(3);
        ];
end

function g=G(t,p)
    global T1
    global X1
    fnd = find(T1 == t, 1);
    if t < 0
        g = p(8);
    elseif ~isempty(fnd)
        indx = fnd;
        g = X1(indx);
    else 
        [m,closest] = min(abs(T1 - t));
        closest = closest(1);
        g = (X1(closest) + X1(closest+1))/2;
    end
end
