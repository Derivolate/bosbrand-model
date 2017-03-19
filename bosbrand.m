
function bosbrand()
    format shortG;
    global forestSize;
    global fireBreakDist;
    global fireBreakWidth;
    global fbrSize;
    %creeer bos
    
    forestSize = 20;
    fireBreakDist = 4;
    %the display width for the fire break roads. This is to make it
    %possible to still see the firebreaks when the forest is too large to
    %fit one forest-square in a pixel;
    %KEEP THIS 1 FOR NOW!!!!
    
    fireBreakWidth = 1;
    if(~(mod(forestSize,fireBreakDist)==0))
        disp('WARNING: forestSize is not a round multiple of fireBreakDist, output may be incorrect')
    end
    forest = zeros(forestSize);
    
    %creeer wegen-net (voor brandweer)
    %fbr = fire-break-roads
    fbrSize = forestSize+(forestSize/fireBreakDist+1)*fireBreakWidth;
    forest = initFbr(zeros(fbrSize));
    forestSize = fbrSize;
    forest = bliksemInslag(forest);
    oldForest = zeros(forestSize);
    
    figure;
    cMap=makeColorMap([83,244,66], [244,241,66],[244,66,66],101); %maakt een scaling colormap mbv een begin, midden, eind rgb waarde
    cBrown=[139 69 19]; %brandgang
    cGeel=[252 240 15];   %brandweerwagen
    cBlue=[34 15 252];  %brandweerman
    cCyan=[15 201 252];  %brandweerman zij
    cMap=[cMap;cBrown;cGeel;cBlue;cCyan]/255; %delen door 244 om een waarde tussen 0 en 1 te krijgen
    
    pCounter=0;
    pStepSize=5; %amount of steps before a pause
    
    %vergelijk het oude bos met het nieuwe bos, als deze gelijk zijn
    %verspreid er geen vuur meer en is of het hele bos afgefikt of is de
    %brandweer de brand meester
    while(~isequal(forest,oldForest))
        %i = i+ 1
        oldForest = forest;
        forest = spreadFire(forest);
        forest = moveFireFighters(forest);
        imagesc(forest);
        colormap(cMap);
        colorbar;
        caxis([0,1]) %bepaalt de lengte van de colorscale
        drawnow;
        
        %a step-by-step evolution of the fire, press any key in the command
        %window to unpause.
%         if pCounter>=pStepSize
%             pause;
%             pCounter=0;
%         end
        pCounter=pCounter+1;
    end
end


function forestCoord = fbrCoord2forestCoord(fbrCoord)

end

function newForest = moveFireFighters(forest)
    newForest = forest;
end

function fbr = addRoads(fbr, forest)
    global forestSize;

    for x = 1: forestSize
        for y = 1: forestSize
            fbr(forestCoord2fbrCoord(x),forestCoord2fbrCoord(y))=forest(x,y);
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
        1 = brandend bos, rood
        1.01 = brandgang, bruin
        1.02 = brandweerauto, geel
        1.03 = brandweerman, blue
        1.04 = zij brandweerman, cyan
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
    global forestSize;
    x = 1;
    y = 1;
    
    while(~(forest(y,x)==0))
        x = ceil(rand()*forestSize);
        y = ceil(rand()*forestSize);
    end
    forest(y,x) = 1;
    x
    y
end

function newForest = spreadFire(forest)
    global forestSize;
    newForest = forest;
    v0 = .2;
    fireBreak = 1;
    fireBreakFactor = .1;
    for x = 1:forestSize
        for y = 1:forestSize
            %als het bos al in de fik staat, kijk er niet naar
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
                            newForest(y,x) = newForest(y,x) + v0*fireBreak;
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
                            newForest(y,x) = newForest(y,x) + v0*fireBreak;
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
                            newForest(y,x) = newForest(y,x) + v0*fireBreak;
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
                            newForest(y,x) = newForest(y,x) + v0*fireBreak;
                        end
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