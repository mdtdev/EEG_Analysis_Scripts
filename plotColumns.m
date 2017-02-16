function [varargout]=plotColumns(data,varargin)
%
% [h,varargout]=plotColumns(data,varargin)
% plots columns of a matrix as if each column is a time series
%
% USAGE:
%       plotColumns(data);
% [h] = plotColumns(t,data);
% [h] = plotColumns(t,data,{colors});
% [h] = plotColumns(t,data,'plotopt');
% [h] = plotColumns(...,'plotopt');
% [h] = plotColumns(...,{colors});
%
% INPUT:
% data:     a matrix of data vectors stored column-wise.
% t:        an optional vector the same length as the columns of data.  The data
%           are plotted against t, so that is on the x axis.
% {colors}: A cell option that to make the individual traces a certain
%           set of colors.  Any number of colors can be input.  Markers can
%           be input as well.
% plotopt:  A character option for making the plot suitable for
%           printing/displaying.  'print' makes the fontsize of xlabels and
%           ylabels 16, the title 18, font bold, and the backgroud white.
%
% OUTPUT:
% h:        A vector of plot handles controlling each individual trace's
%           plotting properties.
%
%% EXAMPLE
% %Use of all options.  Simply remove any option other than 'W' (which acts
% %data input) to get different plots.
% t             = [linspace(1/200,2000/200,2000)]';
% x             = sin(6*pi*t);
% g             = zeros(size(t));
% g(1:400)   = [gausswin(400)]';
% colors        = {'r','k','b','m--'};
% W             = repmat(x.*g,1,20);
% W(:,1)        = g;
% for k = 2:20
%   
%   W(:,k) = circshift(W(:,k),k*100);
% 
% end;
% 
% plotopt = 'print';
% 
% h = plotColumns(t,W,colors,plotopt);
% 
% set(h(1),'linewidth',2);
%
% figure; h = plotColumns(W,colors,plotopt); %plot samples
% figure; h = plotColumns(W); %no fancy plot options or colors.
% figure; h = plotColumns(t,W,colors);
% figure; h = plotColumns(t,W,plotopt); set(h(5),'color','c','linewidth',2);
%--------------------------------------------------------------------------

colors  =   {'b'};
plotopt = 'none';

for k = 1:length(varargin)

    if(isnumeric(varargin{k}))
        
        %if a time vector is input too
        temp = varargin{k};
        t    = data;
        data = temp;

    end;

    if(iscell(varargin{k}))

        colors = varargin{k};

    end;

    if(ischar(varargin{k}))

        plotopt = varargin{k};

    end;

end;

[M,N]   =   size(data);

if(~logical(exist('t','var')))
    t = [1:M]';
end;

L = length(colors);
h = zeros(N,1);

for k=1:N
    h(k) = plot(t,data(:,k)+k,char(colors(mod(k,L)+1)));
    if(k==1), hold on; end;
end;

axis tight;

if(strcmp(plotopt,'print'))
    set(gca,'fontsize',16,'fontweight','b');
    set(gcf,'color','w');
end;

if(nargout > 0)
    varargout{1} = h;
end;