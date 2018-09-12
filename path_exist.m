function same_path = path_exist(VCG,s,t)
    if(isempty(VCG{s}))
        same_path = false;
        return
    end
    
    for i=1:length(VCG{s})
        if(VCG{s}(i) == t)
            same_path = true;
            return
        else
            same_path = path_exist(VCG,VCG{s}(i),t);
            if(same_path)
                return
            end
        end
    end
end