classdef fireTruck
    %This class contains all the behaviour of a firetruck
    %   When a destination is assigned, the function move can be used to
    %   let the firetruck find it's own way through the forest. If the
    %   firetruck is at it's location, it will start to unload firefighters
    %   automatically.
    
    properties
        location;
        destination;
        %The direction in the x- and y-axis in which we are/were moving.
        %This is used to prevent a bug discussed in paragraph 4.6.2
        yDirection;
        xDirection;
        %A flag to check if we are done with unloading firefighters. This
        %is used by the fireTruckManager to check if the fire is surrounded
        doneDeploying;
    end
    
    methods
        function this = fireTruck()
            global fireFightersPerTruck;
            this.fireFighters = fireFightersPerTruck;
            this.doneDeploying = 0;
        end
        function [this,forest] = move(this, forest, topBound, rightBound, botBound, leftBound)
            %If we are at our location, start to unload firefighters
            if(this.location == this.destination)
                [forest,fireFightersUnloaded] = unloadFireFighters(this, forest, topBound, rightBound, botBound, leftBound);
                this.doneDeploying = fireFightersUnloaded;
                %Return after we tried to deploy firefighters since the
                %rest of the function tries to move the firetruck towards
                %it's destination (which we already reached)
                return;
            end
            
            %We clearly aren't done with deploying yet if we haven't
            %reached our desination.
            this.doneDeploying = 0;
            global forestWidth;
            global forestHeight;
            
            %Some shorthands to make the code more readable
            locX = this.location(2);
            locY = this.location(1);
            destX = this.destination(2);
            destY = this.destination(1);
            
            %The amount of tiles the fireTruck can move in one iteration. 
            %This is used as iteration variable in the while loop 
            global fireTruckSpeed;
            tilesToMove = fireTruckSpeed;
            while(tilesToMove>0)
                
                %The difference in x and y coordinates
                deltaX = destX-locX;
                deltaY = destY-locY;
                
                %If the difference is 0 in both directions, then we reached
                %our destination and we can quit this while loop
                if(deltaX == 0 && deltaY ==0)
                    break;
                end
                
                %Decrease the amount of tiles we can move by 1
                tilesToMove = tilesToMove -1;
                
                %xMod and yMod are the variables that will be used to check
                %the neigbouring tiles. These are 1 as long as we can check
                %right to us and below us. This will however result in an
                %error if we are already at the far right or bottom of the
                %matrix so then xMod and/or yMod is changed to -1 so we
                %check above and/or left to us.
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
                    %This should never be reached and thus throws an error
                    %the moment it should happen in case of a bug
                    error('a truck is inside the forest!!!');
                end
                this.location = [locY, locX];
            end
            
            
            
        end
        
        function this = setDestination(this, destination)
            this.destination = destination;
        end
        
        %This is the starting function to deploy the firefighters. This
        %will fire of a recursive function (deployFireFighters) to check
        %where to deploy the firefighters. This function in itself won't do
        %anything with the firefighters!
        function [forest,doneDeploying] = unloadFireFighters(this, forest, topBound, rightBound, botBound, leftBound)
            %{
            direction = 
                1: top
                2: right
                3: bot
                4: left
            %}
            %Again, shorthands just for writing convenience
            x = this.location(2);
            y = this.location(1);
            %This can be changed to increase the speed at which we unload
            %the firefighters, however, 1 per cycle is actually already
            %really fast so we kept this constant across al simulations.
            fireFighterPerCycle = 1;
            
            %Check at which location we are and start the recursive loop to
            %deploy a firefighter in 2 directions to try to surround the
            %fire
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
            %If at both sides of the firetruck the firefighters managed to
            %succesfully surround their part of the fire, then raise the
            %flag that we are done with our task.
            if(doneDeploying1 == 1 && doneDeploying2)
                doneDeploying = 1;
            else
                doneDeploying = 0;
            end
        end
        
        %This function checks at the given coordinates if it can deploy
        %deploy a firefighter, if it needs to look further for a place to
        %deploy a firefighter (in case there already is a firefighter) or
        %if there is a firetruck in which case this part of the cycle is
        %done. The direction parameter is used to keep track of which
        %direction the algorithm is going.
        %It is possible to place multiple firefighters in one loop by
        %increasing the firefigtercount parameter.
        function [forest,doneDeploying] = deployFireFighter(this,x,y, forest, topBound, rightBound, botBound, leftBound, fireFighterCount,direction)
            
            %If we encounter another firetruck, this part of the 
            %circumference is done and we can return everything.
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
            
            %Apparetly the tile is not empty and there isn't a firetruck at
            %this tile which means there is already a firefighter on this
            %tile. Depending on the direction in which the algorithm change
            %the parameters so this function can be called again.
            
            %upwards
            if(direction == 1)
                %Check if we can still go up
                if(y>topBound)
                    y = y-1;
                %If not, we are in a corner and we go left or right 
                %depending on our x coordinate
                else
                    if(x == rightBound)
                        x = x-1;
                        direction = 4;
                    elseif(x == leftBound)
                        x = x+1;
                        direction = 2;
                    end
                end
            
            %The other parts of this if-elseif-else block are more or less
            %parallel and won't be explained in comments
            
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
                %The direction should always be a number between 1 and 4.
                %If that's not the case then we have encountered a bug and
                %an error should be thrown.
                error('error, not supposed to come here')
            end

            [forest,doneDeploying] = deployFireFighter(this,x,y, forest, topBound, rightBound, botBound, leftBound, fireFighterCount, direction);

        end
    end 
end

