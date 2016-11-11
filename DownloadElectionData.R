library(jsonlite)
library(dplyr)
#Grab all of the states from CNN.com in JSON format



states<-c("AL", "AK", "AZ", "AR", "CA", "CO", "CT","DC", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WY", "WI", "WV", "WA")

i<-1
statecount<-length(states)
setwd("../DATA")

while (i<=statecount){
  currentstate<-states[i]
  fileurl<-paste("http://data.cnn.com/ELECTION/2016/",currentstate, "/county/P_county.json", sep="")
  download.file(fileurl,paste(currentstate, ".json", sep=""))
  i<-i+1  
}

#Make an empty data frame to store in

#pull in each state to temp

filenames<-list.files()


#big loop - goes through each file in the directory
s<-1

AllCounties<-data.frame(State=factor(),countyID=factor(), countyName=factor(), countyCode=factor(), ID=factor(), precinctsPct=numeric(), fname=character(), mname=character(), lname=factor(),suffix=character(), usesuffix=logical(), Party=factor(), winner=factor(), vpct=numeric(), pctDecimal=numeric(), inc=logical(), votes=integer(), cvotes=character())


while (s<=length(filenames)){

  filename<-filenames[s]
  
  temp<-fromJSON(filename, simplifyMatrix = TRUE, flatten=TRUE)
  State<-substr(filename,1,2)
  countycount<-length(temp$counties$co_id)
  
  
  n<-1
  
  #inner loop: goes through each county in the file and codes it to a dataframe with one line per candidate per county
  
  
  
while (n<=countycount){
  
    countyID<-temp$counties$co_id[n]
    countyName<-temp$counties$name[n]
    countyCode<-temp$counties$countycode[n]
    temp2<-as.data.frame(temp$counties$race.candidates[n])
    Precincts<-temp$counties$race.pctsrep[n]
    county<-cbind(State, countyID, countyName, countyCode, Precincts, temp2)

    AllCounties<-rbind(AllCounties, county)
  
    n<-n+1
} 
  
s<-s+1
}

#Change data types
AllCounties[c(1:4,5:10, 12)]<-lapply(AllCounties[c(1:4,5:10, 12)], as.factor)
AllCounties$pctDecimal<-as.numeric(AllCounties$pctDecimal)


#write the temp to a full data file


