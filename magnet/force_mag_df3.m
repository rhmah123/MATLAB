function dF = force_mag_df3(msize1,distance,J)
%function dF = force_mag_df(misze,distance,J)
%%Compute the magnetic field to a point 
%x,y,z,the dimensions of the cube is a1,b1,c1 
%They are set up such that a - x , b - y, c - z
%The magnet is polarized in the z direction so care must be
%taken at arbitrary polarization directions with magnitude J
%%msize = [2*a1;2*b1;2*c1];

%%unwrap states
Jprime = norm(J);
a1 = msize1(1)/2;
b1 = msize1(2)/2;
c1 = msize1(3)/2;
x = distance(1);
y = distance(2);
z = distance(3);

dF = [0;0;0];

%%Compute U,V,W
Si = zeros(2,1);
Tj = Si;
Wk = Si;
for ii = 0:1
    Si(ii+1) = x - a1*(-1)^ii;
    Tj(ii+1) = y - b1*(-1)^ii;
    Uk(ii+1) = z - c1*(-1)^ii;
end

dFx = 0;dFy = 0;dFz = 0;
for ii = 0:1
  for jj = 0:1
    for kk = 0:1
      S = Si(ii+1);
      T = Tj(jj+1);
      U = Uk(kk+1);
      R = sqrt(S^2 + T^2 + U^2);
      one = (-1)^(ii+jj+kk);
      dFx = dFx + one*phix(S,T,U,R,J);
      dFy = dFy + one*phiy(S,T,U,R,J);
      dFz = dFz + one*phiz(S,T,U,R,J);
    end
  end
end
dFx;
dFy;
dFz;
mu0 = 4*pi*(10^-7); %%permeability of free space in T*m/A

dF = [dFx;dFy;dFz].*Jprime/(4*pi*mu0);

%%Check for edge
if abs(dF(1)) == Inf
  dF(1) = 0;
end
if abs(dF(2)) == Inf
  dF(2) = 0;
end
if abs(dF(3)) == Inf
  dF(3) = 0;
end

function out = phix(S,T,U,R,J)
Mx = J(1);My = J(2);Mz=J(3);

out = Mz*T*U/(R*(S^2+U^2)) - Mx*S*(T-R)/(R*(S^2+U^2)) - My/R;

function out = phiy(S,T,U,R,J)
Mx = J(1);My = J(2);Mz=J(3);

out = Mz*S*U/(R*(S^2+U^2)) - Mx/R + My*(S-R)*T/(R*(T^2+U^2));

function out = phiz(S,T,U,R,J)
Mx = J(1);My = J(2);Mz=J(3);

out = -Mz*S*T*(R^2+U^2)/(R*(S^2+U^2)*(T^2+U^2)) + Mx*(T-R)*U/(R*(S^2+U^2)) ...
      + My*(S-R)*U/(R*(T^2+U^2));



% Copyright - Carlos Montalvo 2015
% You may freely distribute this file but please keep my name in here
% as the original owner
