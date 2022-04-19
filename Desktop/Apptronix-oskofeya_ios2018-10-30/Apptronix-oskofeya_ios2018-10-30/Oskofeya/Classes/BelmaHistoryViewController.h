#import <UIKit/UIKit.h>
#import "Ma3refaWebService.h"
#import "DateIndexObject.h"

@protocol BelmaHistoryDelegate;

@interface BelmaHistoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,Ma3refaWsDelegate> {
    Ma3refaWebService *ma3refaWebService;
    IBOutlet UITableView *belmaHistoryTable;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *ma3refaHistoryMessages;
    NSMutableArray *belmaHistoryList;
}

@property (nonatomic, retain) id <BelmaHistoryDelegate> belmaHistoryDelegate;

@end

@protocol BelmaHistoryDelegate <NSObject>
@optional
- (void)belmaHistoryViewController:(BelmaHistoryViewController *)belmaHistoryViewController setMessage:(NSMutableDictionary *)historyMessage;

@end


