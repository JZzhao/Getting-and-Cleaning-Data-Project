#Below is R script to run out a tidy data set from raw data
X_test<-read.table("./HAR/UCI HAR Dataset/test/X_test.txt")
X_train<-read.table("./HAR/UCI HAR Dataset/train/X_train.txt")
#read test and train data set respectively
feature<-read.table("./HAR/UCI HAR Dataset/features.txt")
feature_head<-feature[,2]
#read the meansurements names from features.txt and assign 
subject_test<-read.table("./HAR/UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./HAR/UCI HAR Dataset/train/subject_train.txt")
#read subject respectively
test_label<-read.table("./HAR/UCI HAR Dataset/test/y_test.txt")
train_label<-read.table("./HAR/UCI HAR Dataset/train/y_train.txt")
#read activity respectively
colnames(X_test)<-feature_head
#name all the measurements in test data set
colnames(subject_test)<-"subject"
X_test1<-cbind(X_test,subject_test)
colnames(test_label)<-"activity"
X_test2<-cbind(X_test1,test_label)
#use cbind to combine subject and activity into test data, name them respectively
colnames(X_train)<-feature_head
#name all the measurements in train data set
colnames(subject_train)<-"subject"
X_train1<-cbind(X_train,subject_train)
colnames(train_label)<-"activity"
X_train2<-cbind(X_train1,train_label)
#use cbind to combine subject and activity into train data, name them respectively
sumset<-rbind(X_train2,X_test2)
##merge the test and train data set 
cn<-colnames(sumset)
sumset_mean<-cn%in%grep("mean\\(",cn,value=TRUE)
sumset1<-subset(sumset, ,sumset_mean)
#filter with "mean()" to sumset1
sumset_std<-cn%in%grep("std()",cn,value=TRUE)
sumset2<-subset(sumset, ,sumset_std)
#filter with "std()" to sumset2
sumset3<-cbind(sumset1,sumset2)
sumset4<-cbind(sumset3,sumset[,c("subject","activity")])
#merge "mean()","std()","subject","activity"columns 
library(reshape)
sumset_cal<-melt(sumset4,id=c("subject","activity"))
sumset_tidy<-cast(sumset_cal,subject+activity~variable,mean)
#with reshape packages, calculate the average for each subject and each activity
write.table(sumset_tidy,file="./HAR/UCI HAR Dataset/tidydata.txt")
