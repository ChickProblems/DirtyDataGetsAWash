## This script assumes that the working directory is within the folder UCI HAR  Dataset and that no files have been renamed since downloading and unzipping the oringal file.

        library(dplyr)
        
        ##First, read all the things.
        
        features <- read.table("features.txt", stringsAsFactors = FALSE)
        x_test <- read.table("test/X_test.txt")
        y_test <- read.table("test/y_test.txt")
        subject_test <- read.table("test/subject_test.txt")
        x_train <- read.table("train/X_train.txt")
        y_train <- read.table("train/y_train.txt")
        subject_train <- read.table("train/subject_train.txt")
        
        ##Prepare labels for columns.
        
        labels <- as.vector(features[,2])
        names(x_train) <- labels
        names(x_test) <- labels
        names(y_train) <- c("activities")
        names(y_test) <- c("activities")
        names(subject_train) <- c("subject")
        names(subject_test) <- c("subject")
        
        ##Lets put it all together.
        
        train_block <- x_train
        train_block <- cbind(train_block, subject_train)
        train_block <- cbind(train_block, y_train)
        
        test_block <- x_test
        test_block <- cbind(test_block, subject_test)
        test_block <- cbind(test_block, y_test)
        
        data <- train_block
        data <- rbind(data, test_block)
        
        ##Oh snap! The verbs for labeling our activities!
        
        data$activities[data$activities == "1"] <- "WALKING"
        data$activities[data$activities == "2"] <- "WALKING_UPSTAIRS"
        data$activities[data$activities == "3"] <- "WALKING_DOWNSTAIRS"
        data$activities[data$activities == "4"] <- "SITTING"
        data$activities[data$activities == "5"] <- "STANDING"
        data$activities[data$activities == "6"] <- "LAYING"
        
        ##Get our columns related to mean and std.
        
        means <- features[grep("mean", features[,2]),]
        stds <- features[grep("std", features[,2]),]
        master <- c(means[,2], stds[,2], "activities", "subject")
        
        ##Put our columns in thier own data frame and summarise the mean.
        
        new <- data[ , names(data) %in% master]
        final <- new %>% group_by(activities,subject) %>% summarise_each(funs(mean))
        
        ##Write it to a table for future fun analysis!
        
        write.table(final, file = "final_analysis.txt", row.name=FALSE)
