[mse,bestc,bestg] = SVMcgForRegress(train_label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,msestep)

train_label:ѵ������ǩ.Ҫ����libsvm��������Ҫ��һ��.
train:ѵ����.Ҫ����libsvm��������Ҫ��һ��.
cmin:�ͷ�����c�ı仯��Χ����Сֵ(ȡ��2Ϊ�׵Ķ�����),�� c_min = 2^(cmin).Ĭ��Ϊ -5
cmax:�ͷ�����c�ı仯��Χ�����ֵ(ȡ��2Ϊ�׵Ķ�����),�� c_max = 2^(cmax).Ĭ��Ϊ 5
gmin:����g�ı仯��Χ����Сֵ(ȡ��2Ϊ�׵Ķ�����),�� g_min = 2^(gmin).Ĭ��Ϊ -5
gmax:����g�ı仯��Χ����Сֵ(ȡ��2Ϊ�׵Ķ�����),�� g_min = 2^(gmax).Ĭ��Ϊ 5

v:cross validation�Ĳ���,�������Լ���Ϊ�����ֽ���cross validation.Ĭ��Ϊ 3
cstep:����c�����Ĵ�С.Ĭ��Ϊ 1
gstep:����g�����Ĵ�С.Ĭ��Ϊ 1
msestep:�����ʾ׼ȷ��ͼʱ�Ĳ�����С. Ĭ��Ϊ 20
