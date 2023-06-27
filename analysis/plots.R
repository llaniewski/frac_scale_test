
L = 96*432*432

tot = NULL
for (comp in c("athena","topaz","setonix")) {
  tab_fn = paste0(comp,"/data/tab.csv")
  if (file.exists(tab_fn)) {
#    for (vers in c("master","develop","develop_nt","develop_zs","fastdem","fastdem_opp")) {
    for (vers in c("develop","develop_zs")) {
      tab=read.csv(tab_fn)
      
      tab=rbind(tab,data.frame(ny=1,nz=1,k=0,pack_name=NA,frac_name="frac_32_1_1",case_name="flow_0_1_1"))
      tab=rbind(tab,data.frame(ny=1,nz=1,k=0,pack_name=NA,frac_name="frac_32_1_1",case_name="pureflow_1_1"))
      tab=tab[order(tab$k),]
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

tot = tot[!is.na(tot$ips),]

tot$comp = factor(tot$comp)
tot$vers = factor(tot$vers)

tot$mlups = tot$ips*L/1e6
tot$ms = 1000/tot$ips
pdf("perf.pdf")
plot(tot$k,tot$mlups,type="n", ylim=range(0,tot$mlups,na.rm = TRUE),col=as.integer(tot$comp)+1, pch=as.integer(tot$vers),xlab="Number of particles", ylab="MLUPs")
by(tot,list(tot$comp,tot$vers), function(tot) {
  lines(tot$k,tot$mlups, type="b",col=as.integer(tot$comp)+1, pch=as.integer(tot$vers))
})
legend("bottomleft",legend=c(levels(tot$vers), levels(tot$comp)),pch=c(1:nlevels(tot$vers),rep(16,nlevels(tot$comp))),col=c(rep(1,nlevels(tot$vers)),1:nlevels(tot$comp)+1))
dev.off()

pdf("ms.pdf")
plot(tot$k,tot$ms,type="n", ylim=range(0,tot$ms,na.rm = TRUE),col=as.integer(tot$comp)+1, pch=as.integer(tot$vers),xlab="Number of particles", ylab="ms/iteration")
by(tot,list(tot$comp,tot$vers), function(tot) {
  lines(tot$k,tot$ms, type="b",col=as.integer(tot$comp)+1, pch=as.integer(tot$vers))
})
legend("bottomright",legend=c(levels(tot$vers), levels(tot$comp)),pch=c(1:nlevels(tot$vers),rep(16,nlevels(tot$comp))),col=c(rep(1,nlevels(tot$vers)),1:nlevels(tot$comp)+1))
dev.off()




