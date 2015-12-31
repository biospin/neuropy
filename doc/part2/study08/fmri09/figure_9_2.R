# comparison of several different classifiers
# 

library(e1071)
library(matlab)
library(MASS)
library(randomForest)

rm(list=ls())
# create linear problem
nobsperclass=500
effectsize=1
class=c(zeros(1,nobsperclass),ones(1,nobsperclass))
testclass=sample(class)
classfac=factor(class)
testclassfac=factor(testclass)
datatype='linear'  # circular, linear, or quadratic
spacing_val=100
plotflag=1

#layout(matrix(seq(1,9),3,3,byrow=TRUE))

print (sprintf('Datatype: %s',datatype))

if (datatype=='linear') {
	
	datamat=mvrnorm(n=2*nobsperclass,mu=c(0,0),Sigma=matrix(c(1,0.5,0.5,1),nrow=2,ncol=2))
	datamat[,2]=datamat[,2]+class*effectsize

	df=as.data.frame(datamat)
	datamat_test=mvrnorm(n=2*nobsperclass,mu=c(0,0),Sigma=matrix(c(1,0.5,0.5,1),nrow=2,ncol=2))
	datamat_test[,2]=datamat_test[,2]+testclass*effectsize
	df_test=as.data.frame(datamat_test)
} else if (datatype == 'circular') {
	circle=(runif(nobsperclass*2)*2*pi)-pi
	
	datamat=mvrnorm(n=2*nobsperclass,mu=c(0,0),Sigma=matrix(c(0.1,0,0,0.1),nrow=2,ncol=2))
	datamat[,1]=datamat[,1]+class*effectsize*sin(circle)
	datamat[,2]=datamat[,2]+class*effectsize*cos(circle)
	df=as.data.frame(datamat)
	
	datamat_test=mvrnorm(n=2*nobsperclass,mu=c(0,0),Sigma=matrix(c(0.1,0,0,0.1),nrow=2,ncol=2))
	datamat_test[,1]=datamat_test[,1]+testclass*effectsize*sin(circle)
	datamat_test[,2]=datamat_test[,2]+testclass*effectsize*cos(circle)
	df_test=as.data.frame(datamat_test)

	} else if (datatype == 'quadratic') {
	
	circle=(runif(nobsperclass*2)*2*pi)-pi
	
	datamat=mvrnorm(n=2*nobsperclass,mu=c(0,0),Sigma=matrix(c(0.1,0,0,0.1),nrow=2,ncol=2))
	datamat[,1]=datamat[,1]+class*effectsize*sin(circle)
	datamat[,2]=datamat[,2]+class*effectsize*cos(circle)
	datamat[,2]=abs(datamat[,2])
	df=as.data.frame(datamat)
	
	datamat_test=mvrnorm(n=2*nobsperclass,mu=c(0,0),Sigma=matrix(c(0.1,0,0,0.1),nrow=2,ncol=2))
	datamat_test[,1]=datamat_test[,1]+testclass*effectsize*sin(circle)
	datamat_test[,2]=datamat_test[,2]+testclass*effectsize*cos(circle)
	df_test=as.data.frame(datamat_test)

	}
datagrid_x=as.matrix(seq(min(datamat[,1]),max(datamat[,1]),(max(datamat[,1]) - min(datamat[,1]))/spacing_val))
datagrid_y=as.matrix(seq(min(datamat[,2]),max(datamat[,2]),(max(datamat[,2]) - min(datamat[,2]))/spacing_val))
nx=dim(datagrid_x)[1]
ny=dim(datagrid_y)[1]

# create grid for display
grid_data=expand.grid(t(datagrid_x),t(datagrid_y))
names(grid_data)=names(df)

# LDA

lda.result=lda(df,classfac)
lda.pred.train=predict(lda.result,df)
lda.pred.train.acc=mean(lda.pred.train$class==class)

lda.pred.test=predict(lda.result,df_test)
lda.pred.test.acc=mean(lda.pred.test$class==testclass)
lda.grid=unclass(predict(lda.result,grid_data)$class)
lda.gridmatrix=reshape(as.matrix(lda.grid),c(nx,ny))
print(sprintf('LDA: %0.3f, %0.3f',lda.pred.train.acc,lda.pred.test.acc))


lda.grid=predict(lda.result,grid_data)
lda.gridmatrix=reshape(as.matrix(lda.grid$class),c(nx,ny))

outfile='lda'
pdf(file=sprintf('%s_%s.pdf',outfile,datatype))

plot(datamat,type="n",xlab="",ylab="",main="LDA")
points(datamat[class==0,],pch=16,col='blue',cex=0.5)
points(datamat[class==1,],pch=16,col='red',cex=0.5)
contour(datagrid_x,datagrid_y,lda.gridmatrix,add=TRUE,nlevels=1,labels='',lwd=2)


