


% Copyright: Xiaoping Qian @ UW-Madison
close all; clear;

% profile 1
P = [ 0 0 0  1;
      5 0 0  1;
      5 0 5  1;
      0 0 5  1;]  % curve in x-z plane
knots = [0 0 0 0 1 1 1 1];
order = 4;


% profile 2
% P = [40 0 20 1;
%      20 0 20 1;
%      20 0 20 1;
%      20 0 10 1;
%      10 0 8 1;
%      0 0 1 1
%      ];
 P = [13.5 0 -45 1;
     13.5 0 -46 1;
     13.5 0 -47 1;
     13.5 0 -47.5 1;
     14.5 0 -48.5 1;
     14.5 0 -49.5 1;];
knots = [0 0 0 0 0.333 0.666 1 1 1 1];
 
%do plot of control polygon
Q = bsplineCurve(P, order, knots, 50);
plot3(P(:,1),P(:,2), P(:,3),'r-s');
hold on;
plot3(Q(:,1),Q(:,2), Q(:,3),'b','linewidth',2);
axis equal;
%print('-dpdf','-painters','revolution0.pdf')

P0 = P;  % curve CPs
P1 = P0(:,1:4)+P(:,1)*[0 1 0 0]; P1(:,4) = P(:,4).*sqrt(2)/2; % offset CPs
P2 = P1(:,1:4)+P(:,1)*[-1 0 0 0];P2(:,4) = P(:,4);  % offset CPs
P3 = P2(:,1:4)+P(:,1)*[-1 0 0 0]; P3(:,4) = P(:,4)*sqrt(2)/2;
P4 = P3(:,1:4)+P(:,1)*[0  -1 0 0]; P4(:,4) = P(:,4); % offset CPs
P5 = P4(:,1:4)+P(:,1)*[ 0 -1 0 0]; P5(:,4) = P(:,4)*sqrt(2)/2;
P6 = P5(:,1:4)+P(:,1)*[1 0 0 0]; P6(:,4) = P(:,4); % offset CPs
P7 = P6(:,1:4)+P(:,1)*[1 0 0 0]; P7(:,4) = P(:,4)*sqrt(2)/2;
P8 = P7(:,1:4)+P(:,1)*[0  1 0 0]; P8(:,4) = P(:,4); % offset CPs

CPs = [P0; P1; P2; P3; P4; P5; P6; P7;P8];  % v first
knots_u = [0 0 0 1 1 2 2 3 3 4 4 4]/4.;
knots_v = knots;
k1 = 3;
k2 = order;
ncp_u = 9;
ncp_v = size(P,1);

cph=[CPs(:,1:3).*CPs(:,4), CPs(:,4)]; % turn into homogneous coorinates
tCP = reshape(cph',[4,ncp_v,ncp_u]);
CPs_d3 = permute(tCP,[1,3,2]); % change it to u first by switching 3rd dimension w/ 2nd dimension

nrbs.type   = 'Surface';
nrbs.number = [ncp_u, ncp_v];
nrbs.coefs = CPs_d3;  % CPs in homogeneous coordinates
nrbs.knots = {knots_u knots_v};
nrbs.order = [k1 k2];
    
plotNrbs(nrbs); 
%print('-dpdf','-painters','revolution1.pdf')

nrbs_Spink.form='B-NURBS';
nrbs_Spink.dim = 4
nrbs_Spink.number = [ncp_u, ncp_v];
tCP = reshape(CPs',[4,ncp_v,ncp_u]);
CPs_d3 = permute(tCP,[1,3,2]); % change it to u first by switching 3rd dimension w/ 2nd dimension
nrbs_Spink.coefs = CPs_d3;  % CPs in Euclidean coordinates
nrbs_Spink.knots = {knots_u knots_v};
nrbs_Spink.order = [k1 k2];
NrbsSrf2IGES(nrbs_Spink,'revolution1.igs','./')