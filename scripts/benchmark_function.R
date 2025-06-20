benchmarking_deconvolution = function(deconvolution, groundtruth, include_combinations = NULL, corr_type = "spearman", scatter = T, pval = 0.05, file_name, width, height){
  require(reshape2)
  require(ggpubr)
  require(dplyr)
  require(purrr)
  require(tibble)
  
  groundtruth = groundtruth[rownames(deconvolution), ]
  
  deconvolution_combinations = c()
  
  if(is.null(include_combinations)!=T){
    deconvolution_combinations = c(deconvolution_combinations, include_combinations)
  }
  
  
  ###Correlation function
  correlation <- function(data, corr, pval) {
    require(tidyr)
    M <- Hmisc::rcorr(as.matrix(data), type = corr)
    Mdf <- purrr::map(M[c("r", "P", "n")], ~data.frame(.x))
    corr_df <- Mdf %>% purrr::map(~tibble::rownames_to_column(.x, 
                                                              var = "measure1")) %>% purrr::map(~tidyr::pivot_longer(.x, 
                                                                                                                     -measure1, names_to = "measure2")) %>% dplyr::bind_rows(.id = "id") %>% 
      tidyr::pivot_wider(names_from = id, values_from = value) %>% 
      dplyr::mutate(r = as.numeric(r), P = as.numeric(P), 
                    sig_p = ifelse(P < pval, TRUE, FALSE), p_if_sig = ifelse(sig_p, 
                                                                             P, NA), r_if_sig = ifelse(sig_p, r, NA))
    return(corr_df)
    
  }
  
  #####Scatter plot function
  scatter_plots = function(deconv, ground, method){
    for (i in 1:ncol(deconv)) {
      data = cbind(deconv[,i], ground)
      colnames(data) = c("x", "y")
      p <- ggplot(data, aes(x = x, y = y)) +
        geom_point(color = "blue", size = 3, alpha = 0.7) +  # Customize the points
        geom_smooth(method = "lm", se = T, color = "red") +  # Add regression line
        theme_minimal() +  # Apply a minimal theme
        labs(
          #title = paste0("Linear correlation - ", colnames(ground)),  # Set the title
          x = colnames(deconv)[i],                 # Set the x-axis label
          y = colnames(ground)                # Set the y-axis label
        ) +
        theme(
          plot.title = element_text(size = 20, hjust = 0.5),  # Adjust title font size and position
          axis.title = element_text(size = 15)                # Adjust axis label font size
        ) +
        stat_cor(method = method,label.x = summary(data[,1])[[5]]-0.02, label.y = summary(data[,2])[[5]]+0.005)  # Add correlation coefficient
      
      print(p)
    }
  }
  
  cell_clusters = colnames(groundtruth)
  
  ###Correlation matrix
  corr_matrix = data.frame(matrix(ncol = length(deconvolution_combinations), nrow = length(cell_clusters)))
  rownames(corr_matrix) = cell_clusters
  colnames(corr_matrix) = deconvolution_combinations
  cells_discard = c()
  ###Correlation computation
  for (i in 1:length(cell_clusters)) {
    idx = grep(cell_clusters[i], colnames(deconvolution))
    if(length(idx)==0){
      cells_discard = c(cells_discard, cell_clusters[i])
    }
    
    deconv = deconvolution[,idx, drop = F] 
    
    ground = groundtruth[,cell_clusters[i],drop=F]
    
    ###Scatter plots
    if(scatter == T){
      if(ncol(deconv)!=0){
        pdf(paste0("Scatter_plots_", colnames(ground), "_", file_name))
        scatter_plots(deconv, ground, corr_type)
        dev.off()
      }
    }
    
    x = correlation(cbind(deconv, ground), corr_type, pval)
    x = x[which(x$measure1==colnames(ground)),] #only taking corr against ground truth
    
    for (j in 1:ncol(corr_matrix)) {
      idx = grep(colnames(corr_matrix)[j], x$measure2)
      if(length(idx) == 0){
        corr_matrix[i,j] = NA
      }else{
        if(length(idx)>1){
          idx = which.max(x$r[idx])
        }
        corr_matrix[i,j] = x$r[idx]
      }
    }
  }
  
  
  ###Benchmarking plot
  if(length(cells_discard)>0){
    corr_matrix = corr_matrix[-which(rownames(corr_matrix)%in%cells_discard),]
  }else{
    corr_matrix = corr_matrix
  }
  corr_matrix[nrow(corr_matrix)+1,] = colMeans(corr_matrix, na.rm = T)
  rownames(corr_matrix)[nrow(corr_matrix)] = "average"
  
  ##Order methods
  corr_matrix = t(corr_matrix) %>%
    data.frame() %>%
    arrange(average) %>%
    t() %>%
    data.frame()
  
  corr_df <- melt(corr_matrix)
  corr_df = corr_df %>%
    mutate(Cells = rep(rownames(corr_matrix), ncol(corr_matrix)))
  
  g <- corr_df %>%
    ggplot(aes(Cells, variable, fill=value, label=round(value,2))) +
    geom_tile() +
    labs(x = NULL, y = NULL, fill = paste0(corr_type, "'s\nCorrelation"), title=file_name) +
    scale_fill_gradient2(mid="#FBFEF9",low="#0C6291",high="#A63446", limits=c(-1,1)) +
    geom_text() +
    theme_classic() +
    scale_x_discrete(expand=c(0,0)) +
    scale_y_discrete(expand=c(0,0)) +
    ggpubr::rotate_x_text(angle = 45) + theme(axis.text.x=ggtext::element_markdown()) + theme(axis.text.y=ggtext::element_markdown())
  
  pdf(paste0("Benchmark_plot_", file_name), width = width, height = height)
  print(g)
  dev.off()
  
  return(corr_matrix)
  
}
