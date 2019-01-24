function [precision,recall ,f_measure ,f05 ,f07,f09,f1] = Evaluate(ACTUAL,PREDICTED)
% This fucntion evaluates the performance of a classification model by 
% calculating the common performance measures: Accuracy, Sensitivity, 
% Specificity, Precision, Recall, F-Measure, G-mean.
% Input: ACTUAL = Column matrix with actual class labels of the training
%                 examples
%        PREDICTED = Column matrix with predicted class labels by the
%                    classification model
% Output: EVAL = Row matrix with all the performance measures


idx = (ACTUAL()==1);

p = length(ACTUAL(idx));             
n = length(ACTUAL(~idx));
N = p+n;

tp = sum(ACTUAL(idx)==PREDICTED(idx));        %True Positive  检索到相关的
tn = sum(ACTUAL(~idx)==PREDICTED(~idx));      %True Negative未检索到的，不相关的
fp = n-tn;                                 % False Positive 检索到的，但是不相关的
fn = p-tp;                                 % False Negative 未检索到的，但却是相关的

 tp_rate = tp/(p+eps);
% tn_rate = tn/n;

% accuracy = (tp+tn)/N;
 sensitivity = tp_rate;
% specificity = tn_rate;
precision = tp/(tp+fp);
if isnan(precision)
    precision=0;
end
recall = sensitivity;

b=0.3; c=0.5;d = 0.7;e = 0.9; f=1;                              %b=beta^2

if (b*precision + recall)~=0
f_measure = ((1+b)*precision*recall)/(b*precision + recall);
f05= ((1+c)*precision*recall)/(c*precision + recall);
f07= ((1+d)*precision*recall)/(d*precision + recall);
f09= ((1+e)*precision*recall)/(e*precision + recall);
f1= ((1+f)*precision*recall)/(f*precision + recall);
else
f_measure=0;f05=0;f07=0;f09=0;f1=0;
end
%gmean = sqrt(tp_rate*tn_rate);
% EVAL=[precision recall f_measure f05 f1];
end
%EVAL = [accuracy sensitivity specificity precision recall f_measure gmean];