# QDA

qda.result=qda(df,classfac)
qda.pred.train=predict(qda.result,df)
qda.pred.train.acc=mean(qda.pred.train$class==class)

qda.pred.test=predict(qda.result,df_test)
qda.pred.test.acc=mean(qda.pred.test$class==testclass)
qda.grid=unclass(predict(qda.result,grid_data)$class)
qda.gridmatrix=reshape(as.matrix(qda.grid),c(nx,ny))
print(sprintf('QDA: %0.3f, %0.3f',qda.pred.train.acc,qda.pred.test.acc))

qda.grid=predict(qda.result,grid_data)
qda.gridmatrix=reshape(as.matrix(qda.grid$class),c(nx,ny))

dev.off()
outfile='qda'
pdf(file=sprintf('%s_%s.pdf',outfile,datatype))

plot(datamat,type="n",xlab="",ylab="",main="QDA")
points(datamat[class==0,],pch=16,col='blue',cex=0.5)
points(datamat[class==1,],pch=16,col='red',cex=0.5)
contour(datagrid_x,datagrid_y,qda.gridmatrix,add=TRUE,nlevels=1,labels='',lwd=2)


# logistic regression
#logreg.result=glm(classfac~datamat,family=binomial)
#logreg.pred.train=predict(logreg.result,df)
#logreg.pred.train.acc=mean((logreg.pred.train>0)==class)

#logreg.pred.test=predict(logreg.result,df_test)
#logreg.pred.test.acc=mean((logreg.pred.test>0)==testclass)
#print(sprintf('Logistic Regression: %0.3f, %0.3f',logreg.pred.train.acc,logreg.pred.test.acc))


# linear SVM
svmlin.result=svm(df,classfac,kernel='linear')
svmlin.pred.train=predict(svmlin.result,df)
svmlin.pred.train.acc=mean(svmlin.pred.train==classfac)

svmlin.pred.test=predict(svmlin.result,df_test)
svmlin.pred.test.acc=mean(svmlin.pred.test==testclassfac)
print(sprintf('Linear SVM: %0.3f, %0.3f',svmlin.pred.train.acc,svmlin.pred.test.acc))

svmlin.grid=unclass(predict(svmlin.result,grid_data))
svmlin.gridmatrix=reshape(as.matrix(svmlin.grid),c(nx,ny))
dev.off()
outfile='linsvm'
pdf(file=sprintf('%s_%s.pdf',outfile,datatype))

plot(datamat,type="n",xlab="",ylab="",main="Linear SVM")
points(datamat[class==0,],pch=16,col='blue',cex=0.5)
points(datamat[class==1,],pch=16,col='red',cex=0.5)
contour(datagrid_x,datagrid_y,svmlin.gridmatrix,add=TRUE,nlevels=1,labels='',lwd=2)


# radial SVM
svmradial.result=svm(df,classfac,kernel='radial')
svmradial.pred.train=predict(svmradial.result,df)
svmradial.pred.train.acc=mean(svmradial.pred.train==classfac)

svmradial.pred.test=predict(svmradial.result,df_test)
svmradial.pred.test.acc=mean(svmradial.pred.test==testclassfac)
print(sprintf('Radial SVM: %0.3f, %0.3f',svmradial.pred.train.acc,svmradial.pred.test.acc))
svmradial.grid=unclass(predict(svmradial.result,grid_data))
svmradial.gridmatrix=reshape(as.matrix(svmradial.grid),c(nx,ny))

dev.off()
outfile='radialsvm'
pdf(file=sprintf('%s_%s.pdf',outfile,datatype))

plot(datamat,type="n",xlab="",ylab="",main="Radial SVM")
points(datamat[class==0,],pch=16,col='blue',cex=0.5)
points(datamat[class==1,],pch=16,col='red',cex=0.5)
contour(datagrid_x,datagrid_y,svmradial.gridmatrix,add=TRUE,nlevels=1,labels='',lwd=2)

# GNB

gnb.result=naiveBayes(df,classfac)
gnb.pred.train=predict(gnb.result,df)
gnb.pred.train.acc=mean(gnb.pred.train==classfac)

gnb.pred.test=predict(gnb.result,df_test)
gnb.pred.test.acc=mean(gnb.pred.test==testclassfac)
print(sprintf('GNB: %0.3f, %0.3f',gnb.pred.train.acc,gnb.pred.test.acc))

gnb.grid=unclass(predict(gnb.result,grid_data))
gnb.gridmatrix=reshape(as.matrix(gnb.grid),c(nx,ny))

dev.off()
outfile='gnb'
pdf(file=sprintf('%s_%s.pdf',outfile,datatype))

