%This is the function where all the magic happens. It spreads the fire as
%the name suggests. It loops through all forest tiles tiles and checks for 
%each tile if there is a neighbouring tile igniting it. In this process,
%the wind is also taken into consideration as well as firebreaks, fire
%brigade and some optimization.
function newForest = spreadFire(forest)
    global forestWidth;
    global forestHeight;
    global fireBreakDistX;
    global fireBreakDistY;
    global enableIgniteFlags;
    global wind;
    global windDir;
    global windStr;
    global fireBreak;
    global fireBreakFactorX;
    global fireBreakFactorY;
    global randomFireSpread;
    
    %The fact that this parameter is global is a leftover from 
    fireBreak = 1;
    
    newForest = forest;
    skipY = 0;
    for x = 1:forestWidth
        if(mod(x,fireBreakDistX+1)==1)
            continue;
        end
        for y = 1:forestHeight
            if(skipY > 0)
                skipY = skipY-1;
                continue;
            end
            %if the tile is -1, this means that the whole parcel hasn't
            %ignited yet, so we can skip it completely
            if(forest(y,x)==-1)
                skipY =fireBreakDistY;
                continue;
            end
            %als het bos al in de fik staat, het een brandgang is of er brandweer staat, kijk er niet naar
            if(forest(y,x)==1||isFireBreak(forest(y,x)))
                continue;
            end
            
            %per windrichting word gekeken of er daar bos in de fik
            %staat. Als dat het geval is wordt er meer vuur toegevoegd
            %aan het vakje

            %oost
            %check if the next tile is still inside the matrix
            if(~(x+2>forestWidth))
                %if the tile next to us isn't a firetruck or a
                %firefighter
                if(~(forest(y,x+1)==3||forest(y,x+1)==4||forest(y,x+1)==5))
                    %if the tile next to us is on fire, or the tile next to
                    %us is a fire-break and the tile next to that tile is on
                    %fire
                    if(forest(y,x+1)==1||(forest(y,x+1)==2&&forest(y,x+2)==1))
                        if(forest(y,x+1)==2)
                            fireBreak = fireBreakFactorX;
                        else
                            fireBreak = 1;
                        end
                        wind = -cos(windDir)*windStr;
                        newForest(y,x) = newForest(y,x) + fireSpeed();
                    end
                end
            end
            %west
            if(~(x-2==0))
                if(~(forest(y,x-1)==3||forest(y,x-1)==4||forest(y,x-1)==5))
                    if(forest(y,x-1)==1||(forest(y,x-1)==2&&forest(y,x-2)==1))
                        if(forest(y,x-1)==2)
                            fireBreak = fireBreakFactorX;
                        else
                            fireBreak = 1;
                        end
                        wind = cos(windDir)*windStr;
                        newForest(y,x) = newForest(y,x) + fireSpeed();
                    end
                end
            end
            %zuid

            if(~(y+2>forestHeight))                    
                if(~(forest(y+1,x)==3||forest(y+1,x)==4||forest(y+1,x)==5))
                    if(forest(y+1,x)==1||(forest(y+1,x)==2&&forest(y+2,x)==1))
                        if(forest(y+1,x)==2)
                            fireBreak = fireBreakFactorY;
                        else
                            fireBreak = 1;
                        end
                        wind = -sin(windDir)*windStr;
                        newForest(y,x) = newForest(y,x) + fireSpeed();
                    end
                end
            end
            %noord
            if(~(y-2==0))
                if(~(forest(y-1,x)==3||forest(y-1,x)==4||forest(y-1,x)==5))
                    if(forest(y-1,x)==1||(forest(y-1,x)==2&&forest(y-2,x)==1))
                        if(forest(y-1,x)==2)
                            fireBreak = fireBreakFactorY;
                        else
                            fireBreak = 1;
                        end
                        wind = sin(windDir)*windStr;
                        newForest(y,x) = newForest(y,x) + fireSpeed();
                    end
                end
            end
            
            %Check if one of the advised randomization modes is used (see
            %initglobals.m line 43)
            if(randomFireSpread == 0 || randomFireSpread == 2)
                %A tile can of course not be more than 100% on fire
                if(newForest(y,x)>=1)
                    newForest(y,x)=1;
                    %If the igniteflags optimization is enabled, check for
                    %possible neigbouring parcels using the checkForFlags
                    %function
                    if(enableIgniteFlags)
                        newForest = checkForFlags(newForest,y,x);
                    end
                end
            else
                %This part is deprecated but is left in for reference
                if(newForest(y,x) > 0);
                    r = 0;
                    %make sure the forest must be at least a bit on
                    %fire before it can fully ignite.
                    while(r==0)
                        r = rand;
                    end
                    if(newForest(y,x)>r)
                        newForest(y,x)=1;
                        if(enableIgniteFlags)
                            newForest = checkForFlags(newForest,y,x);
                        end
                    end
                end
            end
        end
    end
