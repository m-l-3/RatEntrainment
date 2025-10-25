function [All_Data] = aggeregate_perRatSess(Datasets, cfg)

    All_Data = cell(size(Datasets, 1),1);

    for i=1:size(Datasets, 1)

        fprintf('Step %d / %d \n', i, size(Datasets, 1))

        Dataset = Datasets{i};
        All_Data{i,1} = struct2cell(aggeregate_data2(Dataset, cfg));

    end