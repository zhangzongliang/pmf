function scopes=comp(v,faces)
scopes=cell(size(faces));
for i=1:numel(faces)
    scopes{i}=v.mScope;
    switch faces{i}
        case 'left'
            assert(false);
        case 'front'
            scopes{i}.mS(2)=0;
        case 'back'
            scopes{i}.mR(3)=v.mScope.mR(3)+180;
            scopes{i}.mS(2)=0;
            scopes{i}.mT(1)=-v.mScope.mT(1)-v.mScope.mS(1);
            scopes{i}.mT(2)=-v.mScope.mT(2)-v.mScope.mS(2);
        otherwise
            assert(false);
    end
end

end