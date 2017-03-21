function newForest = spreadFire(forest)
    global forestSize;
    %result variable of windDir and windStr combined. Calculated per direction
    global wind;
    global windDir;
    global windStr;
    
    %indication if there is a fire break or not. 1 if there is no fire
    %break, otherwise it has the value of fireBreakFactor. Calculated per
    %direction
    global fireBreak;
    global fireBreakFactor;
    global randomFireSpread;
    fireBreak = 1;
    newForest = forest;
    for x = 1:forestSize
        for y = 1:forestSize
            %als het bos al in de fik staat, het een brandgang is of er brandweer staat, kijk er niet naar
            if(~(forest(y,x)==1||forest(y,x)==2||forest(y,x)==3||forest(y,x)==4||forest(y,x)==5))
                %per windrichting word gekeken of er daar bos in de fik
                %staat. Als dat het geval is wordt er meer vuur toegevoegd
                %aan het vakje
                
                %oost
                %check if the next tile is still inside the matrix
                if(~(x+2>forestSize))
                    %if the tile next to us isn't a firetruck or a
                    %firefighter
                    if(~(forest(y,x+1)==3||forest(y,x+1)==4||forest(y,x+1)==5))
                        %if the tile next to us is on fire, or the tile next to
                        %us is a fire-break and the tile next to that tile is on
                        %fire
                        if(forest(y,x+1)==1||(forest(y,x+1)==2&&forest(y,x+2)==1))
                            if(forest(y,x+1)==2)
                                fireBreak = fireBreakFactor;
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
                                fireBreak = fireBreakFactor;
                            else
                                fireBreak = 1;
                            end
                            wind = cos(windDir)*windStr;
                            newForest(y,x) = newForest(y,x) + fireSpeed();
                        end
                    end
                end
                %zuid
                if(~(y+2>forestSize))                    
                    if(~(forest(y+1,x)==3||forest(y+1,x)==4||forest(y+1,x)==5))
                        if(forest(y+1,x)==1||(forest(y+1,x)==2&&forest(y+2,x)==1))
                            if(forest(y+1,x)==2)
                                fireBreak = fireBreakFactor;
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
                                fireBreak = fireBreakFactor;
                            else
                                fireBreak = 1;
                            end
                            wind = sin(windDir)*windStr;
                            newForest(y,x) = newForest(y,x) + fireSpeed();
                        end
                    end
                end
                %het bos kan niet meer dan 100% in de fik staan
                if(randomFireSpread == 0)
                    if(newForest(y,x)>1)
                        newForest(y,x)=1;
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
                        end
                    end
                end
            end
        end
    end
end

function v = fireSpeed()
    global v0;
    global fireBreak;
    global wind;
    global tempFactor;
    global randomFireSpread;
    global randomSpeedReducer;
    v = (v0*tempFactor+ wind)*fireBreak;
    if (v<0)
        v=0;
    end
    if(randomFireSpread == 1)
        v = v/randomSpeedReducer;
    end
    v;
end