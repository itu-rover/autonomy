clear all;
clc;

% SensorSizeX = 6.55;
% SensorSizeY = 4.92;
% Altitude = 50; %meter
% FocalLenght = 8; %mm
% Overlap = 0.3; % 30% overlap
% 
% 
% 
% %Find Capture Size of camera in spesific altitude
% PicSize = CaptureSize(SensorSizeX, SensorSizeY, FocalLenght,  Altitude);

%Decided edge coordinates of agricultural area  

% Polygon = [ 41.100449 29.021298;...
%             41.102022 29.018004;...
%             41.104359 29.020386;...
%             41.102289 29.019463];
%         
        
%  Polygon = [ 41.106652 29.048714;...
%             41.107112 29.054453;...
%             41.109674 29.054351;...
%             41.109915 29.050632];

%   Polygon = [ 41.103950 29.027912;...
%             41.106118 29.029121;...
%             41.104893 29.025619];

% Polygon = [ 41.083824 28.992473;...
%     41.084730 28.991663;...
%     41.084504 28.992275;...
%     41.084819 28.993031;...
%     41.084435 28.993230];
    
%  Polygon = [ 41.099680 29.018771;...
%             41.100974 29.018900;...
%              41.100133 29.021067;...
%             41.099211 29.020809];    
        
  Polygon = [ 41.099680 29.018771;... % Initial Point
            41.099211 29.020809]; % Ending Point


   % Convert Polygon max - min values  to NED 
   polymin = min(Polygon);
   polymax = max(Polygon);
  Origin.alt = 0;
  Origin.lat = polymin(1,1);
  Origin.lon = polymin(1,2);
  Target.alt = 0;
  Target.lat = polymax(1,1);
  Target.lon = polymax(1,2);
  NED = geo2ned(Target, Origin);
  
  %Convert all Coordinates to NED
  sz = size(Polygon);
  realsize = sz(1,1);
  
  for i=1:1:realsize
      Origin.alt = 0;
      Origin.lat = polymin(1,1);
      Origin.lon = polymin(1,2);
      myTarget(i).alt = 0;
      myTarget(i).lat = Polygon(i,1);
      myTarget(i).lon = Polygon(i,2);
      myNED(i) = geo2ned(myTarget(i), Origin);
%       IntersectionPoints(i).values = [0,0]; 
%       Origin.alt = 0;
%       Origin.lat = polymin(1,1);
%       Origin.lon = polymin(1,2);
%       the_Targets(i) = ned2geo(myNED(i), Origin);
  end
  
myNED(2).East = -200;
myNED(2).North = 100;
  figure;
  %Draw The Field
for i=1:1:realsize
    if i == realsize 
    xline(i).values=[myNED(i).East      myNED(1).East];
    yline(i).values=[myNED(i).North    myNED(1).North];
%     xline(i).values=[Polygon(i,2)     Polygon(1,2)];
%     yline(i).values=[Polygon(i,1)    Polygon(1,1)]; 
    else
    xline(i).values=[myNED(i).East      myNED(i+1).East];
    yline(i).values=[myNED(i).North    myNED(i+1).North];
%     xline(i).values=[Polygon(i,2)     Polygon(i+1,2)];
%     yline(i).values=[Polygon(i,1)    Polygon(i+1,1)]; 
    end
    plot(xline(i).values, yline(i).values, 'r');
    hold on;
end

% xmin = 1;
% xmax = 10;
% x = xmin + (xmax-xmin).*rand(1,1);
% 
% ymin = 1;
% ymax = 10;
% y = ymin + (ymax-ymin).*rand(1,1);
x_old = myNED(1).East;
y_old = myNED(1).North;

x_new = myNED(1).East + 20;
y_new = myNED(1).North + 20;


iterStep = 5;

for i=1:1:200
    Vektor1x=x_new-x_old;
    Vektor1y=y_new-y_old;
    if i==1
        Vektor2x=myNED(2).East-x_new;
        Vektor2y=myNED(2).North-y_new;
    else
        Vektor2x=myNED(2).East-x_new;
        Vektor2y=myNED(2).North-y_new;
    end
    Vektor1_uzunluk=sqrt(Vektor1x^2+Vektor1y^2);
    Vektor2_uzunluk=sqrt(Vektor2x^2+Vektor2y^2);

    Skaler_carpim=	(Vektor1x*Vektor2x) + (Vektor1y*Vektor2y);

    % Now the necessary angle for vehicle to turn is found, so that the rover
    % should turn
    % Please note that acika is a traditioanl Turkish food that tastes very
    % good
    acika=acos(Skaler_carpim/(Vektor1_uzunluk*Vektor2_uzunluk))/pi*180;
    
    egim=(y_new - y_old )/(x_new - x_old );
    
    x_old = x_new;
    
    y_old = y_new;
    
