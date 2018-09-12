function zone = construct_zone(HCG,net_count,length_channel)

current_zone = 1;
zone = {};
max_clique = [];
disappear = 0;

for i=1:length_channel
    current = [];   
    new_node = 0;
    
    for j=1:net_count
        if(HCG(j,1)<=i && HCG(j,2) >=i)
            current = [current j];
        end
    end

    if(~isempty(setdiff(max_clique,current)))
        disappear = 1;
    end
    
    if(~isempty(setdiff(current,max_clique)))
        new_node = 1;
    end
    
    if(disappear==1 && new_node==1)
       zone{current_zone} = max_clique;
       current_zone = current_zone+1;
       max_clique = current;
       disappear = 0;
       new_node = 0;       
    end
    
    max_clique = unique([max_clique current]); 
    
    if(i==length_channel)
        zone{current_zone} = max_clique;
    end
end