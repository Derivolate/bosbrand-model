function forest = initForest()
    global fireBreakDistX;
    global fireBreakDistY;
    global forestWidth;
    global forestHeight;
    global enableIgniteFlags;
    
    %{
    Legend forest:
        0 = niet brandend bos
        1 = brandend bos, rood
        2 = brandgang, bruin
        3 = brandweerauto, geel
        4 = brandweerman, blue
        5 = zij brandweerman, cyan
    %}
    
    %Create an empty matrix with the right sizes to hold the forest
    forest = zeros(forestHeight,forestWidth);
    
    %Loop through the complete forest to add the firebreaks and some
    %optimisation flags
    for x = 1: forestWidth 
        for y = 1: forestHeight
            %add the firebreaks to the grid
            if(mod(x,fireBreakDistX+1)==1 || mod(y,fireBreakDistY+1)==1)
                forest(y,x)=2;
            %make the left side of each parcel -1 to indicate that it hasn't ignited yet
            elseif(mod(y,fireBreakDistY+1)==2 && enableIgniteFlags)
                forest(y,x)=-1;
            end
            
        end
    end
    
    %Lightning strike
    %Get a random tile which is forest and is completely surrounded by
    %forest
    x = 1;
    y = 1;
    while(~(forest(y,x)==0 &&...
           (forest(y-1,x)==0 || forest(y-1,x)==-1) &&...
            forest(y+1,x)==0 &&...
            forest(y,x+1)==0 &&...
            forest(y,x-1)==0))
        x = ceil(rand()*forestWidth);
        y = ceil(rand()*forestHeight);
    end
     
%     x= 3;
%     y= 3;
     
    forest(y,x) = 1;
    x
    y
    
    xTemp = x;
    %remove the parcel-ignited-flag
    %From the ignited tile, go upwards till a tile
    %which isn't forest or has has the parcel-ignited-flag
    while(forest(y,x)>=0 && forest(y,x)<=1)
        y = y-1;
    end
    %Then go to the right until we hit something that isn't a flag
    while(forest(y,x)==-1)
        forest(y,x) = 0;
        x = x-1;
    end
    x = xTemp+1;
    %Then clear all the flags
    while(forest(y,x)==-1)
        forest(y,x) = 0;
        x = x+1;
    end
end