function initGlobals()
    global forestSize;
    global fireBreakDist;
    global fireBreakWidth;

    forestSize = 20;
    fireBreakDist = 10;
    %the display width for the fire break roads. This is to make it
    %possible to still see the firebreaks when the forest is too large to
    %fit one forest-square in a pixel;
    %KEEP THIS 1 FOR NOW!!!!
    fireBreakWidth = 1;
    
    
    if(~(mod(forestSize,fireBreakDist)==0))
        disp('WARNING: forestSize is not a round multiple of fireBreakDist, output may be incorrect')
    end
    %creeer wegen-net (voor brandweer)
    forestSize = forestSize+(forestSize/fireBreakDist+1)*fireBreakWidth;
    

    global v0;
    global fireBreakFactor;
    global windDir;
    global windStr;
    global humidityMod;     
    global rainMod;         
    global tempFactor;
    
    
    windDir = (1/3)*pi;
    windStr = .3;
    v0 = .2;
    fireBreakFactor = 1;
    humidityMod = .1;       %[0 - .25]
    rainMod = .1;           %[0 - .25]
    temp = 15;
    tempLowBound = 10;
    tempHighBound = 35;
    tempFactorLowBound = .5;
    tempFactorHighBound = 2;
    
    if(temp < tempLowBound)
        tempFactor = tempFactorLowBound;
    elseif(temp < tempHighBound)
        rc = (tempFactorHighBound - tempFactorLowBound)/(tempHighBound- tempLowBound);
        y0 = -(rc*tempLowBound-tempFactorLowBound);
        tempFactor = rc*temp+y0;
    else
        tempFactor = 2;    
    end
    
    global fireStationCount;
    global fireTruckPerStationCount;
    global fighterPerTruckCount;
    global fighterWidth;
    global fireTruckSpeed;
    global fireFighterSpeed;
    
    fireStationCount = 1;
    fireTruckPerStationCount = 1;
    fighterPerTruckCount = 1;
    %The amount of extra tiles the firefighter will cover on top of the one
    %he is standing on.
    fighterWidth = 1;
    fireTruckSpeed = 1;
    fireFighterSpeed = 1;
    
end

