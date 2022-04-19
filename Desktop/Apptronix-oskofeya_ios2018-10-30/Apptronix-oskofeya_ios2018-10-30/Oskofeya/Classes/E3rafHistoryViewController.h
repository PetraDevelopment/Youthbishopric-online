#import <UIKit/UIKit.h>
#import "E3rafWebService.h"
#import "DateIndexObject.h"

@protocol E3rafHistoryDelegate;

@interface E3rafHistoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,E3rafWsDelegate> {
    E3rafWebService *e3rafWebService;
    IBOutlet UITableView *e3rafHistoryTable;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *e3rafHistoryMessages;
    NSMutableOrderedSet *e3rafHistorySet;
    NSMutableArray *e3rafHistorySetOfMessages;
}

@property (retain, nonatomic) id <E3rafHistoryDelegate> e3rafHistoryDelegate;

@end

@protocol E3rafHistoryDelegate <NSObject>
@optional
- (void)e3rafHistoryViewController:(E3rafHistoryViewController *)e3rafHistoryViewController setE3rafMessages:(NSMutableArray *)e3rafMessagesInDay;

@end


