
function bosbrand()
    format shortG;
    set(0,'DefaultFigureWindowStyle','normal')
    global forestSize;
    initGlobals();
    forest = initForest(forestSize);
    
    ftm = fireTruckManager();
    %ftm.setDestinations(forest);
    
    figure;
    cMap = getCMap();
    pCounter=0;
    pStepSize=5; %amount of steps before a pause
    
    %vergelijk het oude bos met het nieuwe bos, als deze gelijk zijn
    %verspreid er geen vuur meer en is of het hele bos afgefikt of is de
    %brandweer de brand meester
    oldForest = zeros(forestSize);
    while(~isequal(forest,oldForest))
        %i = i+ 1
        oldForest = forest;
        forest = spreadFire(forest);
        forest = ftm.moveFireFighters(forest);
        
        imagesc(forest);
        colormap(cMap);
        %colormap hsv;
        colorbar;
        caxis([0,5]) %bepaalt de lengte van de colorscale
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

function cMap = getCMap()
    cNoFire = [83,244,66];
    cMiddleFire = [244,241,66];
    cLit = [244,66,66];
    cFireBreak = [139 69 19]; %Brown
    cFireTruck=[252 240 15];   %Yellow
    cFireFighter=[34 15 252];  %Blue
    cFireFighterSide=[15 201 252];  %Cyan
    
    cMapFire=makeColorMap(cNoFire, cMiddleFire,cLit,100); %maakt een scaling colormap mbv een begin, midden, eind rgb waarde
    cMapFireBreak = makeColorMap(cLit,cFireBreak,100);
    cMapFireTruck = makeColorMap(cFireBreak, cFireTruck,100);
    cMapFireFighter = makeColorMap(cFireTruck,cFireFighter,100);
    cMapFireFighterSide = makeColorMap(cFireFighter,cFireFighterSide,100);
    cMap=[cMapFire; cMapFireBreak; cMapFireTruck; cMapFireFighter; cMapFireFighterSide];
    cMap = cMap/255;%delen door 255 om een waarde tussen 0 en 1 te krijgen
end
