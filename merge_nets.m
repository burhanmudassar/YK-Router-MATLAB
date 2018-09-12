function [net_merge key VCG_merge_p VCG_merge_c HCG_merge] = merge_nets(nets,VCG_parent,VCG_child,HCG,zone)

Left = [];
Right = [];
K = 100;
net_count = max(nets);
key = cell(net_count,1);

VCG_merge_p = VCG_parent;
VCG_merge_c = VCG_child;
net_merge   = nets;
HCG_merge   = HCG;

P = [];
Q = [];

for i=1:length(zone)-1
    Left = [Left setdiff(zone{i},zone{i+1})];           %Nodes ending at zone{i}
    Right = setdiff(zone{i+1},zone{i});                 %Nodes starting at zone{i+1}
    
    P_temp = Left;
    Q_temp = Right;
    
    
    for j=1:length(Left)
        for k=1:length(Right)           %candidate from Q
            if(path_exist(VCG_merge_p,Left(j),Right(k)) || path_exist(VCG_merge_p,Right(k),Left(j)))
                P_temp = P_temp(P_temp~=Left(j));
                break;
            else   
            end
        end
    end
    
    if (length(P_temp)<length(Q_temp))
        [P_temp Q_temp] = deal(Q_temp,P_temp);              %swap if P < Q
    end
    
    P = P_temp;
    Q = Q_temp;
    
    if(isempty(P) || isempty(Q))
        continue;
    end
    
    while(~isempty(Q))
        mstar = [];
        f = 0;
        um = 0;
        dm = 0;
        for j=1:length(Q)
            u = long_path_up(VCG_merge_p,Q(j));
            d = long_path_down(VCG_merge_c,Q(j));
            ftemp = K * (u+d) + max (u,d);
            if(ftemp > f)
                f = ftemp;
                mstar = Q(j);
                um = u;
                dm = d;
            end
        end
        
        g = [];
        nstar = P(1);
        for j=1:length(P)
            un = long_path_up(VCG_merge_p,P(j));
            dn = long_path_down(VCG_merge_c,P(j));
            
            hnm = max(un,um) + max(dn,dm) - max(un+dn,um+dm);
            g_temp = K * hnm - (sqrt(un*um) + sqrt(dn*dm));
            if(isempty(g))
                g = g_temp;
            end
            
            if(g_temp<g)
                g = g_temp;
                nstar = P(j);
            end
        end
        % merge mstar and nstar
        key{nstar} = [key{nstar} mstar];                                        %add a replacement key
        VCG_merge_p{nstar} = unique([VCG_merge_p{nstar} VCG_merge_p{mstar}]);   %merge parents of mstar and nstar
        VCG_merge_c{nstar} = unique([VCG_merge_c{nstar} VCG_merge_c{mstar}]);   %merge children of mstar and nstar
        
        VCG_merge_p{mstar} = [];                                                %erase mstar
        VCG_merge_c{mstar} = [];                                                %erase mstar
        
        HCG_merge(nstar,1) = min(HCG_merge(nstar,1),HCG_merge(mstar,1));        %merge min coord
        HCG_merge(nstar,2) = max(HCG_merge(nstar,2),HCG_merge(mstar,2));        %merge max coord
        
        net_merge = net_merge(net_merge~=mstar);                                %erase mstar
        
        for j=1:length(VCG_merge_p)
            VCG_merge_p{j}(VCG_merge_p{j}==mstar) = nstar;                      %replace mstar with nstar
            VCG_merge_p{j} = unique(VCG_merge_p{j});
            VCG_merge_c{j}(VCG_merge_c{j}==mstar) = nstar;                      %replace mstar with nstar
            VCG_merge_c{j} = unique(VCG_merge_c{j});
        end
        
        Q = Q(Q~=mstar);                                                        %remove mstar from Q
        P = P(P~=nstar);                                                        %remove nstar from P
        
        Left = Left(Left~=mstar);
        Left = Left(Left~=nstar);
        
        for j=1:length(zone)
            zone{j}(zone{j}==mstar) = nstar;
        end
    end
        
end