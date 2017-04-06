   %%% to calculate the ideal frequentie 

    clear All; close All; clc;
    global fireBreakWidthPhysX;
    global fireBreakWidthPhysY;
    global fireBreakCountX;
    global fireBreakCountY;
    global fireStationCount;
    global extraTrucks
    
    fireBreakWidthPhysX = 5; %m
    fireBreakWidthPhysY = 5; %m
    fireBreakCountY = 17;
    fireBreakCountX = fireBreakCountY;
    fireStationCount = 1;
    extraTrucks = 0;

    maxExtraTrucks = 160;
    step = 10;
    
    test=zeros((maxExtraTrucks),4);
    for i=1:step:maxExtraTrucks
        extraTrucks = i;
        values=bosbrand()
        test(i,:)=[i,values];
    end
    %[burntArea fireBreakArea envDamage] = de sequence of data in the excel
    %sheet
    xlswrite('testdata.xls',test)
    test