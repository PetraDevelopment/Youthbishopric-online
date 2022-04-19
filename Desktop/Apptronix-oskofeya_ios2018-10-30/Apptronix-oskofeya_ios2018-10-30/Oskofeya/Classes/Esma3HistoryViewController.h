#import <UIKit/UIKit.h>
#import "Esma3WebService.h"
#import "DateIndexObject.h"

@protocol Esma3HistoryDelegate;

@interface Esma3HistoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,Esma3WsDelegate> {
    Esma3WebService *esma3WebService;
    IBOutlet UITableView *esma3HistoryTable;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *esma3HistoryMessages;
    NSMutableArray *esma3HistoryList;
}

@property (nonatomic, retain) id <Esma3HistoryDelegate> esma3HistoryDelegate;

@end

@protocol Esma3HistoryDelegate <NSObject>
@optional
- (void)esma3HistoryViewController:(Esma3HistoryViewController *)esma3HistoryViewController setMessage:(NSMutableDictionary *)historyMessage;

@end


