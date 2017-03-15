
function bosbrand()
format shortG;
    %creeer bos
    forestSize = 9;
    fireBreakDist = 3
    forest = zeros(forestSize);
    
    
    %blikseminslag op 2,2
    disp('bos na blikseminslag')
    forest = bliksemInslag(forest)
    
    oldForest = zeros(forestSize);
    i = 1;
    %vergelijk het oude bos met het nieuwe bos, als deze gelijk zijn
    %verspreid er geen vuur meer en is of het hele bos afgefikt of is de
    %brandweer de brand meester
    while(~isequal(forest,oldForest))
        oldForest = forest;
        %i = i+ 1
        forest = verspreidVuur(forest, forestSize, fireBreakDist)
    end
    forest
end

function forest = bliksemInslag(forest)
    forest(2,2) = 1;
end

function newForest = verspreidVuur(forest, forestSize, fireBreakDist)
    newForest = forest;
    v0 = .25;
    for x = 1:forestSize
        for y = 1:forestSize
            %als het bos al in de fik staat, kijk er niet naar
            if(~(forest(y,x)==1))
                %per windrichting word gekeken of er daar bos in de fik
                %staat. Als dat het geval is wordt er meer vuur toegevoegd
                %aan het vakje
                
                %oost
                if(~(x+1>forestSize))
                    if(forest(y,x+1)==1)
                        if(mod(x,fireBreakDist)==0)
                            fireBreakFactor=.5;
                        else
                            fireBreakFactor=1;
                        end
                        newForest(y,x) = forest(y,x) + 0.25*fireBreakFactor;
                    end
                end
                %west
                if(~(x-1==0))
                    if(forest(y,x-1)==1)
                        if(mod(x-1,fireBreakDist)==0)
                            fireBreakFactor=.5;
                        else
                            fireBreakFactor=1;
                        end
                        newForest(y,x)= forest(y,x)+0.25*fireBreakFactor;
                    end
                end
                %zuid
                if(~(y+1>forestSize))
                    if(forest(y+1,x)==1)
                        if(mod(y,fireBreakDist)==0)
                            fireBreakFactor=.5;
                        else
                            fireBreakFactor=1;
                        end
                        newForest(y,x)= forest(y,x)+0.25*fireBreakFactor;
                    end
                end
                %noord
                if(~(y-1==0))
                    if(forest(y-1,x)==1)
                        if(mod(y-1,fireBreakDist)==0)
                            fireBreakFactor=.5;
                        else
                            fireBreakFactor=1;
                        end
                        newForest(y,x)= forest(y,x)+0.25*fireBreakFactor;
                    end
                end
                %het bos kan niet meer dan 100% in de fik staan
                if(newForest(y,x)>1)
                    newForest(y,x)=1;
                end
            end
        end
    end
end