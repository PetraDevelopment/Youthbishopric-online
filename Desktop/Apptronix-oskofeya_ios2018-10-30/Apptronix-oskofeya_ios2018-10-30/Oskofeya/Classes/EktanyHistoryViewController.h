#import <UIKit/UIKit.h>
#import "EktanyWebService.h"
#import "DateIndexObject.h"

@protocol EktanyHistoryDelegate;

@interface EktanyHistoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,EktanyWsDelegate> {
    EktanyWebService *ektanyWebService;
    IBOutlet UITableView *ektanyHistoryTable;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *ektanyHistoryMessages;
    NSMutableArray *ektanyHistoryList;
}

@property (nonatomic, retain) id <EktanyHistoryDelegate> ektanyHistoryDelegate;

@end

@protocol EktanyHistoryDelegate <NSObject>
@optional
- (void)ektanyHistoryViewController:(EktanyHistoryViewController *)ektanyHistoryViewController setMessage:(NSMutableDictionary *)historyMessage;

@end


