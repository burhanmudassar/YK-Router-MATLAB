function track = cle(nets,HCG,VCG)

net_count = length(nets);
t = 0;
track = zeros(1,net_count);

unrouted_nets = nets;

while(~isempty(unrouted_nets))
    t = t+1;
    watermark = 0;
    
    unconstrained = [];
    for i=1:net_count                   %Scan for unconstrained nets from VCG
        if(isempty(VCG{nets(i)}))
            unconstrained = [unconstrained nets(i)];
        end
    end
    
    unconstrained = setdiff(unconstrained,setdiff(nets,unrouted_nets));     %do not count routed nets
    
    sj = min(HCG(unconstrained,1));                                         %minimum starting position
    routable = unconstrained(HCG(unconstrained)==sj);
    
    while(~isempty(routable))
        track(routable(1)) = t;
        watermark = HCG(routable(1),2);                                     %assign end position to watermark
        
        unconstrained = unconstrained(unconstrained~=routable(1));          %remove from unconstrained net list
                                                                            % remove from VCG
        for i=1:net_count
            VCG{nets(i)} = VCG{nets(i)}(VCG{nets(i)}~=routable(1));
        end
        
        unrouted_nets = unrouted_nets(unrouted_nets~=routable(1));
        
        routable = find(HCG(unconstrained,1)>watermark);
        routable = unconstrained(routable);                                 %add net whose sj is greater than watermark to routable list
    end
    
    
end
