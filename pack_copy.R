library(rfracture)

rows = function(x) lapply(seq_len(nrow(x)), function(i) lapply(x, "[[", i))

N=4
org = read.lammps.data("data/pack.data")

yoffset = diff(org$ylim)
zoffset = diff(org$zlim)

ns = expand.grid(a=1:N,b=1:N)
ns = ns[ns$a >= ns$b, ]

K = nrow(org$B)
n = 10
a = K/n
b = 10^round(log10(a))
c = round(a/b)*b
ks = seq(0,K,c)[-1]

tab = rbind(data.frame(ny=ns$a, nz=ns$b, k=K), data.frame(ny=1,nz=1,k=ks))
tab$pack_name = paste("pack",tab$k,tab$ny,tab$nz,sep="_")
tab$frac_name = paste("frac",32,tab$ny,tab$nz,sep="_")
tab$case_name = paste("flow",tab$k,tab$ny,tab$nz,sep="_")
write.csv(tab,file="data/tab.csv",row.names=FALSE)



for (x in rows(tab)) {
	nm = x$pack_name
	obj = org
	if (x$k != K) {
		nB = org$B[sample.int(K,x$k),]
	} else {
		nB = org$B
	}	
	offsets = expand.grid(dy=(1:x$ny-1)*yoffset, dz=(1:x$nz-1)*zoffset)
	ret = lapply(rows(offsets), function(o) {
		B = nB
		B$y = B$y + o$dy
		B$z = B$z + o$dz
		B
	})
	ret = do.call(rbind, ret)
	obj$B = ret
	obj$ylim = range(org$ylim+min(offsets$dy),org$ylim+max(offsets$dy))
	obj$zlim = range(org$zlim+min(offsets$dz),org$zlim+max(offsets$dz))
	cat("Writing",nm,"\n")
	write.lammps.data(obj, file=paste0("data/",nm,".data"))	
}
