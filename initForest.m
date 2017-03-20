function forest = initForest(forestSize)
    global fireBreakDist;
    global fireBreakWidth;
    
    %{
    Legend fbr:
        0 = niet brandend bos
        1 = brandend bos
        2 = brandgang
        3 = brandweerauto
        4 = brandweerman
        5 = zij brandweerman
    %}
    forest = zeros(forestSize);
    for x = 1: forestSize 
        for y = 1: forestSize
            if(mod(x,fireBreakDist+fireBreakWidth)<=fireBreakWidth && mod(x,fireBreakDist+fireBreakWidth)~=0 || mod(y,fireBreakDist+fireBreakWidth)<=fireBreakWidth && mod(y,fireBreakDist+fireBreakWidth)~=0)
                forest(y,x)=2;
            end
        end
    end
    
    %Lightning strike
    x = 1;
    y = 1;
    while(~(forest(y,x)==0))
        x = ceil(rand()*forestSize);
        y = ceil(rand()*forestSize);
    end
    forest(y,x) = 1;
    x
    y
    
    %Add firefighter
    forest(1,1)=3;
end