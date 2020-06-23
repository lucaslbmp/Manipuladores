function coordenadas=cinematica(a,alpha,d,theta) 
view(3);
TH0 = [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
coord(1,:) = [0 0 0];
for j = 1 : length(a)
    TH(:,:,j) = DH(a(j), alpha(j), d(j), theta(j));
    %disp(TH(:,:,j));
end

for j = 1 : length(a)
    TH0 = TH0*TH(:,:,j);
    coord(j+1,:) = TH0(1:3,4)';
end
coordenadas=coord;