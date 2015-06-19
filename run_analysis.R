setwd("C:\\users\\zhuangmg\\coursera\\Getting and Cleaning Data\\Project1\\UCI HAR Dataset")

testx=read.table("./test/X_test.txt")
trainx=read.table("./train/X_train.txt") ## read both set data from test and train
testy=read.table("./test/Y_test.txt")
trainy=read.table("./train/Y_train.txt") ## read both labels from test and train
testsub=read.table("./test/subject_test.txt") 
trainsub=read.table("./train/subject_train.txt") ## read both subject data from test and train

set<-rbind(trainx,testx) ## combine set data from test and train
label<-rbind(trainy,testy) ## combine label data from test and train
subject<-rbind(trainsub,testsub)  ## combine subject data from test and train

features=read.table("./features.txt") ## read list of all features
names(set)=features$V2 ## labels the data set with descriptive variable names 
set$obs_id=rownames(set) ## set rownames as an variable obs_id for later merging (observation id)

activitylabels=read.table('./activity_labels.txt')
label$activity<-factor(label$V1, levels=1:6, labels=activitylabels$V2)  ## label with descriptive variable names and Use descriptive activity names to name the activities
label$obs_id=rownames(label) ## set rownames as an variable obs_id for later merging (observation id)

names(subject)=c("subject_id") ## labels with descriptive variable names
subject$obs_id=rownames(subject) ## set rownames as an variable obs_id for later merging (observation id)

mergedata1=merge(label,set,by.x="obs_id",by.y="obs_id",all=TRUE) ## merge set and label based on obs_id
mergedata2=merge(subject,mergedata1,by.x="obs_id",by.y="obs_id",all=TRUE)  ## merge subject and mergedata1(set and label) based on obs_id

col<-c(2,4)
extracteddata1=mergedata2[,col] ## extract information of observation id, activity, and subject id
extracteddata2=mergedata2[,grep("mean",names(mergedata2))]  ## extract column contains mean for each measurement
extracteddata3=mergedata2[,grep("std",names(mergedata2))]  ## extract column contains standard deviation for each measurement
extracteddata=cbind(extracteddata1, extracteddata2,extracteddata3) ## put all the information needed together;This is the extracted tidy data set

library(reshape2)
meltdata<-melt(extracteddata,id=c("activity","subject_id"),measure.vars=c(3:81)) ## melt the data frame

library(dplyr)
write.table(summarize(group_by(meltdata,activity, subject_id,variable),mean=mean(value,na.rm=TRUE)), file="C:\\users\\zhuangmg\\coursera\\Getting and Cleaning Data\\Project1\\average of each variable.txt", row.name=FALSE)
## get mean value of each variable for each activity and subject;export the data to a txt file


