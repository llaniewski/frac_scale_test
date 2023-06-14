setwd("~/repo/frac_scale_test/analysis/")
L = 96*432*432

tot = NULL
for (comp in c("athena","topaz")) {
  fn = paste0(comp,"/data/tab.csv")
  if (file.exists(fn)) {
    tab=read.csv(fn)
    for (vers in c("master","fastdem")) {
      tab$comp = comp
      tab$vers = vers
      fn = paste0(comp,"/",vers,"/output/",tab$case_name,"_Log_P00_00000000.csv")
      
      sel = file.exists(fn)
      ret = lapply(fn[sel],function(x) { read.csv(x) })
      sapply(ret, function(x) diff(x$Iterations)/diff(x$Walltime))
      
      ret[[1]]$Walltime
      ret = lapply(ret, function(x) diff(x$Iteration)/diff(x$Walltime))
      tab$ips[sel] = sapply(ret, mean)
      tab$ips_sd[sel] = sapply(ret, sd)
      tot = rbind(tot,tab)
    }
  }
}


tot$mlups = tot$ips*L/1e6
pdf("perf.pdf")
plot(tot$k,tot$mlups, ylim=range(0,tot$mlups,na.rm = TRUE),col=factor(tot$comp), pch=as.integer(factor(tot$vers)),xlab="Number of particles", ylab="MLUPs")
legend("bottomleft",c("athena","topaz","present","master branch"),pch=c(16,16,1,2),col=c(1,2,4,4))
dev.off()
