function addSignificanceStar(x1, x2, y, h, p, plotLine)
if p<0.001
    textStr = '***';
elseif p<0.01 
    textStr = '**';
elseif p<0.05
    textStr = '*';
else
    textStr = 'n.s.';
end

if (h)
    if(plotLine)
        line([x1 x2], [y y], 'Color', 'k', 'LineWidth', 1);  % horizontal bar
    end
    text(mean([x1 x2]), y + 0.01 * y, textStr, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', 8, 'FontWeight', 'bold');
end

end