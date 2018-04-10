library("modelr")
library("dplyr")
library("ggplot2")
library("InformationValue")

setwd("C:/Users/a688291/Documents/EDA_CRJR/")

InterviewData <- read.csv("Interview.csv")
InterviewData <- as.data.frame(InterviewData)

##First look at the output


InterviewData <- InterviewData %>% dplyr::mutate(Observed.Attendance = trimws(tolower(Observed.Attendance)))
InterviewData <- InterviewData %>% filter(Observed.Attendance != "" ) #just to erase the last row
byAttendance <- InterviewData %>% group_by(Observed.Attendance) %>% summarise(count = n()) %>% mutate(Freq = count / sum(count))



ggplot2::ggplot(byAttendance, aes(x = "Output", y = Freq, fill = Observed.Attendance))+ ggplot2::geom_bar(stat="identity")+geom_text(aes(label = round(Freq, 2)), position = position_stack(vjust = 0.5))


InterviewData$Location<-trimws(tolower(InterviewData$Location))
#To correct a typo 
InterviewData<- InterviewData %>% 
  mutate(Location = ifelse(
  Location == "gurgaonr" , 
  "gurgaon", 
  Location))

byLocation <- InterviewData%>%
  group_by(Location)%>%
  summarise(count=n())

ggplot(data = byLocation) + 
geom_col(mapping = aes(x = Location, y = count))


byIndustry <- InterviewData%>%
group_by(Industry)%>%
summarise(count = n())%>%
mutate(Freq = count / sum(count))

ggplot(byIndustry)+
geom_col(aes(x=Industry,y=Freq))+
theme(axis.text.x = element_text(angle = 90, hjust = 1))


byInterviewVenue <- InterviewData%>%
group_by(Interview.Venue)%>%
summarise(count = n())%>%
mutate(freq = count / sum(count))

ggplot(byInterviewVenue)+
geom_col(aes(x=Interview.Venue,y=freq))


byNatureSkillset <- InterviewData%>%
group_by(Nature.of.Skillset)%>%
summarise(count = n())%>%
mutate(freq = count / sum(count))

ggplot(byNatureSkillset)+
geom_col(aes(x = Nature.of.Skillset,y=freq))+
theme(axis.text.x = element_text(angle = 90, hjust = 1))


InterviewData<- InterviewData %>% 
  mutate(SkillsetGroup = ifelse(
    grepl("java", tolower(Nature.of.Skillset)), 
    "java", 
    tolower(Nature.of.Skillset) ))

InterviewData<- InterviewData %>% 
  mutate(SkillsetGroup = ifelse(
    grepl("analytical", tolower(SkillsetGroup)), 
    "analytical", 
    SkillsetGroup ))

InterviewData<- InterviewData %>% 
  mutate(SkillsetGroup = ifelse(
    grepl("oracle", tolower(SkillsetGroup)), 
    "oracle", 
    SkillsetGroup ))

InterviewData<- InterviewData %>% 
  mutate(SkillsetGroup = ifelse(
    grepl("cots", tolower(SkillsetGroup)), 
    "cots", 
    SkillsetGroup ))

InterviewData<- InterviewData %>% 
  mutate(SkillsetGroup = ifelse(
    grepl("bios", tolower(SkillsetGroup)), 
    "biosimilar", 
    SkillsetGroup ))

InterviewData<- InterviewData %>% 
  mutate(SkillsetGroup = ifelse(
    grepl(paste(c("0 am","0 pm", "#name"), collapse="|"), tolower(SkillsetGroup)), 
    "NA", 
    SkillsetGroup ))

InterviewData<- InterviewData %>% 
  mutate(SkillsetGroup = ifelse(
    grepl("lending", tolower(SkillsetGroup)), 
    "lending and liabilities", 
    SkillsetGroup ))

InterviewData<- InterviewData %>% 
  mutate(SkillsetGroup = ifelse(
    grepl(paste(c("tech lead","technical"), collapse="|"), tolower(SkillsetGroup)), 
    "tech lead", 
    SkillsetGroup ))

InterviewData<- InterviewData %>% 
  mutate(SkillsetGroup = ifelse(
    grepl("publis", tolower(SkillsetGroup)), 
    "publishing", 
    SkillsetGroup ))

InterviewData<- InterviewData %>% 
  mutate(SkillsetGroup = ifelse(
    grepl("production", tolower(SkillsetGroup)), 
    "production", 
    SkillsetGroup ))



byNatureSkillset <- InterviewData%>%
group_by(SkillsetGroup)%>%
summarise(count = n())%>%
mutate(Freq = count / sum(count))

ggplot(byNatureSkillset)+
geom_col(aes(x = SkillsetGroup,y = Freq))+
theme(axis.text.x = element_text(angle = 90, hjust = 1))



