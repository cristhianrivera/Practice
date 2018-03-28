
library("dplyr")
library("ggplot2")
library("InformationValue")

setwd("C:/Users/a688291/Documents/EDA_CRJR/the-interview-attendance-problem")

InterviewData <- read.csv("Interview.csv")
InterviewData <- as.data.frame(InterviewData)

##First look at the output

InterviewData<- InterviewData %>% 
  mutate(Observed.Attendance =trimws(tolower(Observed.Attendance)))


byAttendance <- InterviewData%>%
  group_by(Observed.Attendance)%>%
  summarise(count = n())%>%
  mutate(Freq = count / sum(count))

ggplot(byAttendance, aes(x = "", y = Freq, fill = Observed.Attendance))+
  geom_bar(stat="identity")


#by location

InterviewData$Location<-trimws(tolower(InterviewData$Location))
filter(InterviewData, Location == "gurgaonr")

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


#by industry

byIndustry <- InterviewData%>%
  group_by(Industry)%>%
  summarise(count = n())%>%
  mutate(freq = count / sum(count))

ggplot(byIndustry)+
  geom_col(aes(x=Industry,y=freq))


#by Interview.Venue

byInterviewVenue <- InterviewData%>%
  group_by(Interview.Venue)%>%
  summarise(count = n())%>%
  mutate(freq = count / sum(count))

ggplot(byInterviewVenue)+
  geom_col(aes(x=Interview.Venue,y=freq))



# by Nature.of.Skillset
byNatureSkillset <- InterviewData%>%
  group_by(Nature.of.Skillset)%>%
  summarise(count = n())%>%
  mutate(freq = count / sum(count))

ggplot(byNatureSkillset)+
  geom_col(aes(x = Nature.of.Skillset,y=freq))+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#---- create groups of skillsets

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

InterviewData<- InterviewData %>% 
  mutate(Can.I.Call.you.three.hours.before.the.interview.and.follow.up.on.your.attendance.for.the.interview = ifelse(
    grepl("no", tolower(Can.I.Call.you.three.hours.before.the.interview.and.follow.up.on.your.attendance.for.the.interview)), 
    "no", 
    "yes" ))

#Let's see how it looks now

byNatureSkillset <- InterviewData%>%
  group_by(SkillsetGroup)%>%
  summarise(count = n())%>%
  mutate(Freq = count / sum(count))

ggplot(byNatureSkillset)+
  geom_col(aes(x = SkillsetGroup,y = Freq))+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


#Select the variables that we would like to introduce into our model

InterviewData <- InterviewData%>%
  mutate(Observed.AttendanceOI = ifelse(Observed.Attendance == "yes", 1 , 0 ))

WOETable(InterviewData$Gender, InterviewData$Observed.AttendanceOI )

WOETable(InterviewData$Industry, InterviewData$Observed.AttendanceOI)#YES

WOETable(InterviewData$SkillsetGroup, InterviewData$Observed.AttendanceOI)#YES

WOETable(InterviewData$Can.I.Call.you.three.hours.before.the.interview.and.follow.up.on.your.attendance.for.the.interview, InterviewData$Observed.AttendanceOI)

#This is because there's a problem, so we can transform this variable to have somethign understandable for the machine
InterviewData <- InterviewData%>%
  mutate(CallBeforeInterview = ifelse(Can.I.Call.you.three.hours.before.the.interview.and.follow.up.on.your.attendance.for.the.interview == "yes", 1 , 0 ))

InterviewData$CallBeforeInterview <- as.factor(InterviewData$CallBeforeInterview)

WOETable(InterviewData$CallBeforeInterview, InterviewData$Observed.AttendanceOI)#No


WOETable(InterviewData$Marital.Status, InterviewData$Observed.AttendanceOI)#No

WOETable(InterviewData$CallBeforeInterview, InterviewData$Observed.AttendanceOI)#No

#This is because there's a problem, so we can transform this variables to have something understandable for the machine
InterviewData <- InterviewData %>%
  mutate(Expected.Attendance = ifelse(tolower(Expected.Attendance)=="yes", "yes", "no"))

InterviewData <- InterviewData %>%
  mutate(ExpectedAttendanceIO = ifelse(Expected.Attendance=="yes", 1, 0))

InterviewData$ExpectedAttendanceIO <- as.factor(InterviewData$ExpectedAttendanceIO)

WOETable(InterviewData$ExpectedAttendanceIO, InterviewData$Observed.AttendanceOI)#yes

sum(WOETable(InterviewData$Position.to.be.closed, InterviewData$Observed.AttendanceOI)$IV)#maybe

WOETable(InterviewData$Location, InterviewData$Observed.AttendanceOI)#NO


##########################Split the data for training and testing purposes
smp_size <- floor(0.75 * nrow(mtcars))

## set the seed to make your partition reproductible
set.seed(123)
train_ind <- sample(seq_len(nrow(mtcars)), size = smp_size)

train <- mtcars[train_ind, ]
test <- mtcars[-train_ind, ]


##########First version of the model, just to have a benchmark with one variable
MOD1_InterviewData <- InterviewData%>%
  select(Observed.AttendanceOI,ExpectedAttendanceIO)%>%
  filter(is.na(ExpectedAttendanceIO)== FALSE)
  
mod1 <- glm(Observed.AttendanceOI ~ ExpectedAttendanceIO , 
            data = MOD1_InterviewData, 
            family = binomial("logit"))

summary(mod1)

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

mod2 <- glm(Observed.AttendanceOI ~ ExpectedAttendanceIO + SkillsetGroup, 
            data = MOD2_InterviewData, 
            family = binomial("logit"))

summary(mod2)


dfPredict <- filter(MOD2_InterviewData, ExpectedAttendanceIO, SkillsetGroup)

MOD2_InterviewData <- MOD2_InterviewData%>%
  mutate(prediction = predict(mod1, dfPredict , type="response"))

optCutOff <- optimalCutoff(MOD1_InterviewData$Observed.AttendanceOI, MOD1_InterviewData$prediction)[1] 

plotROC(MOD1_InterviewData$Observed.AttendanceOI, MOD1_InterviewData$prediction)
confusionMatrix(MOD1_InterviewData$Observed.AttendanceOI, MOD1_InterviewData$prediction, threshold = optCutOff)

add_predictions

colnames(InterviewData)





