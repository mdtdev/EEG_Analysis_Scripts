function spectraPlotCols(x, mat)
    [M, N] = size(data);
    
    for k=1:N
        h(k) = plot(t,data(:,k)+k,'color', [0.5 0.5 0.5]);
        if(k == 1)
            hold on;
        end
    end
    axis tight;
    
end