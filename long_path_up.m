function u = long_path_up(VCG_parent,s)
    u = 1;
    if(isempty(VCG_parent{s}))
        return
    end
    max_len = 0;
    for i=1:length(VCG_parent{s})
        max_len = max(max_len,long_path_up(VCG_parent,VCG_parent{s}(i)));
    end
    u = u + max_len;
end