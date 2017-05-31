% Allison, Alexander, Jasmine, Saba
% Feeding model in which a person eats three times a day, spaced by 5 hours
% and consumes A grams of glucose per meal
% w -> width, A -> amount in grams, t-> time in seconds
% Assumes a person with 5 liters of blood in their body

function dG=feeding(t,w,amount)
    IC = false;
    if (t<3*60)
        IC = true;
    end
    hr24 = 24*60;
    t = mod(t,hr24);
    dG = 0;
    if any(abs((0:.01:w)-t)<.0001)
        dG = (amount*1000)/(50*w*10);
    end
    hr5 = 5*60;
    lunch = w+hr5;
    if any(abs((lunch:.01:(lunch+w))-t)<.0001)
        dG = (amount*1000)/(50*w*10);
    end
    dinner = lunch+w+hr5;
    if any(abs((dinner:.01:(dinner+w))-t) < .0001)
        dG = (amount*1000)/(50*w*10);
    end
    if IC
        dG = 0;
    end
end