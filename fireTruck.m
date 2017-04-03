classdef fireTruck
    %FIRETRUCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        location;
        fireFighters;
        destination;
        yDirection;
        xDirection;
        doneDeploying;
    end
    
    methods
        function this = fireTruck()
            global fireFightersPerTruck;
            this.fireFighters = fireFightersPerTruck;
            this.doneDeploying = 0;
        end
        function [this,forest] = move(this, forest, topBound, rightBound, botBound, leftBound)
            if(this.location == this.destination)
                [forest,fireFightersUnloaded] = unloadFireFighters(this, forest, topBound, rightBound, botBound, leftBound);
                this.doneDeploying = fireFightersUnloaded;
                return;
            end
            this.doneDeploying = 0;
            global forestWidth;
            global forestHeight;
            locX = this.location(2);
            locY = this.location(1);
            destX = this.destination(2);
            destY = this.destination(1);
            
            %The amount of tiles the fireTruck can move. This is used as
            %iteration variable in the while loop 
            %TODO: change this to something that depends on the global
            %firetruckspeed
            global fireTruckSpeed;
            tilesToMove = fireTruckSpeed;
            while(tilesToMove>0)
                
                %The difference in x and y coordinates
                deltaX = destX-locX;
                deltaY = destY-locY;
                
                if(deltaX == 0 && deltaY ==0)
                    break;
                end
                
                %Decrease the amount of tiles we can move by 1
                tilesToMove = tilesToMove -1;
                
                %xMod and yMod are to prevent that we try to check tiles
                %that lie outside of the forest
                xMod =1;
                if(locX == forestWidth)
                    xMod =-1;
                end
                yMod =1;
                if(locY == forestHeight)
                    yMod = -1;
                end
                

                %Check if we are on a junction. If that is the case, then
                %look which way we should go. Otherwise, continue in the
                %direction we were heading. Originally, it checked which
                %way to go even when it wasn't on a junction, however, this
                %results in a bug where the firetruck won't move if the 
                %current location is somewhere between 2 junctions and the 
                %destination is and the destination in the same way between
                %2 other junctions so that the firetruck would need to take
                %2 of the same turns to arrive at that destination.
                if (forest(locY,locX+xMod)>=2 && forest(locY+yMod,locX)>=2)
                     if (abs(deltaY) >= abs(deltaX) && abs(deltaY)>0)
                        locY = locY + sign(deltaY);
                        this.yDirection = sign(deltaY);
                     elseif (abs(deltaY) < abs(deltaX) && abs(deltaX)>0)
                        locX = locX + sign(deltaX);
                        this.xDirection = sign(deltaX);
                     end
                elseif (forest(locY,locX+xMod)>=2)
                    locX = locX + this.xDirection;
                elseif (forest(locY+yMod,locX)>=2)
                    locY = locY + this.yDirection;
                else
                    error('a truck is inside the forest!!!');
                end
                
            end
            this.location = [locY, locX];
            
            
        end
        
        function this = setDestination(this, destination)
            this.destination = destination;
            
            %Check if the new destination is a junction.
        end
        
        function [forest,doneDeploying] = unloadFireFighters(this, forest, topBound, rightBound, botBound, leftBound)
            %{
            direction = 
                1: top
                2: right
                3: bot
                4: left
            %}
            x = this.location(2);
            y = this.location(1);
            fireFighterPerCycle = 1;
            if(this.location(1) == topBound)
                %top-right corner. Deploy downwards and to the left
                if(this.location(2) == rightBound)
                    [forest,doneDeploying1] = deployFireFighter(this,x,y+1, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 3);
                    [forest,doneDeploying2] = deployFireFighter(this,x-1,y, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 4);
                %top-left corner. Deploy to the right and downwards
                elseif(this.location(2)== leftBound)
                    [forest,doneDeploying1] = deployFireFighter(this,x+1,y, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 2);
                    [forest,doneDeploying2] = deployFireFighter(this,x,y+1, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 3);
                %top side. Deploy to the right and left
                else
                    [forest,doneDeploying1] = deployFireFighter(this,x+1,y, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 2);
                    [forest,doneDeploying2] = deployFireFighter(this,x-1,y, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 4);
                end
            elseif(this.location(1) == botBound)
                %bot-right corner. Deploy upwards and to the left
                if(this.location(2) == rightBound)
                    [forest,doneDeploying1] = deployFireFighter(this,x,y-1, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 1);
                    [forest,doneDeploying2] = deployFireFighter(this,x-1,y, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 4);
                %bot-left corner. Deploy upwards and to the right
                elseif(this.location(2) == leftBound)
                    [forest,doneDeploying1] = deployFireFighter(this,x,y-1, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 1);
                    [forest,doneDeploying2] = deployFireFighter(this,x+1,y, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 2);
                %bottom side. Deploy to the right and to the left
                else
                    [forest,doneDeploying1] = deployFireFighter(this,x+1,y, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 2);
                    [forest,doneDeploying2] = deployFireFighter(this,x-1,y, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 4);
                end
            else
                %right side or right side. Deploy upwards and downwards
                if(this.location(2) == rightBound || this.location(2) == leftBound)
                    [forest,doneDeploying1] = deployFireFighter(this,x,y-1, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 1);
                    [forest,doneDeploying2] = deployFireFighter(this,x,y+1, forest, topBound, rightBound, botBound, leftBound, fireFighterPerCycle, 3);
                %no place on the boundaries of he fire but we are not
                %moving. Something is wrong
                else
                    error('i am not supposed to reach this code');
                end
            end
            if(doneDeploying1 == 1 && doneDeploying2)
                doneDeploying = 1;
            else
                doneDeploying = 0;
            end
        end
        function [forest,doneDeploying] = deployFireFighter(this,x,y, forest, topBound, rightBound, botBound, leftBound, fireFighterCount,direction)
            %If we encounter another firetruck, our part of the cycle is
            %done and we can return everything.
            doneDeploying = 0;
            if(forest(y,x) == 3)
                doneDeploying = 1;
                return;
            end
            
            %If we encounter an empty tile, place a firefighter on that
            %tile and decrease the firefighter count by one
            if(forest(y,x) == 2)
                forest(y,x) = 4;
                fireFighterCount = fireFighterCount -1;
                %If we have no more fireFighters to place, we can return
                %everything
                if(fireFighterCount == 0)
                    return;
                end
            end
            
            %upwards
            if(direction == 1)
                %Check if we can still go up
                if(y>topBound)
                    y = y-1;
                %If not, go left or right depending on our x coordinate
                else
                    if(x == rightBound)
                        x = x-1;
                        direction = 4;
                    elseif(x == leftBound)
                        x = x+1;
                        direction = 2;
                    end
                end
            %to the right
            elseif(direction == 2)
                if(x<rightBound)
                    x = x+1;
                else
                    if(y == topBound)
                        y = y+1;
                        direction = 3;
                    elseif(y==botBound)
                        y = y-1;
                        direction = 1;
                    end
                end
            %downwards
            elseif(direction == 3)
                if(y<botBound)
                    y = y+1;
                else
                    if(x == rightBound)
                        x = x-1;
                        direction = 4;
                    elseif(x == leftBound)
                        x = x+1;
                        direction = 2;
                    end
                end
            %to the left
            elseif(direction == 4)
                if(x>leftBound)
                    x= x-1;
                else
                    if(y == topBound)
                        y = y+1;
                        direction = 3;
                    elseif(y==botBound)
                        y = y-1;
                        direction = 1;
                    end
                end
            else
                error('error, not supposed to come here')
            end

            [forest,doneDeploying] = deployFireFighter(this,x,y, forest, topBound, rightBound, botBound, leftBound, fireFighterCount, direction);

        end
    end 
end

