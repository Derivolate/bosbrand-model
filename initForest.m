%This function initializes the matrix with all the respective numbers
function forest = initForest()
    global fireBreakDistX;
    global fireBreakDistY;
    global forestWidth;
    global forestHeight;
    global enableIgniteFlags;
    
    %{
    Legend forest:
        -1= flag to indicate that the parcel isn't on fire yet. The
            optimization for this is discussed in the last part of
            paragraph 5.1
        0 = forest and no fire, green
        0< <1 = forest and igniting but not yet on fire, gradient from
            green to yellow to red
        1 = forest and on fire, red
        2 = firebreak, brown
        3 = firetruck on a firebreak, yellow
        4 = firefighter on a firebreak, blue
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
    n = 0;
    while(~(forest(y,x)==0 &&...
           (forest(y-1,x)==0 || forest(y-1,x)==-1) &&...
            forest(y+1,x)==0 &&...
            forest(y,x+1)==0 &&...
            forest(y,x-1)==0))
        x = ceil(rand()*forestWidth);
        y = ceil(rand()*forestHeight);

        %If we looped more times than the amount of tiles in the whole
        %matrix, then the chance is pretty big that there might not be a
        %spot which is not completely surrounded by forest.
        if n>(forestWidth*forestHeight)
            error('no lightning location found');
        else
            n = n+1;
        end
    end
    
    
    %START THE FIRE
    forest(y,x) = 1;

    
    
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