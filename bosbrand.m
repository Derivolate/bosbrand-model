
function bosbrand()
    format shortG;
    %creeer bos
    forestSize = 50;
    fireBreakDist = 25;
    if(~(mod(forestSize,fireBreakDist)==0))
        disp('WARNING: forestSize is not a round multiple of fireBreakDist, output may be incorrect')
    end
    forest = zeros(forestSize)
    
    %creeer wegen-net (voor brandweer)
    %fbr = fire-break-roads
    fbrSize = forestSize+forestSize/fireBreakDist+1;
    fbr = zeros(fbrSize);
    fbr = initFbr(fbr, fbrSize, fireBreakDist);
    
    %blikseminslag op 2,2
    disp('bos na blikseminslag')
    forest = bliksemInslag(forest)
    
    oldForest = zeros(forestSize);
    i = 1;
    %vergelijk het oude bos met het nieuwe bos, als deze gelijk zijn
    %verspreid er geen vuur meer en is of het hele bos afgefikt of is de
    %brandweer de brand meester
    figure;
    cMap=makeColorMap([83,244,66], [244,241,66],[244,66,66],100); %maakt een scaling colormap mbv een begin, midden, eind rgb waarde
    cBlack=[1 1 1] %brandgang
    cRed=[1 1 1]    %brandweerwagen
    cBlue=[1 1 1]   %brandweerman
    cCyan=[1 1 1]   %brandweerman zij
    cMap=[cMap;cBlack;cRed;cBlue;cCyan]/244 %delen door 244 om een waarde tussen 0 en 1 te krijgen
    while(~isequal(forest,oldForest))
        oldForest = forest;
        %i = i+ 1
        forest = verspreidVuur(forest, forestSize, fireBreakDist);
        fbr = forest2fbr(fbr);
        fbr = moveFireFighters(fbr);
        %hier fbr plotten en kleurtjes maken
        imagesc(forest);
        colormap(cMap);
        colorbar;
        caxis([0,1]) %bepaalt de lengte van de colorscale
        drawnow;
    end
end

function [fbrx, fbry] = forestCoord2fbrCoord(forestx,foresty,fireBreakDist)
    
end

function [forestx, foresty] = fbrCoord2forestCoord(fbrx,fbry,fireBreakDist)
    
end

function newFbr = moveFireFighters(fbr)
    newFbr = fbr;
end

function fbr = forest2fbr(fbr)
end

function fbr = initFbr(fbr, fbrSize, fireBreakDist)
    %{
    Legend fbr:
        0 = niet brandend bos
        1 = brandend bos
        1.1 = brandgang, black
        1.2 = brandweerauto, red
        1.3 = brandweerman, blue
        1.4 = zij brandweerman, cyan
    %}
    
    for x = 1: fbrSize 
        for y = 1: fbrSize
            if(mod(x-1,fireBreakDist+1)==0||mod(y-1,fireBreakDist+1)==0)
                fbr(y,x)=1;
            end
        end
    end
    
    %Add firefighter
    fbr(1,1)=2
end

function forest = bliksemInslag(forest)
    forest(25,25) = 1;
end

function newForest = verspreidVuur(forest, forestSize, fireBreakDist)
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
                            fireBreakFactor=.2;
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
                            fireBreakFactor=.2;
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
                            fireBreakFactor=.2;
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
                            fireBreakFactor=.2;
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