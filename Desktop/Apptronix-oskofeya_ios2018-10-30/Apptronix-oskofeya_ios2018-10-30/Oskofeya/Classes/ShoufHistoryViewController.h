#import <UIKit/UIKit.h>
#import "ShoufWebService.h"
#import "DateIndexObject.h"

@protocol ShoufHistoryDelegate;

@interface ShoufHistoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,ShoufWsDelegate> {
    ShoufWebService *shoufWebService;
    IBOutlet UITableView *shoufHistoryTable;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *shoufHistoryMessages;
    NSMutableArray *shoufHistoryList;
}

@property (nonatomic, retain) id <ShoufHistoryDelegate> shoufHistoryDelegate;

@end

@protocol ShoufHistoryDelegate <NSObject>
@optional
- (void)shoufHistoryViewController:(ShoufHistoryViewController *)shoufHistoryViewController setMessage:(NSMutableDictionary *)historyMessage;

@end


