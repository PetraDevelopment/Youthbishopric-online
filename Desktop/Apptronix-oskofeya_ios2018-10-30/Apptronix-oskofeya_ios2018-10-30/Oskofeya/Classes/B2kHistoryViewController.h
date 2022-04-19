#import <UIKit/UIKit.h>
#import "EngylakWebService.h"
#import "DateIndexObject.h"

@protocol B2kHistoryDelegate;

@interface B2kHistoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,EngylakWsDelegate> {
    EngylakWebService *engylakWebService;
    IBOutlet UITableView *b2kHistoryTable;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *engylakHistoryMessages;
    NSMutableArray *b2kHistoryList;
}

@property (nonatomic, retain) id <B2kHistoryDelegate> b2kHistoryDelegate;

@end

@protocol B2kHistoryDelegate <NSObject>
@optional
- (void)b2kHistoryViewController:(B2kHistoryViewController *)b2kHistoryViewController setMessage:(NSMutableDictionary *)historyMessage;

@end


