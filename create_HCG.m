function HCG = create_HCG(TOP,BOT,net_count,length_channel);

HCG = [];
% Building the HCG
for i=1:net_count
    start_coord_A = length_channel+1;
    end_coord_A = 0; 
    start_coord_B = length_channel+1;
    end_coord_B = 0;
    
    for j=1:length(TOP)               %start coordinate of i from A
        if(TOP(j)==i)
            start_coord_A = j;
            break;
        end
    end
    
    for j=1:length(TOP)               %end coordinate of i from A
        if(TOP(j)==i)
            end_coord_A = j;
        end
    end
    
    for j=1:length(BOT)               %start coordinate of i from B
        if(BOT(j)==i)
            start_coord_B = j;
            break;
        end
    end
    
    for j=1:length(BOT)               %end coordinate of i from B
        if(BOT(j)==i)
            end_coord_B = j;
        end
    end
    
    start_coord = min(start_coord_A,start_coord_B);
    end_coord = max(end_coord_A,end_coord_B);
    I = [start_coord end_coord];
    HCG = [HCG; I];
end