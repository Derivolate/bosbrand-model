   %%% this document is used to calculate the ideal amount of firestations
   
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
    
    fireBreakWidthPhysX = 10; %m
    fireBreakWidthPhysY = 10; %m
    fireBreakCountY = 0;
    fireBreakCountX = 2*fireBreakCountY;
%     fireStationCount = 0;
    extraTrucks = 0;

    maxFireStationCount = 3;
    
    % a matrix to store the EnvironmentDamage values
    test=zeros((maxFireStationCount),4);
    % a simple loop to vary one single variable
    for i=1:maxFireStationCount
        fireStationCount = i;
        values=bosbrand()
        test(i,:)=[i,values];
    end
    %[burntArea fireBreakArea envDamage] = de sequence of data in the excel
    %sheet
    xlswrite('testdata.xls',test)
    test