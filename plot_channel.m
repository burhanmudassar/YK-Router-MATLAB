function plot_channel(track,nets,HCG,TOP,BOT,toplabel,botlabel,dogleg_pos)

figure;
a = axes;
height_channel = max(track);
length_channel = length(TOP);
for i=1:length(nets)                        %plot horizontal tracks
    s = HCG(nets(i),1);
    e = HCG(nets(i),2);
    h = height_channel - track(nets(i)) + 1;
    plot([s e],[h h]);
    hold on;
end

for i=1:length(TOP)
if(isempty(find(dogleg_pos == i)))
    text(i, height_channel+0.5, num2str(toplabel(i)), 'VerticalAlignment','bottom', ...
                                 'HorizontalAlignment','center','FontSize',5);

    text(i, 0, num2str(botlabel(i)), 'VerticalAlignment','bottom', ...
                                 'HorizontalAlignment','center','FontSize',5)
end
if(TOP(i)~=0)
    h = height_channel - track(TOP(i)) + 1;
    if(isempty(find(dogleg_pos == i)))
        plot([i i],[height_channel+0.5 h],'r');             %do not plot line if it is dogleg column
    end
    plot(i,h,'.r');
end
if(BOT(i)~=0)
    h2 = height_channel - track(BOT(i)) + 1; 
    if(~isempty(find(dogleg_pos == i)))
        h1 = height_channel - track(TOP(i)) + 1;            %plot line between tracks if dogleg column    
    else
        h1 = 0.5;
    end
    
    %h = height_channel - track(BOT(i)) + 1;
    plot([i i],[h1 h2],'r');
    plot(i,h2,'.r');
end
end
hold off
axis([0 length_channel+1 0 height_channel+1]);
set (a,'xticklabel',[]);
set (a,'xtick',[]);
set (a,'ticklength',[0 1]);