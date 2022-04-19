#import "DateIndexObject.h"

@implementation DateIndexObject

- (int)extractDateIndexFromMessages:(NSMutableArray *)messages andDate:(NSDate *)date {
    int todayMsgIndex = 0;
    int tempIndex = 0;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormat stringFromDate:date];
    for (NSDictionary *tempDict in messages) {
        NSString *selectedDate = [tempDict objectForKey:@"publish_date"];
        if(![selectedDate isEqual:[NSNull null]]) {
            todayMsgIndex = tempIndex;
            if ([selectedDate isEqualToString:currentDateStr]) {
                break;
            }
            tempIndex ++;
        }
    }
    return todayMsgIndex;
}

- (int)extractDateIndexFromPeriodMessages:(NSMutableArray *)messages andDate:(NSDate *)date {
    int todayMsgIndex = 0;
    int tempIndex = 0;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    for (NSDictionary *tempDict in messages) {
        NSString *publishDate = [tempDict objectForKey:@"publish_date"];
        NSString *removeDate = [tempDict objectForKey:@"remove_date"];
        if(![publishDate isEqual:[NSNull null]] || ![removeDate isEqual:[NSNull null]]) {
            todayMsgIndex = tempIndex;
            if (([[dateFormat dateFromString:publishDate] timeIntervalSinceDate:date] <= 0) && ([date timeIntervalSinceDate:[dateFormat dateFromString:removeDate]] <= 86400.00)) {
                break;
            }
            tempIndex ++;
        }
    }
    return todayMsgIndex;
}


- (int)extractTitleIndexFromMessages:(NSMutableArray *)messages andTitle:(NSString *)title {
    int selectedMsgIndex = 0;
    int tempIndex = 0;
    for (NSDictionary *tempDict in messages) {
        NSString *selectedTitle = [tempDict objectForKey:@"title"];
        if(![selectedTitle isEqual:[NSNull null]]) {
            if ([selectedTitle isEqualToString:title]) {
                selectedMsgIndex = tempIndex;
            }
            tempIndex ++;
        }
    }
    return selectedMsgIndex;
}

- (NSMutableArray *)extractPresentAndPastPublishDateMessagesFromMessages:(NSMutableArray *)messages andCurrentDate:(NSDate *)date {
    NSMutableArray *returnMessages = [[NSMutableArray alloc] initWithObjects:nil];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    for (NSDictionary *tempDict in messages) {
        NSString *publishDate = [tempDict objectForKey:@"publish_date"];
        if(![publishDate isEqual:[NSNull null]]) {
            // NSLog(@"publishDate = %@ \ntimeIntervalSinceDate = %f",[dateFormat dateFromString:publishDate],[[dateFormat dateFromString:publishDate] timeIntervalSinceDate:date]);
            if ([[dateFormat dateFromString:publishDate] timeIntervalSinceDate:date] <= 0) {
                [returnMessages addObject:tempDict];
            }
        }
    }
    return returnMessages;
}

- (BOOL)checkForDateInMessages:(NSMutableArray *)messages andDate:(NSDate *)date {
    BOOL doesDateExist = NO;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormat stringFromDate:date];
    for (NSDictionary *tempDict in messages) {
        NSString *publishDate = [tempDict objectForKey:@"publish_date"];
        if(![publishDate isEqual:[NSNull null]]) {
            if ([publishDate isEqualToString:currentDateStr]) {
                doesDateExist = YES;
            }
        }
    }
    return doesDateExist;
}

- (BOOL)isKey:(NSNumber *)key inMessages:(NSMutableArray *)messages {
    BOOL keyExists = NO;
    // NSLog(@"keyUnderTest = %d",[key intValue]);
    for (NSDictionary *TempDict in messages) {
        int selectedKey = [[TempDict objectForKey:@"id"] intValue];
        if (selectedKey == [key intValue]) {
            keyExists = YES;
        }
    }
    return keyExists;
}

- (NSString *)extractPrayerName {
    NSString *prayerName;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSUIntegerMax fromDate:[NSDate date]];
    // Calculate Prime Prayer Times (12am - 2pm)
    [dateComps setHour:0]; [dateComps setMinute:0]; [dateComps setSecond:0];
    NSDate *primeBeginTime = [calendar dateFromComponents:dateComps];
    // Calculate Vespers Prayer Times (2pm - 6pm)
    [dateComps setHour:14]; [dateComps setMinute:0]; [dateComps setSecond:0];
    NSDate *vespersBeginTime = [calendar dateFromComponents:dateComps];
    // Calculate Compline Prayer Times (6pm - 12am)
    [dateComps setHour:18]; [dateComps setMinute:0]; [dateComps setSecond:0];
    NSDate *complineBeginTime = [calendar dateFromComponents:dateComps];
    [dateComps setHour:24]; [dateComps setMinute:0]; [dateComps setSecond:0];
    NSDate *complineEndTime = [calendar dateFromComponents:dateComps];
    if (([[NSDate date] timeIntervalSinceDate:primeBeginTime] > 0) && ([vespersBeginTime timeIntervalSinceDate:[NSDate date]] > 0)) {
        prayerName = @"Prime";
    } else if (([[NSDate date] timeIntervalSinceDate:vespersBeginTime] > 0) && ([complineBeginTime timeIntervalSinceDate:[NSDate date]] > 0)) {
        prayerName = @"Vespers";
    } else if (([[NSDate date] timeIntervalSinceDate:complineBeginTime] > 0) && ([complineEndTime timeIntervalSinceDate:[NSDate date]] > 0)) {
        prayerName = @"Compline";
    }
    return prayerName;
}

@end


