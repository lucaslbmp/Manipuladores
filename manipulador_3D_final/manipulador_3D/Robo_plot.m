function Robo_plot(coord,lim,num_joints)
hold on;
cla;
Cylinder([0 0 0], [0 0 -0.75],1.4,20,[0.7,0.7,0.7],1,0);

for i = 1 : num_joints
    x_next = coord(i+1,1);
    y_next = coord(i+1,2);
    z_next = coord(i+1,3);
    x_now = coord(i,1);
    y_now = coord(i,2);
    z_now = coord(i,3);
    Cylinder([x_now,y_now,z_now],[x_next,y_next,z_next],0.25,20,[0.3,0.3,0.3],1,0);
    bubbleplot3(coord(i,1), coord(i,2),coord(i,3),0.5,[0.5,0.5,0.5],1,100,100);
end

grid on; box on; axis equal; axis([-lim lim -lim lim -lim lim]);
