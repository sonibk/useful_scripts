### Try do this in Limma
#note: ###counts === counts
#metadata == metadata
library(limma)

#### Create the DGE object
dge_limma <- DGEList(counts = counts, samples = metadata, group = metadata$Leak_vs_No_Leak)
dge_limma <- calcNormFactors(dge_limma)



### remove low genes based on cpm
cutoff <- 10

drop <- which(apply(cpm(dge_limma),1, max) < cutoff)

d <- dge_limma[-drop,]

dim(d)


plotMDS(dge_limma)

#### create  the design
design <- model.matrix(~0 + Leak_vs_No_Leak, metadata)



##### transform the data 
#VOOM
voom.y.d <- voom(dge_limma, design, plot = T)


#### remove batch effects
PM_Case_Number <- metadata$PM_Case_Number

lim<-removeBatchEffect(voom.y.d,batch =PM_Case_Number,design=design)

##### fit the model
fit <- lmFit(lim, design)
coef.fit <- fit$coefficients
head(coef(fit))

### make contrasts
# An example on how to use make contrast 

contrast.matrix <- makeContrasts(
    leak_vs_no_leak = Leak_vs_No_LeakLeak - Leak_vs_No_LeakNo_Leak,
   
    levels = design
)


colnames(design) <- gsub("^Leak_vs_No_Leak", "", colnames(design))


### find dges
tmp <- contrasts.fit(fit, contrast.matrix)
tmp <- eBayes(tmp)
top.table <- topTable(tmp, sort.by = "P", n = Inf)
head(top.table, 5)

View(top.table)

de_genes_sig_cm2<- subset(top.table, adj.P.Val < 0.05)

up <- subset(de_genes_sig_cm2, logFC > 0)

down <- subset(de_genes_sig_cm2, logFC  < 0)

dim(up)
dim(down)
