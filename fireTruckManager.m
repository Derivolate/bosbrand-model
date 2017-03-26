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
        truckCoords;
    end
    
    methods
        function this = fireTruckManager(forest)
            global fireTruckCount
            for i=1:fireTruckCount
                ft = fireTruck([0,0],[0,0]);
                fireTrucks(i) = ft;
            end
            this.fireTrucks = fireTrucks; 
            
            this.getBounds(forest)
%             this.leftBound=25;
%             this.rightBound=255;
%             this.topBound=35;
%             this.botBound=455;
            
            %voeg de truckCoords toe de properties, moet later in een keer
            %in fireTrucks
            truckCoords = this.getCoords(); 
        end
        
        function forest = moveFireFighters(this, forest)
            this.getCoord(forest);
        end
        
        function getBounds(this,forest)
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
                    if(forest(y,x)>0&&forest(y,x)<=1)
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
                    if(forest(y,x)>0&&forest(y,x)<=1)
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
                    if(forest(y,x)>0&&forest(y,x)<=1)
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
                    if(forest(y,x)>0&&forest(y,x)<=1)
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
        
        function truckCoords = getCoords(this) %berekend de coordinaten waar de trucks naartoe moeten
            global fireTruckCount
            x = this.leftBound;
            y = this.topBound;
            truckCoords = zeros(2,fireTruckCount);
            
            fireWidth = this.rightBound-this.leftBound; % de breedte van het bos dat in de fik staat
            fireHeight = this.botBound-this.topBound; %de hoogte van het bos dat in de fik staat
            totalBound = 2*fireHeight+2*fireWidth; %de totale boundary die bemand moet worden
            truckWidth = totalBound/fireTruckCount; %de breedte van het bos dat een firetruck moet beschermen
          
            side=1; %side1=bovenkant, side2=rechts, side3=onder, side4=links
            %begint bij de linkerboven hoek en loopt dan iedere keer een
            %truckwidth verder met de klok mee
            for i=1:fireTruckCount
                truckCoords(1,i) = x; % voeg x toe aan een 2xi-matrix met coordinaten
                truckCoords(2,i) = y; % voeg y toe aan een 2xi-matrix met coordinaten
                if side == 4 %als laatste zijde 4
                    if y-truckWidth>this.topBound
                        y = y-truckWidth;
                    end
                end
                if side == 3
                    if x-truckWidth>this.leftBound
                        x = x-truckWidth;
                    else
                        y = this.botBound-(truckWidth-(x-this.leftBound));
                        x = this.leftBound;
                        side = 4;
                    end
                end
                if side == 2
                    if y+truckWidth<this.botBound
                        y = y+truckWidth;
                    else
                        x = this.rightBound-(truckWidth+y-this.botBound);
                        y = this.botBound;
                        side = 3;
                    end
                end
                if side == 1; % als eerste zijde 1
                    if x+truckWidth<this.rightBound % check of de truckwidth meer is als de resterende breedte in de x richting
                        x = x+truckWidth;
                    else
                        y = this.topBound+(truckWidth+x-this.rightBound); % bereken de extra verplaatsing in y richting, doordat er truckwidth 'over' is 
                        x = this.rightBound; 
                        side = 2; 
                    end
                end
            end
            if abs(y-this.topBound)>truckWidth/10
                %change 'disp' to 'error' to make it a proper error message
                disp('The last gap between trucks is more than  1/10 of the truckWidth. This may impact accuracy.')
            end
        end
    end
end

