% Allison, Alexander, Jasmine, Saba
% Metformin Input function
% dX

function dx=differential(t,x,P)
    dosage=400; % mg-- This number should be multiplied by the pulse train
                % to give the right input
    w=30;       % sec-width of every pulse
    T_hr=6;     % hr-period
    T=T_hr*3600;% sec-Period
    Obs_hr=72;  % hr-observation time
    Obs=72*3600;% sec-observation time
    d=w:T:Obs;  % (determines where the middle of the pulse locates):Period:
                % (until what range-duration of the observations in seconds)
    D=dosage*pulstran(t,d,'rectpuls',w);
    dx(1)=-x(1)*(P(1)+P(2))+D;
    dx(2)=x(1)*P(2)+x(4)*P(3)-x(2)*P(4);
    dx(3)=P(4)*x(2)+x(4)*P(5)-x(3)*P(6);
    dx(4)=x(3)*P(6)-x(4)*(P(5)+P(2)+P(7));
    
    dx=[dx(1);
        dx(2);
        dx(3);
        dx(4);
        ];
end

% ODEs--Just for clarification
% f1 = @(t,x)[-x(1)*(kg0+kgg)+D;
%             x(1)*kgg+x(4)*ksg-x(2)*kgl;
%             kgl*x(2)+x(4)*ksl-x(3)*kls;
%             x(3)*kls-x(4)*(ksl+ksg+ks0);
%             ];