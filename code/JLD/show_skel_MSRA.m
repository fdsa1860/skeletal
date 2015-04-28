function show_skel_MSRA(data)

% data is (num_joints x 3) x T 

J=[20     1     2     1     8    10     2     9    11     3     4     7     7     5     6    14    15    16    17;
    3     3     3     8    10    12     9    11    13     4     7     5     6    14    15    16    17    18    19];

x = data(1:3:end,:);
y = data(2:3:end,:);
z = data(3:3:end,:);

T = size(data,2);

clf;


% h = figure(1);
% set(h,'Position',[300 300 200 400]);
for t=1:T
    plot3(x(:,t),y(:,t),z(:,t),'o');
    
    set(gca,'DataAspectRatio',[1 1 1]);
%     axis([0 400 0 400 0 400]);
    axis([-1 1 -1 1 -1 1]);
    set(gca,'Position',[-0.3 0 1.5 1.2]);
    for j=1:19
        c1=J(1,j);
        c2=J(2,j);
        line([x(c1,t) x(c2,t)], [y(c1,t) y(c2,t)], [z(c1,t) z(c2,t)]);
    end

%     axis tight;
    axis off;
%     title([num2str(t) '/' num2str(T)]);
    drawnow;
    pause(0.1);
    35;
end