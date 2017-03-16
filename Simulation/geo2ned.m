function NED = geo2ned(Target, Origin)

kFirstEccentricitySquared = 6.69437999014 * 0.001;
kSecondEccentricitySquared = 6.73949674228 * 0.001;
a = 6378137;

Target.lat = Target.lat*(pi/180);
Target.lon = Target.lon*(pi/180);
Target.alt = Target.alt*(pi/180);
Origin.lat = Origin.lat*(pi/180);
Origin.lon = Origin.lon*(pi/180);
Origin.alt = Origin.alt*(pi/180);

%Geodetic2ECEF
N_lat = a/(sqrt(1 - kFirstEccentricitySquared * sin(Origin.lat) * sin(Origin.lat)));
Xo = (N_lat + Origin.alt)*cos(Origin.lat)*cos(Origin.lon);
Yo = (N_lat + Origin.alt)*cos(Origin.lat)*sin(Origin.lon);
Zo = (N_lat*(1-kFirstEccentricitySquared) + Origin.alt)*sin(Origin.lat);

N_lat = a/(sqrt(1 - kFirstEccentricitySquared * sin(Target.lat) * sin(Target.lat)));
Xd = (N_lat + Target.alt)*cos(Target.lat)*cos(Target.lon);
Yd = (N_lat + Target.alt)*cos(Target.lat)*sin(Target.lon);
Zd = (N_lat*(1-kFirstEccentricitySquared) + Target.alt)*sin(Target.lat);

%ECEF2ENU
ecef2enu = [ -sin(Origin.lon)                   cos(Origin.lon)                     0;...
             -sin(Origin.lat)*cos(Origin.lon)   -sin(Origin.lat)*sin(Origin.lon)    cos(Origin.lat);...
             cos(Origin.lat)*cos(Origin.lon)    cos(Origin.lat)*sin(Origin.lon)     sin(Origin.lat)];
        
A = ecef2enu*[Xd-Xo; Yd-Yo; Zd-Zo];

NED.North =  A(1,1);
NED.East  =  A(2,1);
NED.Down  = -A(3,1);

NED.Down = Target.alt - Origin.alt;

end