%     if acika >= 0 && acika <= 90
%         x_new = x_old + iterStep*cos((acika)*pi/180);
%         y_new = y_old + iterStep*sin((acika)*pi/180);
%     elseif acika > 90 && acika <= 180
%         x_new = x_old - iterStep*cos((acika)*pi/180);
%         y_new = y_old + iterStep*sin((acika)*pi/180);
%     elseif acika > 180 && acika <= 270
%         x_new = x_old + iterStep*cos((acika)*pi/180);
%         y_new = y_old - iterStep*sin((acika)*pi/180);
%     else 
%         x_new = x_old - iterStep*cos((acika)*pi/180);
%         y_new = y_old - iterStep*sin((acika)*pi/180);
%     end
    
    if egim > 0
        x_new = x_old + iterStep*cos((acika)*pi/180);
        y_new = y_old + iterStep*sin((acika)*pi/180);
    else
        x_new = x_old + iterStep*cos((180-acika)*pi/180);
        y_new = y_old + iterStep*sin((180-acika)*pi/180);        
    end
    plot(x_new,y_new,'ro');
    hold on;
%     
%     if ( 180 > y > 160) break, end;
end



% PicX = PicSize.X;
% PicY = PicSize.Y;
% 
% 
% maxY = abs(NED.North);
% maxX = abs(NED.East);
% 
% 
% %%Loop for X
% PhotoX(1) = PicX/2;
% Xneed = 0;
% k = 1;
% while (PhotoX(k) < maxX)
%     Xneed = Xneed + 1;
%     PhotoX(k+1) =  PhotoX(1) + PicX*k*(1-Overlap); 
%      k = k+ 1;
% end
% 
% %%Loop for Y
% PhotoY(1) = PicY/2;
% Yneed = 0;
% i = 1;
% while (PhotoY(i) < maxY)
%     Yneed = Yneed + 1;
%     PhotoY(i+1) =  PhotoY(1) + PicY*i*(1-Overlap); 
%      i = i+ 1;
% end
% 
% 
% 
% Photo = [PhotoX(1),PhotoY(1)];
% 
% 
% %Photo Matrix
% for j=1:1:Xneed
%     for w=1:1:Yneed
% 
%         Photo = [Photo ; PhotoX(j) , PhotoY(w)];
%         
%     end
% end

%Find Intersection Points between the field and the rectangles
% IntersectionPoints12= [0, 0];
% IntersectionPoints13= [0, 0];
% IntersectionPoints23= [0, 0];
% for c=1:1:Xneed+1
%     for d=1:1:Yneed+1
%         xlimit = [PhotoX(c)-PicX/2   PhotoX(c)+PicX/2];
%         ylimit = [PhotoY(d)-PicY/2   PhotoY(d)+PicY/2];
%         xbox = xlimit([1 1 2 2 1]);
%         ybox = ylimit([1 2 2 1 1]);
%         rectangle('Position',[PhotoX(c)-PicX/2      PhotoY(d)-PicY/2     PicX    PicY]);
%         mapshow(xbox,ybox,'DisplayType','polygon','LineStyle','none')
%         x12 = [NED1.North NED2.North];
%         y12 = [NED1.East NED2.East];
%         x13 = [NED1.North NED3.North];
%         y13 = [NED1.East NED3.East];
%         x23 = [NED2.North NED3.North];
%         y23 = [NED2.East NED3.East];
%         mapshow(x12,y12,'Marker','+')
%         mapshow(x13,y13,'Marker','+')
%         mapshow(x23,y23,'Marker','+')
%         [xi,yi] = polyxpoly(x12, y12, xbox, ybox, 'unique');
%         IntersectionPoints12 = [IntersectionPoints12; xi,yi];
%         mapshow(xi,yi,'DisplayType','point','Marker','o');
%         [xi,yi] = polyxpoly(x13, y13, xbox, ybox, 'unique');
%         IntersectionPoints13 = [IntersectionPoints13; xi,yi];
%         mapshow(xi,yi,'DisplayType','point','Marker','o');
%         [xi,yi] = polyxpoly(x23, y23, xbox, ybox, 'unique');
%         IntersectionPoints23 = [IntersectionPoints23; xi,yi];
%         mapshow(xi,yi,'DisplayType','point','Marker','o');
%     end
% end




%Visualize

