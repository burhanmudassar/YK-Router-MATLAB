fileID = fopen('dr4.txt');              %open file for reading

C = textscan(fileID,'%d');
len = length(C{1})/2;
TOP = transpose(C{1}(1:len));
BOT = transpose(C{1}(len+1:len*2));
%TOP = [1 2];
%BOT = [2 1];

%TOP = [1 1 4 2 3 4 3 6 5 8 5 9];
%BOT = [2 3 2 0 5 6 4 7 6 9 8 7];

length_channel = length(TOP);

nets = setdiff(unique([unique(TOP) unique(BOT)]),0);            %extract unique nets
net_count = max(nets);                                          

top_nonzero1 = [];
bot_nonzero1 = [];
for i=1:length(TOP)
    if ~(TOP(i)==0)
        top_nonzero1 = [top_nonzero1 TOP(i)];
    end
    if ~(BOT(i)==0)
        bot_nonzero1 = [bot_nonzero1 BOT(i)];
    end
end

%% Doglegs
[top_dogleg, bot_dogleg,dogleg_key,u_dogleg_pos] = dogleg(TOP,BOT);
length_channel_dogleg = length(top_dogleg);
nets_dogleg = setdiff(unique([unique(top_dogleg) unique(bot_dogleg)]),0);
net_count_dogleg = max(nets_dogleg);

%% Building the HCG
HCG_dogleg = create_HCG(top_dogleg,bot_dogleg,net_count_dogleg,length_channel_dogleg);
%% Zone construction
zone = construct_zone(HCG_dogleg,net_count_dogleg,length_channel_dogleg);
%% VCG construction
[VCG_parent,VCG_child] = create_VCG(top_dogleg,bot_dogleg,net_count_dogleg);
%% Net Merging
[net_merge key VCG_merge_p VCG_merge_c HCG_merge] = merge_nets(nets_dogleg,VCG_parent,VCG_child,HCG_dogleg,zone);
%% CLE
track_merge = cle(net_merge,HCG_merge,VCG_merge_p);         %CLE over merged nets
track = cle(nets_dogleg,HCG_dogleg,VCG_parent);             %CLE over nets
%% Plot routing channel
top_d_c_label = top_dogleg;
bot_d_c_label = bot_dogleg;
for i=1:length(dogleg_key)                                                      %replace split nets with original net label
    for j=1:length(dogleg_key{i})
        top_d_c_label(find(top_d_c_label==dogleg_key{i}(j))) = i;
        bot_d_c_label(find(bot_d_c_label==dogleg_key{i}(j))) = i;
    end
end

H = max(max(track_merge),max(track));                                         

plot_channel(track,nets_dogleg,HCG_dogleg,top_dogleg,bot_dogleg,top_d_c_label,bot_d_c_label,u_dogleg_pos);
title('CLE');
axis([0 length(top_dogleg)+1 0 H+1]);

track_m = zeros(net_count_dogleg,1);                                            %fill track information from merging
for i=1:length(track_merge)
    track_m(i) = track_merge(i);    
end

for i=1:length(track_merge)
    track_m(key{i}) = track_merge(i);
end



%for i=1:length(track_m)
%    track_m(key{i}) = track_m(i);
%end
a = intersect(nets_dogleg,find(track_m==0));
while(~isempty(a))

    for i=1:length(a)
        for j=1:length(key)
            if(find(key{j}==a(i)))
                track_m(a(i)) = track_m(j);
            end
        end
    end
    a = intersect(nets_dogleg,find(track_m==0));

end

plot_channel(track_m,nets_dogleg,HCG_dogleg,top_dogleg,bot_dogleg,top_d_c_label,bot_d_c_label,u_dogleg_pos);
title('YK');
axis([0 length(top_dogleg)+1 0 H+1]);

via_count = length(top_nonzero1)+length(bot_nonzero1)+2*length(u_dogleg_pos);

max_clique = length(zone{1});
for i=1:length(zone)
    if(length(zone{i})>max_clique)
        max_clique = length(zone{i});
    end
end

length(nets)
max_clique
max(track)
max(track_m)
via_count

