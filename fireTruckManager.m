classdef fireTruckManager
    %This class analyzes the fire so it can calculate the destinations for
    %the firetrucks and distribute those destinations.
    %   When moveFireFighters is called, all destinations are calculated
    %   first. This is done by first checking the bounding firebreaks of the fire in
    %   getBounds. Then this cirumference is sprit into parts and all 
    %   destinations are chosendepending on the amount of firetrucks and 
    %   the wind. In the case that there is a wind blowing, then the
    %   concentration of firetrucks at the side of the fire to which the
    %   wind is blowing is higher then on the opposite side.
    properties
        fireTrucks;
        leftBound;
        rightBound;
        topBound;
        botBound;
        stationCoords;
        truckDestinations;
        fireSurrounded;
    end
    
    methods
        function this = fireTruckManager(forest)
            global fireTruckCount
            for i=1:fireTruckCount % build an array filled with instances of the class firetruck
                ft = fireTruck();
                fireTrucks(i) = ft;
            end
            this.fireTrucks = fireTrucks; 
                        
            global stationCoords
            this.stationCoords = stationCoords;
            
            global fireStationCount
            global fireTruckPerStationCount 
            
            % every firestation has a number of trucks, station 1 has trucks 1-3 etc. So
            % we loop over the stations and for every station we loop the
            % trucksPerStation. The specific trucknumbers that get assigned to a station
            % are 1 for every truck per station (j) + the amount of trucks per station
            % times the number of stations allready filled (i). Because i starts at 1 we
            % have to compensate by subtracting the amount of trucks per station.
            
            for i=1:fireStationCount %set starting locating for the fireTrucks
                for j=1:fireTruckPerStationCount
                    truckIndex = j+i*fireTruckPerStationCount-fireTruckPerStationCount;
                    this.fireTrucks(truckIndex).location = stationCoords(i,:);
                end
            end
            
            for i=1:fireStationCount %show the firestations in the forest
                forest(this.stationCoords(i,2),this.stationCoords(i,1)) = 5;
            end
            
            %Of course the fire isn't surrounded as of yet
            this.fireSurrounded = 0;
        end
        
        function [this,forest] = moveFireFighters(this, forest)
            global fireTruckCount
            oldDestinations = this.truckDestinations;
            [this,this.truckDestinations] = this.getDestinations(forest);
            
            %If the destinations of the firetrucks aren't the same as the
            %previous cycle, then all firetrucks should pack and move to
            %their new location. Also all the firefighters should be
            %instantly cleared so the fire can spread as it should. This is
            %further explained in paragraph 4.3.3: Brandweer`
            if~(isequal(this.truckDestinations,oldDestinations))
               forest = clearFireFighters(this, forest); 
            end
           
            %Set the destination for each fireTruck
            for i=1:fireTruckCount
                this.fireTrucks(i) = this.fireTrucks(i).setDestination(this.truckDestinations(i,:));
            end
            
            deployCount =0;
            for i=1:fireTruckCount
                oldX = this.fireTrucks(i).location(2);
                oldY = this.fireTrucks(i).location(1);
                %Move the firetrucks and if they are already settled,
                %deploy the firefighters.
                [this.fireTrucks(i),forest] = this.fireTrucks(i).move(forest, this.topBound, this.rightBound, this.botBound, this.leftBound);
                %Change the previous tile to firebreak again because we
                %aren't there anymore
                forest(oldY, oldX) = 2;
                %Change the new tile
                forest(this.fireTrucks(i).location(1), this.fireTrucks(i).location(2)) = 3;
                %Keep track of how much trucks are done with deploying
                %their firefighters
                if(this.fireTrucks(i).doneDeploying == 1)
                    deployCount = deployCount+1;
                end
            end
            %If all trucks are done with deploying their firefighters, then 
            %the fire is surrounded
            if(deployCount == fireTruckCount)
                this.fireSurrounded = 1;
            end
            
        end
        
        %A algorithm which should do the 'simple task' of tracking down te
        %coordinates of the firebreaks which surround the forest and thus
        %on which the destinations should lie.
        function this = getBounds(this,forest)
            global forestWidth;
            global forestHeight;
            this.leftBound = 0;
            this.topBound = 0;
            this.rightBound = forestWidth;
            this.botBound = forestHeight;
            flag = 0;
            
            %loop through all columns until a tile is found that is on fire
            for x = 1:forestWidth
                for y = 1:forestHeight
                    %if(forest(y,x)>0&&forest(y,x)<=1)
                    if(forest(y,x)==1)
                        %then, loop back until a tile is found with a
                        %firebreak
                        for i = x:-1:0
                            if(forest(y,i)==2||forest(y,i)==3||forest(y,i)==4||forest(y,i)==5)
                                this.leftBound = i;
                                flag = 1;
                                break
                            end
                        end
                        if(flag == 1)
                            break;
                        end
                    end
                end
                if(flag == 1)
                    break;
                end
            end
            flag = 0;
            
            for y = 1:forestHeight
                for x = 1: forestWidth
                    %if(forest(y,x)>0&&forest(y,x)<=1)
                    if(forest(y,x)==1)
                        for i = y:-1:0
                            if(forest(i,x)==2||forest(i,x)==3||forest(i,x)==4||forest(i,x)==5)
                                this.topBound = i;
                                flag = 1;
                                break
                            end
                        end
                        if(flag == 1)
                            break;
                        end
                    end
                end
                if(flag == 1)
                    break;
                end
            end
            flag = 0;
            
            %Here we loop through all the columns backwards to find the
            %right side of the fire
            for x = forestWidth:-1:1
                for y = 1: forestHeight
                    %if(forest(y,x)>0&&forest(y,x)<=1)
                    if(forest(y,x)==1)
                        %And loop forward when we found fire until we find
                        %a firebreak
                        for i = x:forestWidth
                            if(forest(y,i)==2||forest(y,i)==3||forest(y,i)==4||forest(y,i)==5)
                                this.rightBound = i;
                                flag = 1;
                                break
                            end
                        end
                        if(flag == 1)
                            break;
                        end
                    end
                end
                if(flag == 1)
                    break;
                end
            end
            flag = 0;
            
            for y = forestHeight:-1:1
                for x = 1: forestWidth
                    %if(forest(y,x)>0&&forest(y,x)<=1)
                    if(forest(y,x)==1)
                        for i = y:forestHeight
                            if(forest(i,x)==2||forest(i,x)==3||forest(i,x)==4||forest(i,x)==5)
                                this.botBound = i;
                                flag = 1;
                                break
                            end
                        end
                        if(flag == 1)
                            break;
                        end
                    end
                end
                if(flag == 1)
                    break;
                end
            end
            
        end
        
        %computes the coordinates trucks are heading towards
        function [this,truckDestinations] = getDestinations(this, forest) 
            global fireTruckCount;
            global windDir;
            global windStr;
            global fireBreakDistX;
            global fireBreakDistY;
            this = this.getBounds(forest);
            
            x = this.leftBound;
            y = this.topBound;
            truckCoords = zeros(fireTruckCount,2);
            
            fireWidth = this.rightBound-this.leftBound; % the width of the burning part of the forest
            fireHeight = this.botBound-this.topBound; % the heigth of the burning part of the forest
            totalBound = 2*fireHeight+2*fireWidth; %de totale boundary to be defended
            truckWidth = totalBound/fireTruckCount; % forestwidth one truck has to cover
            
            %The factors by which the spread of the destinations will be
            %weighed
            topFac = 1-sin(windDir)*windStr*2;
            rightFac = 1+cos(windDir)*windStr*2;
            botFac = 1+sin(windDir)*windStr*2;
            leftFac = 1-cos(windDir)*windStr*2;
            
            side = 1; 
            %side = 1: upper boundary
            %side = 2: right boundary
            %side = 3: bottom boundary
            %side = 4: left boundary
            %start in the upper left corner and follows the boundary
            %clockwise and pick a location after each truckWidth.
            %Truckwidth is weighed depending on the wind strength and
            %direction
            truckWidth = truckWidth/topFac;
            for i=1:fireTruckCount
                truckCoords(i,2) = x; % add x to a ix2-matrix with coordinates
                truckCoords(i,1) = y; % add y to a ix2-matrix with coordinates
                if(i == fireTruckCount)
                    break;
                end
                %The top
                if side == 1;
                    % check whether the truck has remaining truckwidth in the x direction
                    if x+truckWidth<this.rightBound 
                        x = x+truckWidth;
                    %If not, we need to go around a corner
                    else
                        % calculates the extra movement in y, due to the remaining width 
                        
                        %Check how much width we have left after the corner
                        remainingTruckWidth = truckWidth - (this.rightBound-x);
                        %Weigh the remaining distance with a new factor
                        remainingTruckWidth = (remainingTruckWidth*topFac)/rightFac;
                        %Use the newly weighed remaining distance for the
                        %new coordinate
                        
                        %First check if we won't go around another corner
                        if(this.topBound+remainingTruckWidth <= this.botBound)
                            y = this.topBound+remainingTruckWidth; 
                            x = this.rightBound; 
                            side = 2; 
                        %If we do indeed go around another corner
                        else
                            y = this.botBound;
                            %Take how much we have left of the truckwidth
                            %and subtract the height of the burning area
                            x = this.rightBound - (remainingTruckWidth - (this.botBound - this.topBound));
                            side = 3;
                        end
                        
                        %Weigh the truckwidth for the new side
                        truckWidth = (truckWidth*topFac)/rightFac;
                    end
                %The right side
                elseif side == 2
                    if y+truckWidth<this.botBound
                        y = y+truckWidth;
                    else
                        remainingTruckWidth = truckWidth - (this.botBound -y);
                        remainingTruckWidth = (remainingTruckWidth*rightFac)/botFac;
                        if(this.rightBound-remainingTruckWidth >= this.leftBound)
                            x = this.rightBound-remainingTruckWidth;
                            y = this.botBound;
                            side = 3;
                        else
                            x = this.leftBound;
                            y = this.botBound - (remainingTruckWidth - (this.rightBound - this.leftBound));
                            side = 4;
                        end
                        truckWidth = (truckWidth*rightFac)/botFac;
                    end
                %The bottom side
                elseif side == 3
                    if x-truckWidth>this.leftBound
                        x = x-truckWidth;
                    else
                        remainingTruckWidth = truckWidth - (x - this.leftBound);
                        remainingTruckWidth = (remainingTruckWidth*botFac)/leftFac;
                        y = this.botBound-remainingTruckWidth;
                        x = this.leftBound;
                        side = 4;
                        truckWidth = (truckWidth*botFac)/leftFac;
                    end
                %The left side
                else 
                    if y-truckWidth>this.topBound
                        y = y-truckWidth;
                    end
                end
                
            end

            truckDestinations = round(truckCoords);
        end
        
        %This function clears the whole forest of firefighters as they are
        %too lazy to clean up their stuff themselves
        function forest = clearFireFighters(~, forest)
            global forestWidth;
            global forestHeight
            for x = 1:forestWidth
                for y = 1:forestHeight
                    if(forest(y,x) == 4)
                        forest(y,x) = 2;
                    end
                end
            end
        end
    end
end

