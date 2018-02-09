
box(axes1,'on');
axis(axes1,'tight');
axis(axes1,'ij');
% Set the remaining axes properties
set(axes1,'CLim',[105119.442650397 796213.182203248],'DataAspectRatio',...
    [1 1 1],'Layer','top','XTickLabel','','YTickLabel','');
% Create colorbar
colorbar('peer',axes1,'FontWeight','bold','FontSize',10);

% Create textbox
annotation(figure1,'textbox',...
    [0.481840193704601 0.108958837772397 0.105116222760291 0.0242130750605328],...
    'LineWidth',3,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.520581113801454 0.319612590799032 0.0653753026634379 0.273607748184021],...
    'LineWidth',3,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.391041162227603 0.317191283292978 0.0653753026634378 0.273607748184021],...
    'LineWidth',3,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.462469733656174 0.317191283292978 0.0520581113801453 0.423728813559322],...
    'LineWidth',3,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create line
annotation(figure1,'line',[0.426150121065376 0.558111380145279],...
    [0.213075060532688 0.263922518159806],'Color',[1 1 1],'LineWidth',3);

% Create line
annotation(figure1,'line',[0.420096852300242 0.552058111380145],...
    [0.254237288135593 0.305084745762712],'Color',[1 1 1],'LineWidth',3);

% Create line
annotation(figure1,'line',[0.427360774818402 0.421307506053269],...
    [0.215496368038741 0.256658595641647],'Color',[1 1 1],'LineWidth',3);

% Create line
annotation(figure1,'line',[0.556900726392253 0.550847457627119],...
    [0.263922518159807 0.305084745762712],'Color',[1 1 1],'LineWidth',3);
