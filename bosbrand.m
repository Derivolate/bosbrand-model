
function bosbrand()
    format shortG;
    global forestSize;
    global fireBreakDist;
    global fireBreakWidth;
    global fbrSize;
    %creeer bos
    
    forestSize = 4;
    fireBreakDist = 2;
    %the display width for the fire break roads. This is to make it
    %possible to still see the firebreaks when the forest is too large to
    %fit one forest-square in a pixel;
    fireBreakWidth = 2;
    if(~(mod(forestSize,fireBreakDist)==0))
        disp('WARNING: forestSize is not a round multiple of fireBreakDist, output may be incorrect')
    end
    forest = zeros(forestSize)
    
    %creeer wegen-net (voor brandweer)
    %fbr = fire-break-roads
    fbrSize = forestSize+(forestSize/fireBreakDist+1)*fireBreakWidth;
    fbr = zeros(fbrSize);
    fbr = initFbr(fbr);
    
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
        forest = spreadFire(forest)
        fbr = forest2fbr(fbr, forest);
        %fbr = moveFireFighters(fbr);
        %hier fbr plotten en kleurtjes maken
    end
end

function fbrCoord= forestCoord2fbrCoord(forestCoord)
    global fireBreakDist;
    global fireBreakWidth;
    parcel = floor(mod(forestCoord,fireBreakDist));
    fbrCoord = forestCoord + parcel*fireBreakWidth;
end

function forestCoord = fbrCoord2forestCoord(fbrCoord)

end

function newFbr = moveFireFighters(fbr)
    newFbr = fbr;
end

function fbr = forest2fbr(fbr, forest)
    global forestSize;

    for x = 1: forestSize
        for y = 1: forestSize
            fbr(forestCoord2fbrCoord(x),forestCoord2fbrCoord(y))=forest(x,y)
        end
    end
end

function fbr = initFbr(fbr)
    global fireBreakDist;
    global fireBreakWidth;
    global fbrSize;
    %{
    Legend fbr:
        0 = niet brandend bos
        1 = brandend bos
        2 = brandgang
        3 = brandweerauto
        4 = brandweerman
        5 = zij brandweerman
    %}
    
    for x = 1: fbrSize 
        for y = 1: fbrSize
            if(mod(x,fireBreakDist+fireBreakWidth)<=fireBreakWidth && mod(x,fireBreakDist+fireBreakWidth)~=0 || mod(y,fireBreakDist+fireBreakWidth)<=fireBreakWidth && mod(y,fireBreakDist+fireBreakWidth)~=0)
                fbr(y,x)=2;
            end
        end
    end
    
    %Add firefighter
    fbr(1,1)=3;
end

function forest = bliksemInslag(forest)
    forest(2,2) = 1;
end

function newForest = spreadFire(forest)
    global forestSize;
    global fireBreakDist;
    newForest = forest;
    v0 = .3;
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
                        newForest(y,x) = newForest(y,x) + 0.25*fireBreakFactor;
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
                        newForest(y,x)= newForest(y,x)+0.25*fireBreakFactor;
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
                        newForest(y,x)= newForest(y,x)+0.25*fireBreakFactor;
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
                        newForest(y,x)= newForest(y,x)+0.25*fireBreakFactor;
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