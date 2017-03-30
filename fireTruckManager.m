classdef fireTruckManager
    %FIRETRUCKMANAGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fireTrucks;
        leftBound;
        rightBound;
        topBound;
        botBound;
        stationCoords;
    end
    
    methods
        function this = fireTruckManager(forest)
            global fireTruckCount
            for i=1:fireTruckCount % build an array filled with firetrucks, of the class firetruck
                ft = fireTruck([0,0],[0,0]);
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
            
            for i=1:fireStationCount %show the firestations //temporary
                forest(this.stationCoords(i,2),this.stationCoords(i,1)) = 5;
            end

        end
        
        function [this,forest] = moveFireFighters(this, forest)
            global fireTruckCount
            truckDestinations = this.getDestinations(forest);
           
            %Set the destination for each fireTruck
            for i=1:fireTruckCount
                this.fireTrucks(i) = this.fireTrucks(i).setDestination(truckDestinations(i,:));
            end
            
            for i=1:fireTruckCount
                forest(this.fireTrucks(i).location(1), this.fireTrucks(i).location(2)) = 2;
                this.fireTrucks(i) = this.fireTrucks(i).move(forest);
                forest(this.fireTrucks(i).location(1), this.fireTrucks(i).location(2)) = 3;
            end
            
        end
        
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
                            if(forest(i,x)==2||forest(i,x)==3||forest(i,x)==4||forest(i,x)==5)
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
            
            for x = 1:forestWidth
                for y = 1: forestHeight
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
                            if(forest(i,x)==2||forest(i,x)==3||forest(i,x)==4||forest(i,x)==5)
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
        function truckDestinations = getDestinations(this, forest) 
            global fireTruckCount
            global errorFlag
            
            this = this.getBounds(forest);
            
            x = this.leftBound;
            y = this.topBound;
            truckCoords = zeros(fireTruckCount,2);
            
            fireWidth = this.rightBound-this.leftBound; % the width of the burning part of the forest
            fireHeight = this.botBound-this.topBound; % the heigth of the burning part of the forest
            totalBound = 2*fireHeight+2*fireWidth; %de totale boundary to be defended
            truckWidth = totalBound/fireTruckCount; % forestwidth one truck has to cover
          
            
            side = 1; %side1=upper boundary, side2=right boundary, side3=bottom boundary, side4=left boundary
            %start in the upper left corner and follows the boundary
            %clockwise
            for i=1:fireTruckCount
                truckCoords(i,2) = x; % add x to a ix2-matrix with coordinates
                truckCoords(i,1) = y; % add y to a ix2-matrix with coordinates
                if side == 1; % first side 1
                    if x+truckWidth<this.rightBound % check whether the truck has remaining truckwidth in the x direction
                        x = x+truckWidth;
                    else
                        y = this.topBound+(truckWidth+x-this.rightBound); % calculates the extra movement in y, due to the remaining width 
                        x = this.rightBound; 
                        side = 2; 
                    end
                elseif side == 2
                    if y+truckWidth<this.botBound
                        y = y+truckWidth;
                    else
                        x = this.rightBound-(truckWidth+y-this.botBound);
                        y = this.botBound;
                        side = 3;
                    end
                elseif side == 3
                    if x-truckWidth>this.leftBound
                        x = x-truckWidth;
                    else
                        y = this.botBound-(truckWidth-(x-this.leftBound));
                        x = this.leftBound;
                        side = 4;
                    end
                else %lastly side 4
                    if y-truckWidth>this.topBound
                        y = y-truckWidth;
                    end
                end
                
            end
            if (abs(y-this.topBound)>truckWidth/10 && errorFlag==0)
                %change 'disp' to 'error' to make it a proper error message
                %disp('The last gap between trucks is more than  1/10 of the truckWidth. This may impact accuracy.')
                  errorFlag = 1;
            end
            truckDestinations = round(truckCoords);
        end
    end
end

