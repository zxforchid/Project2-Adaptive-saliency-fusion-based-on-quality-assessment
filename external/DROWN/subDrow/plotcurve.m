%     b     blue          .     point              -     solid
%     g     green         o     circle             :     dotted
%     r     red           x     x-mark             -.    dashdot 
%     c     cyan          +     plus               --    dashed   
%     m     magenta       *     star             (none)  no line
%     y     yellow        s     square
%     k     black         d     diamond
%     w     white         v     triangle (down)
%                                ^     triangle (up)
%                                <     triangle (left)
%                                >     triangle (right)
%                                p     pentagram
%                                h     hexagram
%% PR
figure(1);
hold on;
grid on;
plot(r_ChengICCV,p_ChengICCV,'r-','LineWidth',2);
plot(r_S2_08G,p_S2_08G,'g-','LineWidth',2);
plot(r_initial,p_initial,'color',[0 0.75 0.75],'LineWidth',2);
plot(r_Fu,p_Fu,'k--','LineWidth',2); 
plot(r_spl_Liu,p_spl_Liu,'b--','LineWidth',2);
plot(r_icme_li,p_icme_li,'y--','LineWidth',2);
% plot(r_RC_11,p_RC_11,'g-.');
plot(r_ST,p_ST,'c-.','LineWidth',2);
plot(r_wCtr_O,p_wCtr_O,'m-.','LineWidth',2);
legend('Our Final','Our Initial','Our Exemplar','CB','HS','RFPR','ST','RBD');
%%.......fi3: numWords:3
xlabel('Recall');
ylabel('Precision');
set(gca,'box','on');
% title('MSRC');
% title('ICoseg');
% set(gca,'XTick',0:.2:1);

%% ROC
% % % figure(2);
% % % hold on;
% % % grid on;
% % % 
% % % plot(fpr_08GO1_alpha4,tpr_08GO1_alpha4,'r-','LineWidth',2);
% % % plot(fpr_S2_08G,tpr_S2_08G,'g-');
% % % plot(fpr_initial,tpr_initial,'color',[0 0.75 0.75],'LineWidth',2);
% % % plot(fpr_Fu,tpr_Fu,'k--','LineWidth',2);
% % % plot(fpr_spl_Liu,tpr_spl_Liu,'b--','LineWidth',2);
% % % plot(fpr_icme,tpr_icme,'y--','LineWidth',2);
% % % % plot(fpr_RC_11,tpr_RC_11,'g-.');
% % % plot(fpr_ST,tpr_ST,'c-.','LineWidth',2);
% % % plot(fpr_wCtr,tpr_wCtr,'m-.','LineWidth',2');
% % % legend('Our Final','Our Initial','Our Exemplar','CB','HS','RFPR','ST','RBD');
% % % xlabel('FPR');
% % % ylabel('TPR');
% % % set(gca,'box','on');
% % % % title('MSRC');
% % % % title('ICoseg');