% figure;
% 
% %Draw the Field
% for i=1:1:realsize
%     if i == realsize 
%     xline(i).values=[myNED(i).East      myNED(1).East];
%     yline(i).values=[myNED(i).North    myNED(1).North]; 
%     else
%     xline(i).values=[myNED(i).East      myNED(i+1).East];
%     yline(i).values=[myNED(i).North    myNED(i+1).North];
%     end
%     mapshow(xline(i).values, yline(i).values, 'Marker', '+');
% end


% for a=1:1:Xneed+1
%     for b=1:1:Yneed+1
%    % rectangle('Position',[PhotoX(a)-PicX/2      PhotoY(b)-PicY/2     PicX    PicY]);
%    % hold on;
%    % scatter(PhotoX(a), PhotoY(b)); %The Middle Points of Photo Rectangles
%         state = 1;
%         xlimit = [PhotoX(a)-PicX/2   PhotoX(a)+PicX/2];
%         ylimit = [PhotoY(b)-PicY/2   PhotoY(b)+PicY/2];
%         xbox = xlimit([1 1 2 2 1]);
%         ybox = ylimit([1 2 2 1 1]);
%        % rectangle('Position',[PhotoX(c)-PicX/2      PhotoY(d)-PicY/2     PicX    PicY]);
%        % mapshow(xbox,ybox,'DisplayType','polygon','LineStyle','none')
%         y12 = [NED1.North NED2.North];
%         x12 = [NED1.East NED2.East];
%         y13 = [NED1.North NED3.North];
%         x13 = [NED1.East NED3.East];
%         y23 = [NED2.North NED3.North];
%         x23 = [NED2.East NED3.East];
% %         mapshow(x12,y12,'Marker','+')
% %         mapshow(x13,y13,'Marker','+')
% %         mapshow(x23,y23,'Marker','+')
% 
% 
%         [xi,yi] = polyxpoly(x12, y12, xbox, ybox, 'unique');
%         IntersectionPoints12 = [IntersectionPoints12; xi,yi];
%         if ([xi,yi] ~= 0 & state )
%             rectangle('Position',[PhotoX(a)-PicX/2      PhotoY(b)-PicY/2     PicX    PicY]);
%             hold on;
%             state=0;
%         end
%         mapshow(xi,yi,'DisplayType','point','Marker','o');
%         [xi,yi] = polyxpoly(x13, y13, xbox, ybox, 'unique');
%         IntersectionPoints13 = [IntersectionPoints13; xi,yi];
%         if ([xi,yi] ~= 0 & state)
%             rectangle('Position',[PhotoX(a)-PicX/2      PhotoY(b)-PicY/2     PicX    PicY]);
%             hold on;
%             state = 0;
%         end
%         mapshow(xi,yi,'DisplayType','point','Marker','o');
%         [xi,yi] = polyxpoly(x23, y23, xbox, ybox, 'unique');
%         IntersectionPoints23 = [IntersectionPoints23; xi,yi];
%         if ([xi,yi] ~= 0 & state)
%             rectangle('Position',[PhotoX(a)-PicX/2      PhotoY(b)-PicY/2     PicX    PicY]);
%             hold on;
%             state = 0;
%         end
%         mapshow(xi,yi,'DisplayType','point','Marker','o');
%         %Middle Points of Rectanglesthat are inside the triangle
%         xv = [NED1.East;  NED2.East;  NED3.East];
%         yv = [NED1.North; NED2.North ;NED3.North];
%         xq = PhotoX(a);
%         yq = PhotoY(b);
%         [in,on] = inpolygon(xq,yq,xv,yv);
%         if (in ~= 0)
%             rectangle('Position',[PhotoX(a)-PicX/2      PhotoY(b)-PicY/2     PicX    PicY]);
%             hold on;
% %             plot(xq(in&~on),yq(in&~on),'r+') % points strictly inside
% %             hold on;
%         end
% %         plot(xv,yv);
% %         hold on;
% %         plot(xq(in&~on),yq(in&~on),'r+') % points strictly inside
% %         hold on;
% 
%     end
% end
% % plot([NED1.North NED2.North],[NED1.East NED2.East],'r');
% % hold on;
% % plot([NED3.North NED2.North],[NED3.East NED2.East],'r');
% % hold on;
% % plot([NED1.North NED3.North],[NED1.East NED3.East],'r');
% % hold on;
% % axis([0 450 0 450]);
% % axis equal



