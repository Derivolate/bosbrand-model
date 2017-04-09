   %%% to calculate the ideal frequency
   %%% code might not work because of double initialization of globals
   %%% run bosbrand.m instead

    clear All; close All; clc;
    global fireBreakWidthPhysX;
    global fireBreakWidthPhysY;
    global fireBreakCountX;
    global fireBreakCountY;
    global fireStationCount;
    global extraTrucks
    
    fireBreakWidthPhysX = 10; %m
    fireBreakWidthPhysY = 10; %m
    fireBreakCountY = 0;
    fireBreakCountX = 2*fireBreakCountY;
    fireStationCount = 2;
    extraTrucks = 0;

    maxFireBreakCountY = 0;
    
    test=zeros((maxFireBreakCountY),4);
    for i=1:maxFireBreakCountY
        fireBreakCountY = i;
        fireBreakCountX = 2*fireBreakCountY;
        values=bosbrand()
        test(i,:)=[i,values];
    end
    %[burntArea fireBreakArea envDamage] = de sequence of data in the excel
    %sheet
    xlswrite('testdata.xls',test)
    test