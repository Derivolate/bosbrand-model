
function bosbrand()
    %start timer
%     tic;
    format shortG;
    %make all figures appear as popups. Change the last argument to docked
    %to make all figures appear docked (from normal)
    set(0,'DefaultFigureWindowStyle','docked')
    
    %Initialize all global variables
    initGlobals();
    %Initialize the forest
    forest = initForest();
    %Initialize the firetruck-manager as an object and let it calculate
    %it's destinations
    ftm = fireTruckManager(forest);
    %ftm.setDestinations(forest);

    figure;
    cMap = getCMap();
    pCounter=0;
    pStepSize=5; %amount of steps before a pause
    
    %The previous version of the forest is compared with the current
    %version of the forest. If they're the same, the whole forest is on
    %fire or the fire brigade has the fire under control. In both cases we
    %can stop looping.
    
    %Set the oldForest to an empty matrix to make sure we can loop the
    %first time
    oldForest = zeros(size(forest));
    while 1%(~isequal(forest,oldForest))
        %copy the forest to oldForest
        oldForest = forest;
        %let the fire spread one tick
        forest = spreadFire(forest);
        %let the fire brigade react to it
        forest = ftm.moveFireFighters(forest);
        
        %stuff necessary for the figure
        imagesc(forest);
        colorbar;
        colormap(cMap);
        caxis([0,5]); %bepaalt de lengte van de colorscale
        drawnow;
        
        %a step-by-step evolution of the fire, press any key in the command
        %window to unpause.
%         if pCounter>=pStepSize
%             pause;
%             pCounter=0;
%         end
        pCounter=pCounter+1;
        %display elapsed time
%         toc
        
    end
end

function cMap = getCMap()
    cNoFire = [83,244,66];          %Preen
    cMiddleFire = [244,241,66];     %Orange
    cLit = [244,66,66];             %Red
    cFireBreak = [139 69 19];       %Brown
    cFireTruck=[252 240 15];        %Yellow
    cFireFighter=[34 15 252];       %Blue
    cFireFighterSide=[15 201 252];  %Cyan
    
    %Create a colormap for each color transition. The 100 intermediate
    %steps are only necessary in the first colormap but to make the other
    %colors easy to reference, we make sure that they end up on an integer
    %value and to do that, we need the 100 intermediate steps for each
    %color.
    cMapFire=makeColorMap(cNoFire, cMiddleFire,cLit,100); 
    cMapFireBreak = makeColorMap(cLit,cFireBreak,100);
    cMapFireTruck = makeColorMap(cFireBreak, cFireTruck,100);
    cMapFireFighter = makeColorMap(cFireTruck,cFireFighter,100);
    cMapFireFighterSide = makeColorMap(cFireFighter,cFireFighterSide,100);
    
    %Throw all colormaps together to create one big beautiful rainbow
    cMap=[cMapFire; cMapFireBreak; cMapFireTruck; cMapFireFighter; cMapFireFighterSide];
    %Divide the whole colormap by 255 so the computer can actually
    %understand the colors
    cMap = cMap/255;
end
