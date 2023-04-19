library(rfracture)

rows = function(x) lapply(seq_len(nrow(x)), function(i) lapply(x, "[[", i))

N=4
org = read.lammps.data("pack.data")

yoffset = diff(org$ylim)
zoffset = diff(org$zlim)

ns = expand.grid(a=1:N,b=1:N)
ns = ns[ns$a >= ns$b, ]

for (n in rows(ns)) {
	nm = paste("pack",n$a,n$b,sep="_")
	obj = org
	offsets = expand.grid(dy=(1:n$a-1)*yoffset, dz=(1:n$b-1)*zoffset)
	ret = lapply(rows(offsets), function(o) {
		B = org$B
		B$y = B$y + o$dy
		B$z = B$z + o$dz
		B
	})
	ret = do.call(rbind, ret)
	obj$B = ret
	obj$ylim = range(org$ylim+min(offsets$dy),org$ylim+max(offsets$dy))
	obj$zlim = range(org$zlim+min(offsets$dz),org$zlim+max(offsets$dz))
	write.lammps.data(obj, file=paste(nm,"data",sep="."))	
}