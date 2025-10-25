
temp = {};
for i=1:10
    temp{i,1}=Before_Data{6,1}{i,3};
    temp{i,2}=Before_Data{6,1}{i,4};
end
Before_Data{6,1} = [];
Before_Data{6,1} = temp;

for i=1:4
    temp2{1,i} = Before_Datasets{6,1}{3,i};
    temp2{2,i} = Before_Datasets{6,1}{4,i};
end
Before_Datasets{6,1} = [];
Before_Datasets{6,1} = temp2;