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
        function this = fireTruckManager()
            global fireTruckCount
            global forest
            for i=1:fireTruckCount
                ft = fireTruck([0,0],[0,0]);
                fireTrucks(i) = ft;
            end
            this.fireTrucks = fireTrucks;   
%             this.getBounds(forest)
            this.leftBound=100
            this.rightBound=200
            this.topBound=100
            this.botBound=200
        end
        
        function forest = moveFireFighters(this, forest)
            this.getCoord(forest);
        end
        
        function getBounds(this,forest)
            global forestWidth;
            global forestHeight;
            this.leftBound=0;
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
        
        function forest = getCoord(this, forest)
            global fireTruckCount
            x=this.leftBound;
            y=this.topBound;
%             this.getBounds(forest);
            this.truckCoords = zeros(2,fireTruckCount);
            totalBound = this.leftBound+this.rightBound+this.topBound+this.botBound;
            truckWidth = totalBound/fireTruckCount;
            side=1;
            for i=1:fireTruckCount
                this.truckCoords(1,i)=x;
                this.truckCoords(2,i)=y;
                if side==1;
                    if truckWidth<this.topBound
                        x=x+truckWidth;
                    else
                        x=this.rightBound;
                        y=this.topBound+(truckWidth-(this.rightBound-this.leftBound));
                        side=2;
                    end
                end
                if side==2
                    if y+truckWidth<this.topBound
                        y=y+truckWidth;
                    else
                        x=this.rightBound;
                        y=this.topBound+(truckWidth-(this.rightBound-this.leftBound));
                        side=2;
                    end
                end
                if side==3
                    x=x-truckWidth;
                end
                 if side==4
                    y=y-truckWidth;
                end
                %                 if truckWith<this.topBound
%                     x=this.leftBound+truckWith;
%                     y=this.topBound;
%                     side=0;
%                 end
%                 if truckWith>this.topBound
%                     x=this.rightBound;
%                     y=this.topBound+(truckWith-(this.rightBound-this.leftBound));
%                     side=1;
%                 end
            end
                    
        end
    end
end

