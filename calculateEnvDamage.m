function envDamage = calculateEnvDamage(forest)
    envDamage = 0;
    global fireBreakWidthPhysX;
    global fireBreakWidthPhysY;
    global fireBreakCountX;
    global fireBreakCountY;
    global tileWidth;
    global forestWidth;
    global forestHeight;
    
    %The total area of the fireBreaks is the amount of fireBreaks times the
    %width (in x and y direction), minus the amount of junctions (amount of
    %fireBreaks in both directins multiplied) times the
    %width of both the directions because these are counted double.
    fireBreakArea = (fireBreakWidthPhysX*fireBreakCountX*forestHeight*tileWidth...
                   + fireBreakWidthPhysY*fireBreakCountY*forestWidth*tileWidth)...
        - (fireBreakCountX*fireBreakCountY)*(fireBreakWidthPhysX*fireBreakWidthPhysY);
    
    burntTilesCount = 0;
    for x = 1:forestWidth
        for y = 1:forestHeight
            if(forest(y,x)==1)
                burntTilesCount= burntTilesCount + 1;
            end
        end
    end 
    burntArea = burntTilesCount*tileWidth^2;
    envDamage = burntArea+fireBreakArea;
end