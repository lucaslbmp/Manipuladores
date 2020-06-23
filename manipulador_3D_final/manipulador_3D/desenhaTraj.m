function desenhaTraj(a,alpha,d,theta,q1,q2,q3,tipoRot)
lim=8.4;
npassos=30;
itraj=1;

for j = 1 : length(q1)-1
    
    q1i = linspace(q1(j), q1(j+1), npassos);
    q2i = linspace(q2(j), q2(j+1), npassos);
    q3i = linspace(q3(j), q3(j+1), npassos);

    for i = 1 : npassos
        %Robo Stanford
        %{
        thetaVar = [q1i(i) q2i(i) 0 q4i(i) q5i(i) q6i(i)] * pi/180;
        dVar = [0 0 q3i(i) 0 0 0];
        %}
        theta = [theta(1).*(~tipoRot(1))+q1i(i).*tipoRot(1) theta(2).*(~tipoRot(2))+q2i(i).*tipoRot(2) theta(3).*(~tipoRot(3))+q3i(i).*tipoRot(3)];
        d = [d(1).*tipoRot(1)+q1i(i).*(~tipoRot(1)) d(2).*tipoRot(2)+q2i(i).*(~tipoRot(2)) d(3).*tipoRot(3)+q3i(i).*(~tipoRot(3))];
%         d = dConst + dVar;
%         theta = thetaConst + thetaVar;
%       
      
        coord=cinematica(a,alpha,d,theta); 
        %fprintf('-----coord--------');
        %disp(coord);
        Robo_plot(coord,lim,length(a));
        traj(itraj,:)=coord(length(a)+1,:);
        %fprintf('------traj--------');
        %disp(traj);
        itraj = itraj + 1;
        
        if size(traj,1) > 1
            for k = 1 : size(traj,1)-1
               plot3([traj(k,1) traj(k+1,1)],[traj(k,2) traj(k+1,2)],[traj(k,3) traj(k+1,3)],'r-');
            end
        end
        
        pause(.05);
    end
 pause(.5);
end