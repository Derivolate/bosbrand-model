
function bosbrand()
    format shortG;
    set(0,'DefaultFigureWindowStyle','normal')
    global forestSize;
    initGlobals();
    forest = initForest(forestSize);
    
    ftm = fireTruckManager();
    %ftm.setDestinations(forest);
    
    figure;
    cMap=makeColorMap([83,244,66], [244,241,66],[244,66,66],100); %maakt een scaling colormap mbv een begin, midden, eind rgb waarde
    cBlack=[1 1 1]; %brandgang
    cRed=[1 1 1];   %brandweerwagen
    cBlue=[1 1 1];  %brandweerman
    cCyan=[1 1 1];  %brandweerman zij
    cMap=[cMap;cBlack;cRed;cBlue;cCyan]/244; %delen door 244 om een waarde tussen 0 en 1 te krijgen
    
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
        %colormap(cMap);
        colormap hsv;
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
