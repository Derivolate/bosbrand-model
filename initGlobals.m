function initGlobals()
    global forestWidth;
    global forestHeight;
    global fireBreakDistX;
    global fireBreakDistY;
    global randomFireSpread;
    global randomSpeedReducer;
    global enableIgniteFlags;
    
    
    %Size physical of the forest in meters (this should be the square root of 8000)
    forestSize = 10000;
    %The physical width of the tiles in meters. This should be kept constant
    tileWidth = 10;
    %The amount of firebreaks in the x and y direction
    fireBreakCountX = 10;
    fireBreakCountY = 10;
    %The width of the firebreaks for the x and y direction
    fireBreakWidthPhysX = 10; %m
    fireBreakWidthPhysY = 10; %m
    
    %Do some magic mathematics to compensate in the width and height of the
    %forest matrix for the firebreaks which won't take up any tiles (at
    %least not yet)
    [fireBreakDistX, forestWidth] = calcForestSizes(forestSize, tileWidth, fireBreakCountX, fireBreakWidthPhysX);
    [fireBreakDistY, forestHeight] = calcForestSizes(forestSize, tileWidth, fireBreakCountY, fireBreakWidthPhysY);
    %Now add one extra tile for each firebreak in the x and y direction
    forestWidth = forestWidth+(forestWidth/fireBreakDistX)+1;
    forestHeight = forestHeight+(forestHeight/fireBreakDistY)+1;
    
    %{
        If the fire has to spread randomly or determenistic.
        0 = deterministic
        1 = rolls a pseudo-random dice at the end of each calculation to
            decide if the fire spreads
        2 = changes the static base-speed of the firespread to a normally
            distributed factor (not implemented yet)
    %}
    randomFireSpread = 2;
    %factor by which the speed at which the fire spreads is reduced as a
    %whole, but only when randomFireSpread is 1.
    randomSpeedReducer = 3;
    %Optimize the code by keeping track wich parcels are already ignited
    %and which not so the algorithm can skip them
    enableIgniteFlags = 1;
    
    
    global v0;
    global v0sd;
    global fireBreakFactor;
    global windDir;
    global windStr;
    global gamma; 
    global tempFactor;
    
    %The direction in which the wind is blowing. This is measured in
    %radians starting at the axis to the right and then clockwise
    windDir = (1/3)*pi;
    %The wind strength
    windStr = .05;
    %The base value for the spreading of the fire. This is the mean if
    %randomFireSpread is set to 2;
    v0 = .2;
    %If randomFireSpread is set to 2, this is the standard deviation
    v0sd = .2;
    %This is the factor by which the total speed is reduced when the fire
    %hits a firebreak
    fireBreakFactor = .5;
    %A modifier to depict the humidity of the forest
    humidityMod = 0;
    %A modifier to depict the currently falling rain
    rainMod = 0;
    gamma = humidityMod+rainMod;
    %The temparature in celcius
    temp = 15;
    %The temperature value for which all values less then this will have a 
    %contstant factor
    tempLowBound = 10;
    %The temperature value for which all values higher then this will have
    %a constant factor
    tempHighBound = 35;
    %The lowest temperature factor
    tempFactorLowBound = .5;
    %The highest temperature factor
    tempFactorHighBound = 2;
    %Use a linear function to get the actual temperature factor
    tempFactor = getTempFactor(temp, tempLowBound, tempHighBound, tempFactorLowBound, tempFactorHighBound);
    
    global fireStationCount;
    global fireTruckPerStationCount;
    global fighterPerTruckCount;
    global fighterWidth;
    global fireTruckSpeed;
    global fireFighterSpeed;
    
    %The amount of fire station
    fireStationCount = 1;
    %The amount of firetrucks per fire station
    fireTruckPerStationCount = 1;
    %The amount of firefighters per firetruck
    fighterPerTruckCount = 1;
    
    %The amount of extra tiles the firefighter will cover on top of the one
    %he is standing on.
    fighterWidth = 1;
    %The speed in tiles/iteration at which the truck will drive
    fireTruckSpeed = 1;
    %The speed in tiles/iteration at which a firefighter will walk
    fireFighterSpeed = 1;
end

function tempFactor = getTempFactor(temp, tempLowBound, tempHighBound, tempFactorLowBound, tempFactorHighBound)
    %If the temperature is less then the minimum, than just use the lowest
    %factor
    if(temp < tempLowBound)
        tempFactor = tempFactorLowBound;
    %If the temperature lies between the minimum and the maximum, calculate
    %the factor by using a linear equation
    elseif(temp < tempHighBound)
        %The slope of the function
        rc = (tempFactorHighBound - tempFactorLowBound)/(tempHighBound- tempLowBound);
        %The intersection with the y-axis
        y0 = -(rc*tempLowBound-tempFactorLowBound);
        %The actual temperature factor
        tempFactor = rc*temp+y0;
    %If the temperature is higher than the maximum, just use the maximum
    %factor
    else
        tempFactor = 2;    
    end
end

function [fireBreakDist,forestSize] = calcForestSizes(forestWidth, tileWidth, fireBreakCount, fireBreakWidthPhys)
    %The length of the forest in meters minus the width of all the 
    %firebreaks combined
    realForestWidth = forestWidth - fireBreakWidthPhys*(fireBreakCount); %m
    
    %The length of the forest in tiles
    forestSize = round(realForestWidth/tileWidth);
    %The amount of tiles must be divisible by the amount of firebreaks+1 so
    %it can actually be divided in parcels. 
    %We look for the first number just above the calculated forestSize
    %which actually satisfies this condition
    while(~(mod(forestSize, fireBreakCount+1)==0))
        forestSize = forestSize+1;    
    end
    
    %The width of one parcel
    fireBreakDist = forestSize/(fireBreakCount+1);
    
    %Some stuff for debugging and statistics
    widthDifference = (tileWidth*forestSize+ (fireBreakCount*fireBreakWidthPhys)) - forestWidth;
    widthDifferenceRatio = (widthDifference/forestWidth);
    realForestWidth = forestSize*tileWidth;
    forestSize;
    fireBreakDist;
    widthDifference;
    widthDifferenceRatio;
end