plot(datamat,type="n",xlab="",ylab="",main="GNB")
points(datamat[class==0,],pch=16,col='blue',cex=0.5)
points(datamat[class==1,],pch=16,col='red',cex=0.5)
contour(datagrid_x,datagrid_y,gnb.gridmatrix,add=TRUE,nlevels=1,labels='',lwd=2)


# K-nearest neighbors

# K=1

knn1.pred.train=knn(df,df,classfac,k=1)
knn1.pred.train.acc=mean(knn1.pred.train==classfac)

knn1.pred.test=knn(df,df_test,classfac,k=1)
knn1.pred.test.acc=mean(knn1.pred.test==testclassfac)
print(sprintf('KNN (k=1): %0.3f, %0.3f',knn1.pred.train.acc,knn1.pred.test.acc))

knn1.grid=unclass(knn(df,grid_data,classfac,k=1))
knn1.gridmatrix=reshape(as.matrix(knn1.grid),c(nx,ny))

dev.off()
outfile='knn1'
pdf(file=sprintf('%s_%s.pdf',outfile,datatype))

plot(datamat,type="n",xlab="",ylab="",main="KNN = k=1")
points(datamat[class==0,],pch=16,col='blue',cex=0.5)
points(datamat[class==1,],pch=16,col='red',cex=0.5)
contour(datagrid_x,datagrid_y,knn1.gridmatrix,add=TRUE,nlevels=1,labels='',lwd=2)


# K= 10 of all data points

knn10.pred.train=knn(df,df,classfac,k=20)
knn10.pred.train.acc=mean(knn10.pred.train==classfac)

knn10.pred.test=knn(df,df_test,classfac,k=20)
knn10.pred.test.acc=mean(knn10.pred.test==testclassfac)
print(sprintf('KNN (k=10): %0.3f, %0.3f',knn10.pred.train.acc,knn10.pred.test.acc))

knn10.grid=unclass(knn(df,grid_data,classfac,k=10))
knn10.gridmatrix=reshape(as.matrix(knn10.grid),c(nx,ny))

dev.off()
outfile='knn20'
pdf(file=sprintf('%s_%s.pdf',outfile,datatype))

plot(datamat,type="n",xlab="",ylab="",main="KNN = k=10")
points(datamat[class==0,],pch=16,col='blue',cex=0.5)
points(datamat[class==1,],pch=16,col='red',cex=0.5)
contour(datagrid_x,datagrid_y,knn10.gridmatrix,add=TRUE,nlevels=1,labels='',lwd=2)

# neural network, 1 hidden layer
#nnet.result=nnet(classfac~datamat,size=2)
#nnet.pred.train=fix(predict(nnet.result,datamat)>0.5)
#nnet.pred.train.acc=mean(nnet.pred.train==classfac)
#nnet.pred.test=fix(predict(nnet.result,datamat_test)>0.5)
#nnet.pred.test.acc=mean(nnet.pred.test==testclassfac)

#print(sprintf('NNET: %0.3f, %0.3f',nnet.pred.train.acc,nnet.pred.test.acc))

#nnet.grid=fix(predict(nnet.result,grid_data))
#nnet.gridmatrix=reshape(as.matrix(nnet.grid),c(nx,ny))

#plot(datamat,type="n",xlab="",ylab="",main="Neural net")
#points(datamat[class==0,],pch=16,col='blue',cex=0.5)
#points(datamat[class==1,],pch=16,col='red',cex=0.5)
#contour(datagrid_x,datagrid_y,nnet.gridmatrix,add=TRUE,nlevels=1,labels='',lwd=2)

# random forest
dev.off()
outfile='ranforest'
pdf(file=sprintf('%s_%s.pdf',outfile,datatype))

rforest.result=randomForest(y=classfac,x=df)
rforest.pred.train=predict(rforest.result,df)
rforest.pred.train.acc=mean(rforest.pred.train==classfac)

rforest.pred.test=predict(rforest.result,df_test)
rforest.pred.test.acc=mean(rforest.pred.test==testclassfac)
print(sprintf('random forest: %0.3f, %0.3f',rforest.pred.train.acc,rforest.pred.test.acc))

rforest.grid=unclass(predict(rforest.result,grid_data))
rforest.gridmatrix=reshape(as.matrix(rforest.grid),c(nx,ny))

plot(datamat,type="n",xlab="",ylab="",main="Random Forest")
points(datamat[class==0,],pch=16,col='blue',cex=0.5)
points(datamat[class==1,],pch=16,col='red',cex=0.5)
contour(datagrid_x,datagrid_y,rforest.gridmatrix,add=TRUE,nlevels=1,labels='',lwd=2)
dev.off()
