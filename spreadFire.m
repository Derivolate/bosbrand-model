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
            
            if(randomFireSpread == 0 || randomFireSpread == 2)
                if(newForest(y,x)>=1)
                    newForest(y,x)=1;
                    if(enableIgniteFlags)
                        newForest = checkForFlags(newForest,y,x);
                    end
                end
            else
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

function bool = isFireBreak(x)
    bool = (x==2||x==3||x==4||x==5);
end

function forest = checkForFlags(forest,y,x)
    global fireBreakDistX;
    global fireBreakDistY;
    global forestWidth;
    global forestHeight;
    removeFlag = 0;
    tempX = x;
    tempY = y;
    if(isFireBreak(forest(y-1,x)))
        if(~(y==2))
            y = y-fireBreakDistY-1;
            removeFlag = 1;
        end
    elseif(isFireBreak(forest(y+1,x)))
        if(~(y+1==forestHeight))
            y = y+2;
            removeFlag = 1;
        end
    elseif(isFireBreak(forest(y,x-1)))
        if(~(x==2))
            x = x-2;
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