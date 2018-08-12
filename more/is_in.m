function in=is_in(p,model)
x=p(1);
z=p(3);
if x>=0&&x<=1&&z>=0&&z<=4||x>=3&&x<=4&&z>=0&&z<=2||...
        x>=1&&x<=3&&z>=0&&z<=1||x>=1&&x<=2&&z>=3&&z<=4
    in=true;
else
    in=false;
end

end