function [VCG_parent, VCG_child] = create_VCG(TOP,BOT,net_count)

top_nonzero = [];
bot_nonzero = [];

for i=1:length(TOP)
    if ((TOP(i)==0 || BOT(i)==0) || (TOP(i)==BOT(i)))                    %insert condition for same net in top and bottom of i
        
    else
        top_nonzero = [top_nonzero TOP(i)];
        bot_nonzero = [bot_nonzero BOT(i)];
    end
end

VCG_parent = cell(net_count,1);
VCG_child = cell(net_count,1);

for i=1:length(bot_nonzero)
    VCG_parent{bot_nonzero(i)} = [VCG_parent{bot_nonzero(i)} top_nonzero(i)];
    VCG_parent{bot_nonzero(i)} = unique(VCG_parent{bot_nonzero(i)});
    
    VCG_child{top_nonzero(i)} = [VCG_child{top_nonzero(i)} bot_nonzero(i)];
    VCG_child{top_nonzero(i)} = unique(VCG_child{top_nonzero(i)});
end