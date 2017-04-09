   %%% this document is used to calculate the ideal amount of trucks (slightly differently)
   %%% code might not work because of double initialization of globals, in
   %%% this document and in init.globals
   
   %%% run bosbrand.m instead

    clear All; close All; clc;
    global fireBreakWidthPhysX
    global fireBreakWidthPhysY
    global fireBreakCountX
    global fireBreakCountY
    global fireStationCount
    global extraTrucks
    global lightningX
    global lightningY
    global forestWidth
    global forestHeight
    
    fireBreakWidthPhysX = 5; %m
    fireBreakWidthPhysY = 5; %m
    fireBreakCountY = 17;
    fireBreakCountX = fireBreakCountY;
    fireStationCount = 1;
%     extraTrucks = 0;
    
    %the coordinate
    lightningX = forestWidth/4; % computing the coordinate the fire starts
    lightningY = forestHeight/4;

    maxExtraTrucks = 6;
    step = 1;
    
    % a matrix to store the EnvironmentDamage values
    test=zeros((maxExtraTrucks/step),4);
    % a simple loop to vary one single variable
    for i=0:step:maxExtraTrucks
        extraTrucks = i;
        values=bosbrand()
        test(i/step+1,:)=[i,values];
    end
    %[burntArea fireBreakArea envDamage] = de sequence of data in the excel
    %sheet
    xlswrite('testdata.xls',test)
    test