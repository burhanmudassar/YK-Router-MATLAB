function [TOP,BOT,key,dogleg_pos] = dogleg(TOP,BOT)

% TOP = [1 2];
% BOT = [2 1];

%TOP = [1 3 4 5 2  1 3 6 4 7 2 9 10 8 6 2 9 10 11 12 13 15 14 13 12];
%BOT = [9 6 4 1 11 2 7 5 9 5 8 13 14 11 6 10 13 12 11 15 6 9 8 2 10];

%Building Nonzero matrices
top_nonzero1 = [];
bot_nonzero1 = [];
for i=1:length(TOP)
    if ~(TOP(i)==0 || BOT(i)==0)
        top_nonzero1 = [top_nonzero1 TOP(i)];
        bot_nonzero1 = [bot_nonzero1 BOT(i)];
    end
end

nets = setdiff(unique([unique(TOP) unique(BOT)]),0);
net_count = max(nets);
dogleg_pos = [];
%Initializing Key
key = cell(net_count,1);

%Building Adjacancy Matix 
Adjacancy=zeros(net_count);
for i=1:length(top_nonzero1)
    Adjacancy(top_nonzero1(i),bot_nonzero1(i))=1;
end

%Tarjan Algorithm
B=scomponents(Adjacancy);

%detecting cyles
sz = net_count;
cycles=zeros(sz,1);
for i=1:length(B)
    cycles(B(i))=cycles(B(i))+1;
end

%Removing Cycles
j=net_count+1;
for k=1:length(TOP)
  if (TOP(k)~=0)
    if(cycles(B(TOP(k)))>1)
      %Building Key
      key{TOP(k)} = [key{TOP(k)} j];
      
      %Decompose multi=terminal into different nets
      %if(pin_matrix(TOP(k)) > 2)
      dogleg_pos = [dogleg_pos k+1];  
      
      %Removing Cycles
      old = TOP(k);
      TOP = [TOP(1:k-1),j , j, TOP(k+1:end)];
      BOT = [BOT(1:k), old , BOT(k+1:end)];
      
      
      %Building Nonzero matrices
      top_nonzero1 = [];
      bot_nonzero1 = [];
      for i=1:length(TOP)
            if ~(TOP(i)==0 || BOT(i)==0)
                top_nonzero1 = [top_nonzero1 TOP(i)];
                bot_nonzero1 = [bot_nonzero1 BOT(i)];
            end
      end
      
      %Building Adjacancy Matix
      Adjacancy=zeros(j);
      for i=1:length(top_nonzero1)
        Adjacancy(top_nonzero1(i),bot_nonzero1(i))=1;
      end
      
      %Tarjan Algorithm
      B=scomponents(Adjacancy);
      j=j+1;
      nets = setdiff(unique([unique(top_nonzero1) unique(bot_nonzero1)]),0);
     
      %detecting cyles
      sz=size(nets);
      cycles=zeros(sz);
      for i=1:length(B)
        cycles(B(i))=cycles(B(i))+1;
      end
    end

  end
end

    top_nonzero1;
    bot_nonzero1;
    B;
    Adjacancy;
    key;
end
