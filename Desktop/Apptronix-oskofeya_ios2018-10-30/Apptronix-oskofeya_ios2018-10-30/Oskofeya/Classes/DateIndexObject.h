#import <Foundation/Foundation.h>

@interface DateIndexObject : NSObject

- (int)extractDateIndexFromMessages:(NSMutableArray *)messages andDate:(NSDate *)date;
- (int)extractDateIndexFromPeriodMessages:(NSMutableArray *)messages andDate:(NSDate *)date;
- (int)extractTitleIndexFromMessages:(NSMutableArray *)messages andTitle:(NSString *)title;
- (NSMutableArray *)extractPresentAndPastPublishDateMessagesFromMessages:(NSMutableArray *)messages andCurrentDate:(NSDate *)date;
- (BOOL)checkForDateInMessages:(NSMutableArray *)messages andDate:(NSDate *)date;
- (BOOL)isKey:(NSNumber *)keyStr inMessages:(NSMutableArray *)messages;
- (NSString *)extractPrayerName;

@end


