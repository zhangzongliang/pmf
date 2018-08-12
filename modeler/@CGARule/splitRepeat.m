function outSymbols=splitRepeat(v,axis,prefixes,sizes,symbols,repetitousIndex,boxSymbol)
assert(numel(prefixes)==numel(sizes));
% for i=1:numel(symbols)
%     symbols{i}.mScope=v.mScope;
% end
% boxSymbol.mScope=v.mScope;

length=v.mScope.mS(axis);
absoluteSizes=zeros(size(sizes));
theRest=length;

for i=1:numel(sizes)
    if repetitousIndex==i
        continue;
    elseif strcmp(prefixes{i},'absolute')
        restBackup=theRest;
        theRest=theRest-sizes(i);
        if theRest>0
            absoluteSizes(i)=sizes(i);
        else
            absoluteSizes(i)=restBackup;
            theRest=0;
        end
    elseif strcmp(prefixes{i},'relative')
        restBackup=theRest;
        absoluteSize=length*sizes(i);
        theRest=theRest-absoluteSize;
        if theRest>0
            absoluteSizes(i)=absoluteSize;
        else
            absoluteSizes(i)=restBackup;
            theRest=0;
        end
    else
        assert(false);
    end
end

if strcmp(prefixes{repetitousIndex},'absolute')
    absoluteSizes(repetitousIndex)=sizes(repetitousIndex);
elseif strcmp(prefixes{repetitousIndex},'relative')
    absoluteSizes(repetitousIndex)=length*sizes(repetitousIndex);
else
    assert(false);
end
translate=0;
outSymbols={};
for i=1:numel(sizes)
    if repetitousIndex==i
        for j=1:floor(theRest/absoluteSizes(repetitousIndex))
            repeateSymbol=symbols{i};
            repeateSymbol.mScope.mT(axis)=repeateSymbol.mScope.mT(axis)+translate;
            repeateSymbol.mScope.mS(axis)=absoluteSizes(i);
            repeateSymbol=repeateSymbol.computeTopDividingLevel();
            outSymbols{end+1}=repeateSymbol;
            translate=translate+absoluteSizes(i);
        end
        if mod(theRest,absoluteSizes(i))>0
            boxSize=mod(theRest,absoluteSizes(i));
            boxSymbol.mScope.mT(axis)=boxSymbol.mScope.mT(axis)+translate;
            boxSymbol.mScope.mS(axis)=boxSize;
            boxSymbol=boxSymbol.computeTopDividingLevel();
            outSymbols{end+1}=boxSymbol;
            translate=translate+boxSize;
        end
    else
        symbols{i}.mScope.mT(axis)=symbols{i}.mScope.mT(axis)+translate;
        symbols{i}.mScope.mS(axis)=absoluteSizes(i);
        symbols{i}=symbols{i}.computeTopDividingLevel();
        outSymbols{end+1}=symbols{i};
        translate=translate+absoluteSizes(i);
    end
end

end