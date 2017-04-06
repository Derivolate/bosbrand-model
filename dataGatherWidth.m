   %%% to calculate the ideal frequentie 

    clear All; close All; clc;
    global fireBreakWidthPhysX;
    global fireBreakWidthPhysY;
    global fireBreakCountX;
    global fireBreakCountY;
    global fireStationCount;
    global extraTrucks
    
%     fireBreakWidthPhysX = 10; %m
%     fireBreakWidthPhysY = 10; %m
    fireBreakCountY = 0;
    fireBreakCountX = 2*fireBreakCountY;
    fireStationCount = 2;
    extraTrucks = 0;

    maxWidth = 20;
    minWidth = 5;
    step = 5;
    
    test=zeros(4,4);
    for i=minWidth:step:maxWidth
        fireBreakWidthPhysX = i; %m
        fireBreakWidthPhysY = i; %m
        values=bosbrand()
        test(i,:)=[i,values];
    end
    %[burntArea fireBreakArea envDamage]
    xlswrite('testdata.xls',test)
    test