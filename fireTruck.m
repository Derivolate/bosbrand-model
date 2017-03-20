classdef fireTruck
    %FIRETRUCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x;
        y;
        fireFighters;
        settled;
        destination;
    end
    
    methods
        function move(forest)
            if(settled==1)
                for i = 1:Length(fireFighters)
                    fireFighters(i).move(forest);
                end
            else
                moveTile();
            end
        end
        
        function moveTile()
        end
    end
    
end

