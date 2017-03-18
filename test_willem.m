%%willem test
cMap=makeColorMap([244,66,66], [244,241,66], [83,244,66],10)
b=[1 1 1]
cMap=[cMap;b]



% n=0
% figure;
% while n<10
%     rand('twister',1);
%     X = randn(10,10);
%     imagesc(X);
%     colorbar;
%     drawnow;
%     n=n+1
% end

% h = animatedline;
% axis([0 4*pi -1 1])
% x = linspace(0,4*pi,2000);
% 
% for k = 1:length(x)
%     y = sin(x(k));
%     addpoints(h,x(k),y);
%     drawnow
% end
% 
