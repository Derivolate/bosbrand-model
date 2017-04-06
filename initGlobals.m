function initGlobals()
% the ones we vary are here
    global fireBreakWidthPhysX;
    global fireBreakWidthPhysY;
    global fireBreakCountX;
    global fireBreakCountY;
    global fireStationCount;
    global extraTrucks
%     
%     fireBreakWidthPhysX = 10; %m
%     fireBreakWidthPhysY = 10; %m
%     fireBreakCountY = 2;
%     fireBreakCountX = 2*fireBreakCountY;
%     fireStationCount = 3;

    


    global forestWidth;
    global forestHeight;
    global fireBreakDistX;
    global fireBreakDistY;
    global randomFireSpread;
    global randomSpeedReducer;
    global enableIgniteFlags;
    %These variables are global because they are needed for the calculation
    %of the costs and the environment damage
%     global fireBreakWidthPhysX;
%     global fireBreakWidthPhysY;
%     global fireBreakCountX;
%     global fireBreakCountY;
    global tileWidth;
    %Size physical of the forest in meters (this should be the square root of 80000)
    forestSize = 8.9*10^3;
    %The physical width of the tiles in meters. This should be kept constant
    tileWidth = 10;
    %The amount of firebreaks in the x and y direction
%     fireBreakCountX = 15;
%     fireBreakCountY = 15;
    %The width of the firebreaks for the x and y direction
%     fireBreakWidthPhysX = 10; %m
%     fireBreakWidthPhysY = 10; %m
    
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
            distributed factor 
    %}
    randomFireSpread = 2;
    %factor by which the speed at which the fire spreads is reduced as a
    %whole, but only when randomFireSpread is 1.
    randomSpeedReducer = 3; %DEPRECATED
    %Optimize the code by keeping track wich parcels are already ignited
    %and which not so the algorithm can skip them
    enableIgniteFlags = 1;
    
    
    global v0;
    global v0sd;
    global fireBreakFactorX;
    global fireBreakFactorY;
    global windDir;
    global windStr;
    global gamma; 
    global tempFactor;
    
    %The direction in which the wind is blowing. This is measured in
    %radians starting at the axis to the right and then clockwise
    windDir = 0;
    %The wind strength
    windStr = .3;
    %The base value for the spreading of the fire. This is the mean if
    %randomFireSpread is set to 2;
    v0 = .2;
    %If randomFireSpread is set to 2, this is the standard deviation
    v0sd = .2;
    %This is the factor by which the total speed is reduced when the fire
    %hits a firebreak
    %TODO
    fireBreakFactorX = 0 %1/(1+(fireBreakWidthPhysX/5)^2);
    fireBreakFactorY = 0 %1/(1+(fireBreakWidthPhysY/5)^2);
    %A modifier to depict the humidity of the forest
    humidityMod = .2;
    %A modifier to depict the currently falling rain
    rainMod = .2;
    gamma = humidityMod+rainMod;
    %The temparature in celcius
    temp = 20.5;
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
    
%     global fireStationCount;
    global stationCoords;
    global fireTruckCount
    global fireTruckPerStationCount;
    global fireTruckSpeed;
    global fireFighterSpeed;
    
    %The amount of fire station
%     fireStationCount = 3;
    %the coordinates of the fire stations, a ix2-matrix
    stationCoords = getStationCoords(fireStationCount, forestWidth, forestHeight, fireBreakDistX, fireBreakDistY);    
    %The amount of firetrucks
    fireTruckCount = 4*fireStationCount + extraTrucks;
    %The amount of firetrucks per fire station
    fireTruckPerStationCount = fireTruckCount/fireStationCount;
    if~(fireTruckPerStationCount == round(fireTruckPerStationCount))
        error('firetruck can not be evenly distributed');
    end
    
    %The speed in tiles/iteration at which the truck will drive
    fireTruckSpeed = 10;
    %The speed in tiles/iteration at which a firefighter will walk
    fireFighterSpeed = 1;
    
   
end

function stationCoords = getStationCoords(fireStationCount, forestWidth, forestHeight, fireBreakDistX, fireBreakDistY)
    if(fireStationCount == 1)
        x1 = forestWidth;
        y1 = round(forestHeight/2);
        while~(mod(y1-1,fireBreakDistY+1)==0)
            y1 = y1+1;
        end
        stationCoords=[y1 x1];
    elseif(fireStationCount ==2)
        x1 = 1;
        x2 = forestWidth;
        y1 = round(forestHeight/2);
        while~(mod(y1-1,fireBreakDistY+1)==0)
            y1 = y1+1;
        end
        y2 = y1;
        stationCoords=[y1 x1; y2 x2];
    elseif(fireStationCount ==3)
        x1 = 1;
        y1 = round(forestHeight/2);
        while~(mod(y1-1,fireBreakDistY+1)==0)
            y1 = y1+1;
        end
        
        x2 = round((4/5)*forestWidth);
        while~(mod(x2-1,fireBreakDistX+1)==0)
            x2 = x2+1;
        end
        y2 = 1;
        x3 = x2;
        y3 = forestHeight;
        stationCoords=[y1 x1; y2 x2; y3 x3];
    elseif(fireStationCount ==4)
        x1 = floor(forestWidth/2);
        while~(mod(x1-1,fireBreakDistX+1)==0)
            x1 = x1+1;
        end
        y1 = 1;
        x2 = forestWidth;
        y2 = floor(forestWidth/2);
        while~(mod(y2-1,fireBreakDistY+1)==0)
            y2 = y2+1;
        end
        x3 = x1;
        y3 = forestHeight;
        x4 = 1;
        y4 = y2;
        stationCoords=[y1 x1; y2 x2; y3 x3; y4 x4];
    end
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

