    clear All; close All; clc;
    global fireBreakWidthPhysX;
    global fireBreakWidthPhysY;
    global fireBreakCountX;
    global fireBreakCountY;
    global fireStationCount;
    global extraTrucks
    
    fireBreakWidthPhysX = 10; %m
    fireBreakWidthPhysY = 10; %m
%     fireBreakCountY = 1;
%     fireBreakCountX = 2*fireBreakCountY;
    fireStationCount = 2;
    extraTrucks = 0;

    maxFireBreakCountY = 36;
    
    test=zeros((maxFireBreakCountY),4);
    for i=1:maxFireBreakCountY
        fireBreakCountY = i;
        fireBreakCountX = 2*fireBreakCountY;
        values=bosbrand()
        test(i,:)=[i,values];
    end
    %[burntArea fireBreakArea envDamage]
    xlswrite('testdata.xls',test)
    test