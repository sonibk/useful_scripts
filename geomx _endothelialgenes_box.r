###change this to the endothelial genes
Netosis <- c("PECAM1", "CDH5", "CD34", "CLDN5","ENG", "PROCR",
                       "TEK","OCLN", "VWF","ESAM","APOE4",
                       "TJP1","APP", "GJD3","GJB1","ELAM1","VCAM1","ICAM1"
                       )


####set the sample groups parameteres
samples = c("ID_4","ID_6","ID_10","ID_14","ID_20","ID_30","ID_52","ID_56","ID_58","ID_80","ID_98","ID_114","ID_118","ID_122","ID_2","ID_8","ID_16","ID_22","ID_26","ID_50","ID_60","ID_70","ID_72","ID_78","ID_82","ID_96","ID_100","ID_104","ID_110","ID_112")
sample_groups = c("NO_LEAK","LEAK")
sample_groups = factor(sample_groups, levels = sample_groups)
sample_groupings = c("NO_LEAK","NO_LEAK","NO_LEAK","NO_LEAK","NO_LEAK","NO_LEAK","NO_LEAK","NO_LEAK","NO_LEAK","NO_LEAK","NO_LEAK","NO_LEAK","NO_LEAK","NO_LEAK","LEAK","LEAK","LEAK","LEAK","LEAK","LEAK","LEAK","LEAK","LEAK","LEAK","LEAK","LEAK","LEAK","LEAK","LEAK","LEAK")
sample_groupings = factor(sample_groupings, levels = sample_groups)
samples_by_sample_group = list(c("ID_4","ID_6","ID_10","ID_14","ID_20","ID_30","ID_52","ID_56","ID_58","ID_80","ID_98","ID_114","ID_118","ID_122"),c("ID_2","ID_8","ID_16","ID_22","ID_26","ID_50","ID_60","ID_70","ID_72","ID_78","ID_82","ID_96","ID_100","ID_104","ID_110","ID_112"))
comparisons = c("LEAK vs NO_LEAK")


### load the expression matrix
de_annotated <-read.csv("C:/Users/bmk27e/OneDrive - University of Glasgow/Desktop/GEOMX/Analysis3/leak_CD31_pos/all_genes/de_workflows/LEAK_vs_NO_LEAK/data/de_annotated.csv",
                        sep = "\t")
row.names(de_annotated) <- de_annotated$ID


#### load the metadata
em <- read.csv("C:/Users/bmk27e/OneDrive - University of Glasgow/Desktop/GEOMX/Analysis3/leak_CD31_pos/ss.csv",
               sep="\t")
em <- as.data.frame(em)
row.names(em) <- em$sample


###wrangle the data
Netosis_subset  <- de_annotated[rownames(de_annotated) %in% Netosis, ]

Netosis_subset$ID <- row.names(Netosis_subset)

Netosis_subset2 <- em[row.names(em) %in% Netosis,]


Netosis_subset<- Netosis_subset[,c("ID",samples)]
####make into long fomart#
Netosis_long <- pivot_longer(Netosis_subset, 
                             cols = -ID, 
                             names_to = "Sample", 
                             values_to = "Expression")

Condition <- rep(sample_groupings, times= 16)

Netosis_long$group <- Condition


gene_expression_data <- Netosis_long


#### plot the box plot
## Assume 'gene_expression_data' is your data frame with columns 'group', 'Expression', and 'ID'
 p <- ggplot(gene_expression_data, aes(x = group, y = Expression, fill = group)) +
   geom_boxplot() +
   facet_wrap(~ID, scales = "free_y",ncol = 4) +  # Separate boxplots for each gene
   labs(x = "Group", y = "Gene Expression", title = "Endothelial genes across groups", face = "bold")+
   scale_fill_manual(values = c("LEAK" = "#CC6677", "NO_LEAK" = "#88CCEE"))+
   theme( strip.text = element_text(face = "bold", size = 12),
     panel.grid = element_blank(),
     panel.background = element_blank(),
     panel.border = element_rect(colour = "black", fill = NA, linewidth = 1),
     plot.background = element_blank(),
     plot.title = element_text(size = 20, margin = margin(b = 5), hjust = 0, vjust = 0.5, face = "bold"),
     title = element_text(size = 13, margin = margin(b = 5), hjust = 0, vjust = 0.5, face = "bold"),
     axis.text.y = element_text(size = 10, margin = margin(r = 5), hjust = 1, vjust = 0.5, face = "bold", colour = "black"),
     axis.text.x = element_text(size = 10, margin = margin(t = 5),angle = 45, hjust = 1, vjust = 1, face = "bold", colour = "black"),
     axis.title.y = element_text(size = 18, margin = margin(r = 10), angle = 90, hjust = 0.5, vjust = 0.5, face = "bold"),
     axis.title.x = element_text(size = 18, margin = margin(t = 10), hjust = 0.5, vjust = 1, face = "bold")
     
     
   )+ guides(color = guide_legend(override.aes = list(size = 4)))
 
 
 
 # Perform statistical tests (e.g., t-test) for each gene
 gene_tests <- gene_expression_data %>%
   group_by(ID) %>%
   summarize(
     p_value = t.test(Expression ~ group)$p.value,
     significance = case_when(
       p_value < 0.01 ~ "**",
       p_value < 0.05 ~ "*",
       p_value < 0.001 ~"***",
       TRUE ~ "ns"
     )
   )
 
 # Add significance stars to the plot
 p + geom_text(
   data = gene_tests,
   aes(label = significance),
   x = 1.5, y = Inf, vjust = 1.5, size = 4, inherit.aes = FALSE, face = "bold"
 )
 
