function initGlobals()
    global forestWidth;
    global forestHeight;
    global fireBreakDistX;
    global fireBreakDistY;
    global randomFireSpread;
    global randomSpeedReducer;
    global enableIgniteFlags;
    
    forestLength = 8999; %m
    tileWidth = 10; %m
    fireBreakCountX = 20;
    fireBreakCountY = 20;
    fireBreakWidthPhysX = 10; %m
    fireBreakWidthPhysY = 10; %m
    [fireBreakDistX, forestWidth] = calcForestSizes(forestLength, tileWidth, fireBreakCountX, fireBreakWidthPhysX);
    [fireBreakDistY, forestHeight] = calcForestSizes(forestLength, tileWidth, fireBreakCountY, fireBreakWidthPhysY);
    
    forestWidth = forestWidth+(forestWidth/fireBreakDistX)+1;
    forestHeight = forestHeight+(forestHeight/fireBreakDistY)+1;
    
    randomFireSpread = 0;
    %factor by which the speed at which the fire spreads is reduced as a
    %whole, but only when randomFireSpread is 1
    randomSpeedReducer = 2;
    enableIgniteFlags = 1;
    global v0;
    global fireBreakFactor;
    global windDir;
    global windStr;
    global humidityMod;     
    global rainMod;         
    global tempFactor;
    
    windDir = (1/3)*pi;
    windStr = .15;
    v0 = .2;
    fireBreakFactor = .2;
    humidityMod = .1;       %[0 - .25]
    rainMod = .1;           %[0 - .25]
    temp = 15;
    tempLowBound = 10;
    tempHighBound = 35;
    tempFactorLowBound = .5;
    tempFactorHighBound = 2;
    tempFactor = getTempFactor(temp, tempLowBound, tempHighBound, tempFactorLowBound, tempFactorHighBound);
    
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

function tempFactor = getTempFactor(temp, tempLowBound, tempHighBound, tempFactorLowBound, tempFactorHighBound)
    if(temp < tempLowBound)
        tempFactor = tempFactorLowBound;
    elseif(temp < tempHighBound)
        rc = (tempFactorHighBound - tempFactorLowBound)/(tempHighBound- tempLowBound);
        y0 = -(rc*tempLowBound-tempFactorLowBound);
        tempFactor = rc*temp+y0;
    else
        tempFactor = 2;    
    end
end

function [fireBreakDist,forestSize] = calcForestSizes(forestWidth, tileWidth, fireBreakCount, fireBreakWidthPhys)
    realForestWidth = forestWidth - fireBreakWidthPhys*(fireBreakCount); %m
    forestSize = round(realForestWidth/tileWidth);
    %The amount of tiles in one direction must be divisible by the amount
    %of firebreaks
    while(~(mod(forestSize, fireBreakCount+1)==0))
        forestSize = forestSize+1;    
    end
    
    fireBreakDist = forestSize/(fireBreakCount+1);
    widthDifference = (tileWidth*forestSize+ (fireBreakCount*fireBreakWidthPhys)) - forestWidth;
    widthDifferenceRatio = (widthDifference/forestWidth);
    realForestWidth = forestSize*tileWidth
    forestSize
    fireBreakDist
    widthDifference
    widthDifferenceRatio
end

