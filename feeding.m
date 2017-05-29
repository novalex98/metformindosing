% Allison, Alexander, Jasmine, Saba
% Feeding model in which a person eats three times a day, spaced by 5 hours
% and consumes A grams of glucose per meal
% w -> width, A -> amount in grams, t-> time in seconds
% Assumes a person with 5 liters of blood in their body

function dG=feeding(t,w,amount)
    IC = false;
    if (t<3*60*60*10)
        IC = true;
    end
    hr24 = 24*60*60*10;
    t = mod(t,hr24);
    dG = 0;
    if any(t == 0:w)
        dG = (amount*1000)/(50*w);
    end
    hr5 = 5*60*60*10;
    lunch = w+hr5;
    if any(t == lunch:lunch+w)
        dG = (amount*1000)/(50*w);
    end
    dinner = lunch+w+hr5;
    if any(t == dinner:dinner+w)
        dG = (amount*1000)/(50*w);
    end
    if IC
        dG = 0;
    end
end