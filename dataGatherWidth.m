   %%% this document is used to calculate the ideal firebreak width
   
   %%% code might not work because of double initialization of globals, in
   %%% this document and in init.globals
   
   %%% run bosbrand.m instead

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
    
    % a matrix to store the EnvironmentDamage values
    test=zeros(4,4);
    % a simple loop to vary one single variable
    for i=minWidth:step:maxWidth
        fireBreakWidthPhysX = i; %m
        fireBreakWidthPhysY = i; %m
        values=bosbrand()
        test(i,:)=[i,values];
    end
    %[burntArea fireBreakArea envDamage]
    xlswrite('testdata.xls',test)
    test