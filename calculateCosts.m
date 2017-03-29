function costs = calculateCosts()
    costs = 0;
    global fireBreakWidthPhysX;
    global fireBreakWidthPhysY;
    global fireBreakCountX;
    global fireBreakCountY;
    global forestWidth;
    global forestHeight;
    global tileWidth
    %The total area of the fireBreaks is the size of the forest times the
    %width (in x and y direction) times the amount of fireBreaks,
    %minus the amount of junctions (amount of fireBreaks in both directins 
    %multiplied) times the width of both the directions because these are counted double.
    fireBreakArea = (fireBreakWidthPhysX*fireBreakCountX*forestHeight*tileWidth...
                   + fireBreakWidthPhysY*fireBreakCountY*forestWidth*tileWidth)...
        - (fireBreakCountX*fireBreakCountY)*(fireBreakWidthPhysX*fireBreakWidthPhysY);
    costPerm2fireBreak = 100;
    fireBreakCosts = fireBreakArea*costPerm2fireBreak;
    
    global fireStationCount;
    global fireTruckCount;
    
    %Costs for small and big maintenance for the firestations and firetrucks
    fireStationCostSmallMaint = 10^5;
    fireStationCostBigMaint = 10^5;
    fireTruckCostSmallMaint = 5*10^4;
    fireTruckCostBigMaint =5*10^4;
    
    %Every so many years, there is big maintenance. In between these years,
    %there is a certain amount of small maintenance runs. The big
    %maintenance runs can be seen as the complete purchase of new equipment
    bigMaintYears = 30;
    smallMaintCount = 5;
    
    fireTruckAndStationCosts = ((fireStationCostSmallMaint*fireStationCount + fireTruckCostSmallMaint*fireTruckCount)*smallMaintCount...
                                +fireTruckCostBigMaint*fireTruckCount+fireStationCostBigMaint*fireStationCount)/bigMaintYears;
    
    yearSalary = 10^5;
    
    costs = fireBreakCosts+fireTruckAndStationCosts+yearSalary;
    
    
end