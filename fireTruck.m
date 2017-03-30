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
        function this = move(this, forest)
            if(this.settled == 1)
%                 for i = 1:Length(this.fireFighters)
%                     this.fireFighters(i).move(forest);
%                 end
                return;
            end
            global forestWidth;
            global forestHeight;
            locX = this.location(2);
            locY = this.location(1);
            destX = this.destination(2);
            destY = this.destination(1);

            deltaX = destX-locX;
            deltaY = destY-locY;
            
            %The amount of tiles the fireTruck can move. This is used as
            %iteration variable in the while loop 
            %TODO: change this to something that depends on the global
            %firetruckspeed
            global fireTruckSpeed;
            tilesToMove = fireTruckSpeed;
            while(tilesToMove>0)
                tilesToMove = tilesToMove -1;
                
                xMod =1;
                if(locX == forestWidth)
                    xMod =-1;
                end
                yMod =1;
                if(locY == forestHeight)
                    yMod = -1;
                end
                
                if (forest(locY,locX+xMod)>=2 && forest(locY+yMod,locX)>=2)
                    if (abs(deltaY) >= abs(deltaX) && abs(deltaY)>0)
                        locY = locY + sign(deltaY);
                    elseif (abs(deltaY) < abs(deltaX) && abs(deltaX)>0)
                        locX = locX + sign(deltaX);
                    end
                elseif (forest(locY,locX+xMod)>=2)
                    locX = locX + sign(deltaX);
                elseif (forest(locY+yMod,locX)>=2)
                    locY = locY + sign(deltaY);
                else
                    error('a truck is inside the forest!!!');
                end
                
                
                %%%
                if([locY, locX] == this.destination)
                    this.settled = 1;
                    break;
                end
            end
            this.location = [locY, locX];
            
            
        end
        
        function this = setDestination(this, destination)
            this.destination = destination;
        end
        
        function moveTile()
        end
    end
    
end

