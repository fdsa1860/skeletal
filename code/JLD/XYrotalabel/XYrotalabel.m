function [RotX,RotY,Axis,XTicks,XTickLabels,YTicks,YTickLabels] = XYrotalabel(RotX,RotY,Axis,XTicks,XTickLabels,YTicks,YTickLabels,varargin)
% Rotate X & Y Axis labels
% Default rotation is 45° - if one angle is specified it is used for X & Y
% Default axes are the current axes (the current figure or subplot axes)
% Default labels/ticks come from axes, must all be supplied if different
% Default parameters are those of the axes but can supply parameter pairs
% Default X/Y adjustment is 0 - need to supply RotX/Y=[A X Y] if negative
% If any Tick or Label Vector is empty it is supplied from the axes
% If Axis is set to 0 then gca is assumed (current axis in current fig)
%
% Parameters allow setting of Interpreter {tex}, latex, none or bold/italic
% Original labels are removed preventing reapplication without all args
% Parameters used can be returned enabling reapplication with all args
% Designed for axes centred on origin - automatically makes a common label
% XYrotalable allows labeling of left Y-axis and bottom X-axis plus images
% Images still default to botleft X-Y axes, but move the origin to the top
% Reversing of the axes such as used with images is detected and countered
%
% For axes not centred on the origin - it is up to you to avoid a conflict
% For unequal angles that might overlap at the origin - up to you to fix it
% For negative angles that might cross the axes - up to you to adjust this
% For changing the grid or tick marks - upto you, I just rotate the labels
% For labels that exceed the default and very generous margins - up to you
% For angles outside of [0,90] you will likely need to specify displacement
% For example shifts comparable to the angle: XYrotalabel([-45 -45 45],60)
%
% Fine tuning tweaking is possible by modifying the code as indicated below
% Options to tweak precise positions of the label axes in X/Y? are proposed
% Simple way to make more space is to set subplots in relative coordinates
% Use subplot('position',[left bottom width height]) using reals in [0,1]
% You can run XYrotalabel to get the labels, then modify them as you prefer
%
% I am aware of other attempts at this problem but none doing both axes,
% none that work in subplots, none that don't try to be clever and scale.
% This one tends to the opposite extreme - it is transparently simple.
% 
% "There are two ways of constructing a software design... 
%  One way is to make it so simple that there are obviously no deficiencies,
%  and the other is to make it so complicated that there are no obvious deficiencies."
%                                                           - C A R Hoare
% 
% Copyright 2014 David M W Powers - all rights reserved no responsibility taken
if nargin < 1
    RotX=45; RotY=45;
elseif nargin < 2
    RotY=RotX;
end
% pick up any [X Y] left/down delta movement RotX/Y for the X/Y labels
XYdX=[0 0]; XYdY=[0 0];
lenX = length(RotX);
lenY = length(RotY);
if lenX>1
    XYdX(1:lenX-1)=RotX(2:end);
    RotX=RotX(1);
end
if lenY>1
    XYdY(1:lenY-1)=RotY(2:end);
    RotY=RotY(1); 
end
if nargin < 3
    Axis = gca;
elseif nargin < 7
    error(sprintf('0, 1, 2, 3 or 7 arguments required, %d supplied\n',nargin));
    return
else
    if Axis==0, Axis = gca; end

    if isempty(XTicks),         XTicks=get(Axis,'XTick')'; end
    if isempty(XTickLabels),    XTickLabels=get(Axis,'XTickLabel'); 
                   % XTickLabels=[XTickLabels repmat(' ',size(XTicks))];
    end

    if isempty(YTicks),    YTicks=get(Axis,'YTick')'; end
    if isempty(YTickLabels),    YTickLabels=get(Axis,'YTickLabel');
                   % YTickLabels=[YTickLabels repmat(' ',size(YTicks))];
    end

    %check that we have label for each tick
    if length(XTicks) ~= length(XTickLabels),
        error('XYrotalabel: must have same number of XTicks and XTickLabels, %d:%d supplied\n',length(XTicks),length(XTickLabels));
    end
    if length(YTicks) ~= length(YTickLabels),
        error('XYrotalabel: must have same number of YTicks and YTickLabels, %d:%d supplied\n',length(YTicks),length(YTickLabels));
    end
end
if nargin < 7
    % Find & pad labels given they aren't supplied and we are making them
    % This is easier than trying to control exact position in random coords
    XTicks=get(Axis,'XTick')';
    XTickLabels=get(Axis,'XTickLabel');
    % XTickLabels=[XTickLabels repmat(' ',size(XTicks))];

    YTicks=get(Axis,'YTick')';
    YTickLabels=get(Axis,'YTickLabel');
    % YTickLabels=[YTickLabels repmat(' ',size(YTicks))];
end

% N.B. XDelt is supplied to allow fine adjustment - see dummy use in text()
% Eventually I got around to supplying options to tweak positions
% Method is to allow Rot = [A X Y] with Angle and [X Y] biases for labels
XDir=get(Axis,'XDir');
XLims=get(Axis,'XLim');
XDelt=(XLims(2)-XLims(1))/800;
YDir=get(Axis,'YDir');
YLims=get(Axis,'YLim');
YDelt=(YLims(2)-YLims(1))/800;

% Find labeling origin assuming bottom left labeling axes
% Note that I am determining the position one axis wrt the other axis
X=YLims(1+strcmp(YDir,'reverse'));
Y=XLims(1+strcmp(XDir,'reverse'));

% First scrap the labels stored in the axes
set(Axis,'YTickLabel',[],'XTickLabel',[]);

% Second do the X-axis
XTy=repmat(X,size(XTicks));
XText = text(XTicks-XYdX(1)*XDelt, XTy-XYdX(2)*YDelt, XTickLabels,varargin{:});
set(XText,'Rotation',RotX,'HorizontalAlignment','right','VerticalAlignment','top');

% Third do the Y-axis
YTx=repmat(Y,size(YTicks));
YText = text(YTx-XYdY(1)*XDelt, YTicks-XYdY(2)*YDelt, YTickLabels,varargin{:});
set(YText,'Rotation',RotY,'HorizontalAlignment','right','VerticalAlignment','bottom');