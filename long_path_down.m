function d = long_path_down(VCG_child,s)
    d = 1;
    if(isempty(VCG_child{s}))
        return
    end
    max_len = 0;
    for i=1:length(VCG_child{s})
        max_len = max(max_len,long_path_down(VCG_child,VCG_child{s}(i)));
    end
    d = d + max_len;
end