function plotConfusionMatrix(mat)

% mat = rand(5);           %# A 5-by-5 matrix of random values from 0 to 1
m = size(mat, 1);
n = size(mat, 2);
imagesc(mat);            %# Create a colored plot of the matrix values
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

textStrings = num2str(mat(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:m,1:n);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
set(hStrings,{'FontSize'},num2cell(20*ones(length(hStrings),1)));

% MSR modified
% xtickLabel = {'horizontal arm wave','hammer','forward punch','high throw','hand clap','bend','tennis serve'};
% ytickLabel = {'horizontal arm wave','hammer','forward punch','high throw','hand clap','bend','tennis serve'};
% xtickLabel = {'high arm wave','hand catch','draw X','draw tick','draw circle','two hand wave','side boxing','forward kick'};
% ytickLabel = {'high arm wave','hand catch','draw X','draw tick','draw circle','two hand wave','side boxing','forward kick'};
% xtickLabel = {'high throw','forward kick','side kick','jogging','tennis swing','tennis serve','Golf swing'};
% ytickLabel = {'high throw','forward kick','side kick','jogging','tennis swing','tennis serve','Golf swing'};

% MSR original
% xtickLabel = {'horizontal arm wave','hammer','forward punch','high throw','hand clap','bend','tennis serve','pick up & throw'};
% ytickLabel = {'horizontal arm wave','hammer','forward punch','high throw','hand clap','bend','tennis serve','pick up & throw'};
% xtickLabel = {'high arm wave','hand catch','draw X','draw tick','draw circle','two hand wave','side boxing','forward kick'};
% ytickLabel = {'high arm wave','hand catch','draw X','draw tick','draw circle','two hand wave','side boxing','forward kick'};
% xtickLabel = {'high throw','forward kick','side kick','jogging','tennis swing','tennis serve','Golf swing','pick up & throw'};
% ytickLabel = {'high throw','forward kick','side kick','jogging','tennis swing','tennis serve','Golf swing','pick up & throw'};

% UTKinect
xtickLabel = {'walk','sit down','stand up','pick up','carry','throw','push','pull','wave hands','clap hands'};
ytickLabel = {'walk','sit down','stand up','pick up','carry','throw','push','pull','wave hands','clap hands'};

% set(gca,'XTick',1:m,...                         %# Change the axes tick marks
%         'XTickLabel',xtickLabel,...  %#   and tick labels
%         'YTick',1:n,...
%         'YTickLabel',ytickLabel,...  %#   and tick labels
%         'TickLength',[0 0]);
set(gca,'TickLength',[0 0]);
XYrotalabel(45,0,gca,1:m,xtickLabel,1:n,ytickLabel,'FontSize',15);
set(gcf, 'Position', [300, 300, 700, 600]);
% set(gca,'Position',[0.2 0.2 0.7 0.7]);
set(gca,'Position',[0.15 0.15 0.8 0.8]);
axis tight;

end