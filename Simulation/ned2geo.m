function Target  = ned2geo(NED,Origin)
%UNT�TLED Summary of this function goes here
%   Detailed explanation goes here

kFirstEccentricitySquared = 6.69437999014 * 0.001;
kSecondEccentricitySquared = 6.73949674228 * 0.001;
a = 6378137;

Origin.lat = Origin.lat*(pi/180);
Origin.lon = Origin.lon*(pi/180);
Origin.alt = Origin.alt*(pi/180);

N_lat = a/(sqrt(1 - kFirstEccentricitySquared * sin(Origin.lat) * sin(Origin.lat)));
Xo = (N_lat + Origin.alt)*cos(Origin.lat)*cos(Origin.lon);
Yo = (N_lat + Origin.alt)*cos(Origin.lat)*sin(Origin.lon);
Zo = (N_lat*(1-kFirstEccentricitySquared) + Origin.alt)*sin(Origin.lat);

ecef2enu = [ -sin(Origin.lon)                   cos(Origin.lon)                     0;...
             -sin(Origin.lat)*cos(Origin.lon)   -sin(Origin.lat)*sin(Origin.lon)    cos(Origin.lat);...
             cos(Origin.lat)*cos(Origin.lon)    cos(Origin.lat)*sin(Origin.lon)     sin(Origin.lat)];
 
 %disp(ecef2enu)
 inverse_ecef = inv(ecef2enu);
%  disp(inverse_ecef)
 
 ned_matrix = [NED.North; NED.East; NED.Down];
 target_matrix = inverse_ecef*ned_matrix;
%target_matrix = ecef2enu/ned_matrix;

 
 Xd = Xo + target_matrix(1,1);
 Yd = Yo + target_matrix(2,1);
 Zd = Zo + target_matrix(3,1);

 Target.alt = 0;
 
 %Target.lon = atan(Yd/Xd);
 
 Zd_sq = Zd*Zd;
 a_sq = a*a;
 kfs_sq = (1 - kFirstEccentricitySquared)*(1 - kFirstEccentricitySquared);
 
 c= Zd_sq/(kfs_sq*a_sq);
 
 x = c/(1+ kFirstEccentricitySquared*c);
 
 Target.lat = asin(sqrt(x));
 
%  tN_lat = a/(sqrt(1 - kFirstEccentricitySquared * sin(Target.lat) * sin(Target.lat)));
%  
% Target.lon =  asin(Yd/(tN_lat*cos(Target.lat)));

 Target.lon = atan(Yd/Xd);

Target.lat = Target.lat*(180/pi);
Target.lon = Target.lon*(180/pi);
Target.alt = Target.alt*(180/pi);
 
end

