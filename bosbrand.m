function bosbrand()
    %creeer bos
    forestSize = 4;
    forest = zeros(forestSize);
    
    %blikseminslag op 2,2
    disp('bos na blikseminslag')
    forest= bliksemInslag(forest)
    disp('bos na eerste vuurverspreiding')
    forest = verspreidVuur(forest, forestSize)
end

function forest = bliksemInslag(forest)
    forest(1,2) = 1;
end

function forest = verspreidVuur(forest, forestSize)
    for x = 1:forestSize
        for y = 1:forestSize
            if(~(x+1>forestSize))
                if(forest(y,x+1)==1)
                    forest(y,x) = forest(y,x) + 0.25;
                end
            end 
            if(~(x-1==0))
                if(forest(y,x-1)==1)
                    forest(y,x)= forest(y,x)+0.25;
                end
            end
            if(~(y+1>forestSize))
                if(forest(y+1,x)==1)
                    forest(y,x)= forest(y,x)+0.25;
                end
            end
            if(~(y-1==0))
                if(forest(y-1,x)==1)
                    forest(y,x)= forest(y,x)+0.25;
                end
            end
        end
    end
end