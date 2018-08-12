function outSymbols=splitNoRepeat(v,axis,prefixes,sizes,symbols)
assert(numel(prefixes)==numel(sizes));
% for i=1:numel(symbols)
%     symbols{i}.mScope=v.mScope;
% end
length=v.mScope.mS(axis);
absoluteSizes=zeros(size(sizes));
theRest=length;
floatingSum=0;

for i=1:numel(sizes)
    if strcmp(prefixes{i},'absolute')
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
        floatingSum=floatingSum+sizes(i);
    end
end

for i=1:numel(sizes)
    if strcmp(prefixes{i},'floating')
        assert(floatingSum>0);
        absoluteSizes(i)=theRest*sizes(i)/floatingSum;
    end
end

translate=0;
outSymbols={};
for i=1:numel(sizes)
    outSymbols{i}=symbols{i};
    %scope=v.mScope;
    scope=symbols{i}.mScope;
    scope.mT(axis)=scope.mT(axis)+translate;
    if translate+absoluteSizes(i)>v.mScope.mS(axis)
        scope.mS(axis)=v.mScope.mS(axis)-translate;        
        outSymbols{i}.mScope=scope;
        outSymbols{i}=outSymbols{i}.computeTopDividingLevel();
        break;
    else
        scope.mS(axis)=absoluteSizes(i);
        outSymbols{i}.mScope=scope;
        outSymbols{i}=outSymbols{i}.computeTopDividingLevel();
    end
    translate=translate+absoluteSizes(i);
end


end


% function scopes=splitNoRepeat(v,axis,prefixes,sizes)
% assert(numel(prefixes)==numel(sizes));
% 
% length=v.mScope.mS(axis);
% absoluteSizes=zeros(size(sizes));
% theRest=length;
% floatingSum=0;
% 
% for i=1:numel(sizes)
%     if strcmp(prefixes{i},'absolute')
%         restBackup=theRest;
%         theRest=theRest-sizes(i);
%         if theRest>0
%             absoluteSizes(i)=sizes(i);
%         else
%             absoluteSizes(i)=restBackup;
%             theRest=0;
%         end
%     elseif strcmp(prefixes{i},'relative')
%         restBackup=theRest;
%         absoluteSize=length*sizes(i);
%         theRest=theRest-absoluteSize;
%         if theRest>0
%             absoluteSizes(i)=absoluteSize;
%         else
%             absoluteSizes(i)=restBackup;
%             theRest=0;
%         end
%     else
%         floatingSum=floatingSum+sizes(i);
%     end
% end
% 
% for i=1:numel(sizes)
%     if strcmp(prefixes{i},'floating')
%         assert(floatingSum>0);
%         absoluteSizes(i)=theRest*sizes(i)/floatingSum;
%     end
% end
% 
% translate=0;
% %scopes=cell(size(sizes));
% scopes={};
% for i=1:numel(sizes)
%     %scopes{i}=v.mScope;
%     scopes{i}=v.mScope;
%     scopes{i}.mT(axis)=scopes{i}.mT(axis)+translate;
%     if translate+absoluteSizes(i)>v.mScope.mS(axis)
%         scopes{i}.mS(axis)=v.mScope.mS(axis)-translate;
%         break;
%     else
%         scopes{i}.mS(axis)=absoluteSizes(i);
%     end
%     translate=translate+absoluteSizes(i);
% end
% 
% 
% end