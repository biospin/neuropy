# overfitting demo
# R. Poldrack

# first create a fourth-order polynomial basis set
library(matlab)
max_model_order=20
npts=50
p=poly(seq(npts),degree=max_model_order)

# specify coefficients for each order

coefs=zeros(max_model_order,1)
coefs[3]=1

# create some training and test data with noise

noise_SD = 0.1  # standard deviation of noise

train_data = p%*%coefs + rnorm(npts)*noise_SD
test_data = p%*%coefs + rnorm(npts)*noise_SD

train_sse=zeros(1,max_model_order)
test_sse=zeros(1,max_model_order)

cexval=1.5
pdf(file='overfitting_plot.pdf')
plot(train_data,pch=19,xlab='Data points',ylab='Training value',cex.lab=cexval)
orders_to_plot=c(1,3,max_model_order)

for (model_order in c(1:max_model_order)) {
	# fit model for this order
	model = lm(train_data ~ p[,1:model_order])
	# compute sum of squared residuals for training data
	train_residuals=train_data - predict(model,as.data.frame(train_data))
	train_sse[model_order]=t(train_residuals)%*%train_residuals
	# compute predicted values for test data 
	# based on training sample
	test_residuals=test_data - predict(model,as.data.frame(test_data))
	test_sse[model_order]=t(test_residuals)%*%test_residuals
	
	}
	
for (model_order in orders_to_plot) {
	# fit model for this order
	model = lm(train_data ~ p[,1:model_order])
	lines(model$fitted,lwd=2,lty=model_order)
	} 

legend(x=25,y=0.4,c('Linear','Cubic','20th order'),lty=orders_to_plot,cex= cexval)
dev.off()

pdf(file='model_order.pdf')
plot(c(1:max_model_order),train_sse,type='l',ylim=c(0,1.75),col='red',lwd=2,cex.lab=cexval,xlab='Model order',ylab='Mean squared error')
lines(c(1:max_model_order),test_sse,col='blue',lwd=2)
legend('topright',c('Training error','Test error'),col=c('red','blue'),lwd=2,cex=cexval)
dev.off()


#Jeanette trying to save it directly to eps



postscript(file="Figure9_1_EDITEDJM.eps",  width = 30.0, height = 10.0,
           horizontal = FALSE, onefile = FALSE, paper = "special",
           encoding = "TeXtext.enc")


par(mfrow=c(1,2))


plot(train_data,pch=19,xlab='Data points',ylab='Training value',cex.lab=cexval)
orders_to_plot=c(1,3,max_model_order)

for (model_order in c(1:max_model_order)) {
	# fit model for this order
	model = lm(train_data ~ p[,1:model_order])
	# compute sum of squared residuals for training data
	train_residuals=train_data - predict(model,as.data.frame(train_data))
	train_sse[model_order]=t(train_residuals)%*%train_residuals
	# compute predicted values for test data 
	# based on training sample
	test_residuals=test_data - predict(model,as.data.frame(test_data))
	test_sse[model_order]=t(test_residuals)%*%test_residuals
	
	}
	
for (model_order in orders_to_plot) {
	# fit model for this order
	model = lm(train_data ~ p[,1:model_order])
	lines(model$fitted,lwd=3,lty=model_order)
	} 

legend(x=40,y=0.44,c('Linear','Cubic','20th order'),lty=orders_to_plot,cex= cexval)


plot(c(1:max_model_order),train_sse,type='l',ylim=c(0,1.75),col='red',lwd=2,cex.lab=cexval,xlab='Model order',ylab='Mean squared error')
lines(c(1:max_model_order),test_sse,col='blue',lwd=2)
#legend('topright',c('Training error','Test error'),col=c('red','blue'),lwd=2,cex=cexval)
legend(x=17, y=1.81,c('Training error','Test error'),col=c('red','blue'),lwd=3,cex=cexval)

dev.off()
