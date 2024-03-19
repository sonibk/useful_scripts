## Plot waterfall (barplot)
for (x in names(both)){
  outputFile = paste0(params$CWD,"/results/",params$cell_line,'_',params$pvalue_cutoff,'P_',params$fdr_cutoff,'FDR_imp',imp,"/Waterfall_",params$pvalue_cutoff,"P_",params$fdr_cutoff,'FDR_', x,'.pdf')
  
  pdf(outputFile, width=5, height=8)
  
  water_fall <- ggplot(data=both[[x]], aes(x=reorder(Kinase,Enrichment.score), y=Enrichment.score)) +
    geom_bar(stat="identity", fill=both[[x]]$Color) +
    coord_flip() +
    ggtitle("Kinase enrichments") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 24)) +
    theme(axis.text.y = element_text(size = 14),axis.title=element_text(size=22)) +
    xlab("Kinase") +
    ylab("-log10 p-value")+
    geom_text(aes(label=both[[x]]$category), hjust = as.numeric(both[[x]]$hjust), color="white", position = position_dodge(1), size=3.5)

  
  plot(water_fall)
  
  dev.off()
}
