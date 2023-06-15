setwd("~/repo/frac_scale_test/analysis/")
L = 96*432*432

tot = NULL
for (comp in c("athena","topaz","setonix")) {
  tab_fn = paste0(comp,"/data/tab.csv")
  if (file.exists(tab_fn)) {
    for (vers in c("master","fastdem","fastdem_opp")) {
      tab=read.csv(tab_fn)
      tab$comp = comp
      tab$vers = vers
      fn = paste0(comp,"/",vers,"/output/",tab$case_name,"_Log_P00_00000000.csv")
      
      sel = file.exists(fn)
      if (any(sel)) {
        ret = lapply(fn[sel],function(x) { read.csv(x) })
        sapply(ret, function(x) diff(x$Iterations)/diff(x$Walltime))
      
        ret = lapply(ret, function(x) diff(x$Iteration)/diff(x$Walltime))
        tab$ips[sel] = sapply(ret, mean)
        tab$ips_sd[sel] = sapply(ret, sd)
      } else {
        tab$ips = NA
        tab$ips_sd = NA
      }
      tot = rbind(tot,tab)
    }
  }
}

tot$comp = factor(tot$comp)
tot$vers = factor(tot$vers)

tot$mlups = tot$ips*L/1e6
pdf("perf.pdf")
plot(tot$k,tot$mlups, ylim=range(0,tot$mlups,na.rm = TRUE),col=as.integer(tot$comp), pch=as.integer(tot$vers),xlab="Number of particles", ylab="MLUPs")
legend("bottomleft",legend=c(levels(tot$vers), levels(tot$comp)),pch=c(1:nlevels(tot$vers),rep(16,nlevels(tot$comp))),col=c(rep(1,nlevels(tot$vers)),1:nlevels(tot$comp)))
dev.off()

pdf("ms.pdf")
plot(tot$k,1/tot$ips, ylim=range(0,1/tot$ips,na.rm = TRUE),col=tot$comp, pch=as.integer(tot$vers),xlab="Number of particles", ylab="s/it")
legend("bottomleft",c("athena","topaz","present","master branch"),pch=c(16,16,1,2),col=c(1,2,4,4))
dev.off()
