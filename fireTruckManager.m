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

        function forest = moveFireFighters(~, forest)
            getBounds(forest);
        end
        function getBounds(this,forest)
            global forestSize;
            this.leftBound=0;
            this.topBound = 0;
            this.rightBound = forestSize;
            this.botBound = forestSize;
            flag = 0;
            
            %loop through all columns until a tile is found that is on fire
            for x = 1:forestSize
                for y = 1: forestSize
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
            
            for y = 1:forestSize
                for x = 1: forestSize
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
            for x = forestSize:-1:1
                for y = 1: forestSize
                    if(forest(y,x)>0&&forest(y,x)<=1)
                        %And loop forward when we found fire until we find
                        %a firebreak
                        for i = x:forestSize
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
            
            for y = forestSize:-1:1
                for x = 1: forestSize
                    if(forest(y,x)>0&&forest(y,x)<=1)
                        for i = y:forestSize
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
    end
end

