#import <UIKit/UIKit.h>
#import "Es2alWebService.h"
#import "DateIndexObject.h"

@protocol Es2alHistoryDelegate;

@interface Es2alHistoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,Es2alWsDelegate> {
    Es2alWebService *es2alWebService;
    IBOutlet UITableView *es2alHistoryTable;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *es2alHistoryMessages;
    NSMutableArray *es2alHistoryList;
}

@property (nonatomic, retain) id <Es2alHistoryDelegate> es2alHistoryDelegate;

@end

@protocol Es2alHistoryDelegate <NSObject>
@optional
- (void)es2alHistoryViewController:(Es2alHistoryViewController *)es2alHistoryViewController setMessage:(NSMutableDictionary *)historyMessage;

@end


