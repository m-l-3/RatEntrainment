function [DataArr] = makeArray(DataIn, iState)

if(nargin<=1)
    iState=1;
end
nRat = length(DataIn);
nSession = 4;
size_element = size(DataIn{nRat,1}{end,1});
DataArr = NaN(cat(2, size_element, nRat, nSession));
dim = length(size_element);

if(nRat~=length(DataIn))
    error('nRat is not true')
end

for iRat=1:nRat
    DataRat = DataIn{iRat,1};
    if(isempty(DataRat))
        continue
    end

    nSession = size(DataRat,2);
    for iSession=1:nSession
        DataSess = DataRat{iState,iSession};
        switch dim
            case 1
                DataArr(:,iRat,iSession) = DataSess;
            case 2
                DataArr(1:size(DataSess,1),1:size(DataSess,2),iRat,iSession) = DataSess;
            case 3
                DataArr(1:size(DataSess,1),1:size(DataSess,2),1:size(DataSess,3),iRat,iSession) = DataSess;
            case 4
                DataArr(:,:,:,:,iRat,iSession) = DataSess;
            case 5
                DataArr(:,:,:,:,:,iRat,iSession) = DataSess;
            case 6
                DataArr(:,:,:,:,:,:,iRat,iSession) = DataSess;
            otherwise
                error('not supported dimension')
        end
        
    end
end
