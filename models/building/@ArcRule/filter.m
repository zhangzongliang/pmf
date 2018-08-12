function points=filter(cloud,r,delta,centerX,centerZ,alpha,extru,zBottom)
assert(delta>0);
assert(alpha>=0&&alpha<=pi/2);
R=r+delta;
x0=centerX;
x1=centerX+r*sin(alpha);
x2=x1+delta;
center=[centerX,0,centerZ];

points=cloud;
count=0;

for i=1:size(cloud,1)
    d=norm(cloud(i,:)-center);    
    if cloud(i,1)>x0&&cloud(i,1)<x1
        
        if cloud(i,3)<zBottom
            count=count+1;
            points(count,:)=cloud(i,:);
        elseif cloud(i,3)>centerZ
            if d<R&&d>r
                count=count+1;
                points(count,:)=cloud(i,:);
                points(count,2)=points(count,2)+extru;
            elseif d>=R
                count=count+1;
                points(count,:)=cloud(i,:);                
            end
        end        
%         if cloud(i,3)>centerZ
%             if d<R&&d>r
%                 count=count+1;
%                 points(count,:)=cloud(i,:);
%                 points(count,2)=points(count,2)+extru;
%             elseif d>=R
%                 count=count+1;
%                 points(count,:)=cloud(i,:);                
%             end
%         elseif cloud(i,3)<zBottom
%             count=count+1;
%             points(count,:)=cloud(i,:);
%         end
    elseif cloud(i,1)>x1&&cloud(i,1)<x2
        if d<R||cloud(i,3)<centerZ
            count=count+1;
            points(count,:)=cloud(i,:);
            points(count,2)=points(count,2)+extru;
        else
            count=count+1;
            points(count,:)=cloud(i,:);
        end
    end    
    
end
points=points(1:count,:);
half=points;
x=points(:,1);
x=2*centerX-x;
half(:,1)=x;
points=[points;half];

end

% 
% function points=filter(cloud,r,delta,centerX,centerZ,alpha)
% assert(delta>0);
% assert(alpha>0&&alpha<pi/2);
% R=r+delta;
% x0=centerX;
% x1=centerX+r*sin(alpha);
% x2=x1+delta;
% center=[centerX,0,centerZ];
% 
% points=cloud;
% count=0;
% 
% for i=1:size(cloud,1)
%     d=norm(cloud(i,:)-center);
%     if cloud(i,1)>x0&&cloud(i,3)>centerZ
%         if cloud(i,1)>x1&&cloud(i,1)<x2&&cloud(i,3)<centerZ||...
%                 cloud(i,1)>x1&&cloud(i,1)<x2&&d<R||...
%                 cloud(i,1)>x0&&cloud(i,1)<x1&&cloud(i,3)>centerZ&&d<R&&d>r
%             count=count+1;
%             points(count,:)=cloud(i,:);
%         end
%         
%     elseif true
%         
%     end
% end
% points=points(1:count,:);
% 
% end