end

%Shorthand to check if a given number is a firebreak.
function bool = isFireBreak(x)
    bool = (x==2||x==3||x==4||x==5);
end

%This function checks if there is another parcel next to the tile at the
%given location. If that is the case, that parcel is stripped of it's flags
%that it cannot ignite as there is at least 1 neigbouring tile that can
%ignite the parcel and thus this parcel should also be checked in the
%future. optimization for this is discussed in the last part of paragraph 5.1
function forest = checkForFlags(forest,y,x)
    global fireBreakDistX;
    global fireBreakDistY;
    global forestWidth;
    global forestHeight;
    
    %This is turned to one if the given coordinates are on the edge of a
    %parcel
    removeFlag = 0;
    
    %Check if we are on the edge of a firebreak by checking if one of the
    %neigbouring tiles is a firebreak
    
    %Check above
    if(isFireBreak(forest(y-1,x)))
        %If we are at the top of the matrix, there is still a firebreak
        %above us but there is no parcel above that firebreak, so that case
        %needs to be excluded.
        if(~(y==2))
            %Move to the top row of the parcel above us
            y = y-fireBreakDistY-1;
            removeFlag = 1;
        end
    %Check below us
    elseif(isFireBreak(forest(y+1,x)))
        if(~(y+1==forestHeight))
            y = y+2;
            removeFlag = 1;
        end
    elseif(isFireBreak(forest(y,x-1)))
        if(~(x==2))
            x = x-2;
            %Keep going up until we find the top of the parcel
            while(~(forest(y,x)==-1)&& ~(isFireBreak(forest(y,x))))
                y= y-1;
            end
            removeFlag =1;
        end
    elseif(isFireBreak(forest(y,x+1)))
        if(~(x+1==forestWidth))
            x = x+2;
            while(~(forest(y,x)==-1)&& ~isFireBreak(forest(y,x)))
                y= y-1;
            end
            removeFlag =1;
        end
    end
    if(removeFlag)
        if(forest(y,x)==-1)
            while(forest(y,x-1)==-1)
                x=x-1;
            end
            for i=x:x+fireBreakDistX-1
                
                forest(y,i)=0;
            end
        end
    end
end

%This function is the actual implementation of the formula for the fire
%speed. This formula is heavily discussed in paragraph 4.3.3
function v = fireSpeed()
    global v0;
    global v0sd;
    global fireBreak;
    global wind;
    global tempFactor;
    global randomFireSpread;
    global randomSpeedReducer;
    global gamma;
    if(randomFireSpread == 2)
        vbase = random('Normal',v0,v0sd);
    else
        vbase = v0;
    end
    
    v = (vbase*tempFactor+ wind - gamma)*fireBreak;
    if (v<0)
        v=0;
    end
    if(randomFireSpread == 1)
        v = v/randomSpeedReducer;
    end
    v;
end