% fileID = fopen('coord_data.txt','r');
% formatSpec = '%f %f';
% sizeA = [2 Inf];
% A = fscanf(fileID,formatSpec,sizeA);
% fclose(fileID);
% 
% A = A';
% %Draw the Field
% for j=1:1:size(A)
%   mapshow(A(j,1),A(j,2),'DisplayType','point','Marker','x');
%  NED.North  = A(j,1); 
%  NED.East = A(j,2);
%  NED.Down = 0;
%  Origin.alt = 0;
%  Origin.lat = polymin(1,1);
%  Origin.lon = polymin(1,2);
% Target = ned2geo(NED, Origin)
% end
% 
% for k=1:1:size(A)-1
%     x = [A(k,1) A(k+1,1)];
%     y = [A(k,2) A(k+1,2)];
%      plot(x,y,'r');
%      hold on
% end
%      title('IHATAR Waypoints and Path Following');
%      xlabel('X Coordinates in NED');
%     ylabel('Y Coordinates in NED');

  %  legend('X coordinates','Y','Z','asc')
  


%Calculate and Mark The Waypoints
% for a=1:1:Xneed+1
%     for b=1:1:Yneed+1
%    % rectangle('Position',[PhotoX(a)-PicX/2      PhotoY(b)-PicY/2     PicX    PicY]);
%    % hold on;
%    % scatter(PhotoX(a), PhotoY(b)); %The Middle Points of Photo Rectangles
%         state = 1;
%         xlimit = [PhotoX(a)-PicX/2   PhotoX(a)+PicX/2];
%         ylimit = [PhotoY(b)-PicY/2   PhotoY(b)+PicY/2];
%         xbox = xlimit([1 1 2 2 1]);
%         ybox = ylimit([1 2 2 1 1]);
%        % rectangle('Position',[PhotoX(c)-PicX/2      PhotoY(d)-PicY/2     PicX    PicY]);
%        % mapshow(xbox,ybox,'DisplayType','polygon','LineStyle','none')
%         %         mapshow(x12,y12,'Marker','+')
%         %         mapshow(x13,y13,'Marker','+')
%         %         mapshow(x23,y23,'Marker','+')
%         for i=1:1:realsize
%         [xi,yi] = polyxpoly(xline(i).values, yline(i).values, xbox, ybox, 'unique');
%         IntersectionPoints(i).values = [IntersectionPoints(i).values; xi,yi];
%             if ([xi,yi] ~= 0 & state )
%             rectangle('Position',[PhotoX(a)-PicX/2      PhotoY(b)-PicY/2     PicX    PicY]);
%             hold on;
%            % TheMiddlePointsIntersect = [PhotoX(a) PhotoY(b)];
%              mapshow(PhotoX(a),PhotoY(b),'DisplayType','point','Marker','x','MarkerEdgeColor','black');
%              hold on
% %             fprintf('%f ,',PhotoX(a));
% %             fprintf('%f \n',PhotoY(b));
%             state=0;
%             end
%           %  mapshow(xi,yi,'DisplayType','point','Marker','o');
%            % Middle Points  of Rectangles that are inside the field
%             xv(i).values = [myNED.East];
%             yv(i).values = [myNED.North];
%             xq = PhotoX(a);
%             yq = PhotoY(b);
%             [in,on] = inpolygon(xq,yq,xv(i).values,yv(i).values);
%             if (in ~= 0)
%              rectangle('Position',[PhotoX(a)-PicX/2      PhotoY(b)-PicY/2     PicX    PicY]);
%              hold on;
%  %         PolygonInsiders =[PhotoX(a) PhotoY(b)];
%              mapshow(PhotoX(a),PhotoY(b),'DisplayType','point','Marker','x','MarkerEdgeColor','black');
%              hold on
% %             fprintf('%f ,',PhotoX(a));
% %             fprintf('%f \n',PhotoY(b));
%             end
%         end
%     end
% end
        %Middle Points of Rectangles that are inside the triangle
        
        
%         xv = [NED1.East;  NED2.East;  NED3.East];
%         yv = [NED1.North; NED2.North ;NED3.North];
%         xq = PhotoX(a);
%         yq = PhotoY(b);
%         [in,on] = inpolygon(xq,yq,xv,yv);
%         if (in ~= 0)
%             rectangle('Position',[PhotoX(a)-PicX/2      PhotoY(b)-PicY/2     PicX    PicY]);
%             hold on;
% %             plot(xq(in&~on),yq(in&~on),'r+') % points strictly inside
% %             hold on;
%         end


%         plot(xv,yv);
%         hold on;
%         plot(xq(in&~on),yq(in&~on),'r+') % points strictly inside
%         hold on;

%     end
% end
% plot([NED1.North NED2.North],[NED1.East NED2.East],'r');
% hold on;
% plot([NED3.North NED2.North],[NED3.East NED2.East],'r');
% hold on;
% plot([NED1.North NED3.North],[NED1.East NED3.East],'r');
% hold on;
% axis([0 450 0 450]);
% axis equal