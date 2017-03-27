classdef fireTruck
    %FIRETRUCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        location;
        fireFighters;
        settled;
        destination;
    end
    
    methods
        function this = fireTruck(location, destination)
%             this.location =location;
%             this.destination = destination;
            global fireFightersPerTruck;
            this.fireFighters = fireFightersPerTruck;
            this.settled = 0;
        end
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

