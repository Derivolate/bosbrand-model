
function envDmg = bosbrand()

    format shortG;
    %make all figures appear as popups. Change the last argument to docked
    %to make all figures appear docked (from normal)
    set(0,'DefaultFigureWindowStyle','docked')
    
    %Initialize all global variables
    initGlobals();
    %Initialize the forest as a matrix
    forest = initForest();
    %Initialize the firetruck-manager as an object
    ftm = fireTruckManager(forest);

    figure;
    cMap = getCMap();
    
    i = 0;
    %Check if the fire is surrounded by the fire-brigade
    while ~(ftm.fireSurrounded == 1)
        i = i+1;
        %let the fire spread one tick
        forest = spreadFire(forest);
        %Count the amount of iterations. This is to simulate the time the
        %fire-brigade needs to react. 82 iterations is about 10 minutes
        %which is in accordance to paragraph 4.1.3.3.1 and 4.3.5
        if(i>82)
            [ftm,forest] = ftm.moveFireFighters(forest);
        end
        
        %stuff necessary for the figure
        imagesc(forest);
        colorbar;
        colormap(cMap);
        caxis([0,5]); 
        drawnow;
        
    end
    envDmg = zeros(1,3);
    envDmg = calculateEnvDamage(forest)
end

function cMap = getCMap()
    cNoFire = [83,244,66];          %Green
    cMiddleFire = [244,241,66];     %Orange
    cLit = [244,66,66];             %Red
    cFireBreak = [139 69 19];       %Brown
    cFireTruck = [252 240 15];        %Yellow
    cFireFighter = [34 15 252];       %Blue
    cFireFighterSide = [15 201 252];  %Cyan
    
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
