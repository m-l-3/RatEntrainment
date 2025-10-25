function [DataArr] = makeArray(DataIn, cfg)

nRat = cfg.nRat;
nSession = cfg.nSession;
nBlock = cfg.nBlock;
size_element = size(DataIn{nRat,1}{1,nSession}{1,nBlock});
DataArr = NaN(cat(2, size_element, nRat, nSession ,nBlock));
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
        DataSess = DataRat{1,iSession};
        nBlock = size(DataSess,2);

        for iBlock=1:nBlock

            DataBlock = DataSess{1,iBlock};
            switch dim
                case 1
                    DataArr(:,iRat,iSession,iBlock) = DataBlock;
                case 2
                    DataArr(:,:,iRat,iSession,iBlock) = DataBlock;
                case 3
                    DataArr(1:size(DataBlock,1),:,:,iRat,iSession,iBlock) = DataBlock;
                case 4
                    DataArr(:,:,:,:,iRat,iSession,iBlock) = DataBlock;
                case 5
                    DataArr(:,:,:,:,:,iRat,iSession,iBlock) = DataBlock;
                case 6
                    DataArr(:,:,:,:,:,:,iRat,iSession,iBlock) = DataBlock;
                otherwise
                    error('not supported dimension')
            end
        end
    end
end