InterviewData<- InterviewData %>% 
mutate(Can.I.Call.you.three.hours.before.the.interview.and.follow.up.on.your.attendance.for.the.interview = ifelse(
grepl("no", tolower(Can.I.Call.you.three.hours.before.the.interview.and.follow.up.on.your.attendance.for.the.interview)), 
"no", 
"yes" ))

InterviewData <- InterviewData%>%
mutate(Observed.AttendanceOI = ifelse(Observed.Attendance == "yes", 1 , 0 ))

InterviewData <- InterviewData%>%
mutate(CallBeforeInterview = ifelse(Can.I.Call.you.three.hours.before.the.interview.and.follow.up.on.your.attendance.for.the.interview == "yes", 1 , 0 ))

InterviewData$CallBeforeInterview <- as.factor(InterviewData$CallBeforeInterview)

InterviewData <- InterviewData %>%
mutate(Expected.Attendance = ifelse(tolower(Expected.Attendance)=="yes", "yes", "no"))

InterviewData <- InterviewData %>%
mutate(ExpectedAttendanceIO = ifelse(Expected.Attendance=="yes", 1, 0))

InterviewData$ExpectedAttendanceIO <- as.factor(InterviewData$ExpectedAttendanceIO)

InterviewData$SkillsetGroup <- as.factor(InterviewData$SkillsetGroup)

InterviewData$Marital.Status <- as.factor(InterviewData$Marital.Status)

InterviewData$Location <- as.factor(InterviewData$Location)



sum(WOETable( InterviewData$Industry, InterviewData$Observed.AttendanceOI)$IV[-1])#YES

sum(WOETable(InterviewData$SkillsetGroup, InterviewData$Observed.AttendanceOI)$IV)#YES

sum(WOETable(InterviewData$CallBeforeInterview, InterviewData$Observed.AttendanceOI)$IV)#No

sum(WOETable(InterviewData$Marital.Status, InterviewData$Observed.AttendanceOI)$IV[-1])#No

sum(WOETable(InterviewData$CallBeforeInterview, InterviewData$Observed.AttendanceOI)$IV)#No

sum(WOETable(InterviewData$ExpectedAttendanceIO, InterviewData$Observed.AttendanceOI)$IV)#yes

sum(WOETable(InterviewData$Position.to.be.closed, InterviewData$Observed.AttendanceOI)$IV[-1])#maybe

sum(WOETable(InterviewData$Location, InterviewData$Observed.AttendanceOI)$IV)#maybe




##########First version of the model, just to have a benchmark with one variable
MOD1_InterviewData <- InterviewData%>%
  select(Observed.AttendanceOI,ExpectedAttendanceIO)%>%
  filter(is.na(ExpectedAttendanceIO)== FALSE)

mod1 <- glm(Observed.AttendanceOI ~ ExpectedAttendanceIO , 
            data = MOD1_InterviewData, 
            family = binomial("logit"))


MOD1_InterviewData <- MOD1_InterviewData%>%
  mutate(prediction = predict(mod1, MOD1_InterviewData$Expected.AttendanceIO, type="response"))

optCutOff <- optimalCutoff(MOD1_InterviewData$Observed.AttendanceOI, MOD1_InterviewData$prediction)[1] 

plotROC(MOD1_InterviewData$Observed.AttendanceOI, MOD1_InterviewData$prediction)
confusionMatrix(MOD1_InterviewData$Observed.AttendanceOI, MOD1_InterviewData$prediction, threshold = optCutOff)

##########Second version of the model

MOD2_InterviewData <- InterviewData%>%
  select(Observed.AttendanceOI,ExpectedAttendanceIO,SkillsetGroup )%>%
  filter(is.na(ExpectedAttendanceIO)== FALSE)%>%
  filter(is.na(SkillsetGroup)== FALSE)

MOD2_InterviewData$ExpectedAttendanceIO <- as.factor(MOD2_InterviewData$ExpectedAttendanceIO)
MOD2_InterviewData$SkillsetGroup <- as.factor(MOD2_InterviewData$SkillsetGroup)

mod2 <- glm(Observed.AttendanceOI ~ ExpectedAttendanceIO + SkillsetGroup, 
            data = MOD2_InterviewData, 
            family = binomial("logit"))

dfPredict <- select(MOD2_InterviewData, ExpectedAttendanceIO, SkillsetGroup)


MOD2_InterviewData <- MOD2_InterviewData%>%
  mutate(prediction = predict(mod2, dfPredict, type = "response"))

optCutOff <- optimalCutoff(MOD1_InterviewData$Observed.AttendanceOI, MOD2_InterviewData$prediction)[1] 
plotROC(MOD2_InterviewData$Observed.AttendanceOI, MOD2_InterviewData$prediction)
confusionMatrix(MOD2_InterviewData$Observed.AttendanceOI, MOD2_InterviewData$prediction, threshold = optCutOff)



