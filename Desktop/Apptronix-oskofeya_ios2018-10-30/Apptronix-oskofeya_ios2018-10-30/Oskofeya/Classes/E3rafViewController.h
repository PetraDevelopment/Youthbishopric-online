#import <UIKit/UIKit.h>
#import "E3rafHistoryViewController.h"
#import "CFWObject.h"
#import "DateIndexObject.h"
#import "E3rafWebService.h"

@interface E3rafViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,E3rafHistoryDelegate,E3rafWsDelegate> {
    E3rafHistoryViewController *e3rafHistoryViewController;
     E3rafWebService *e3rafWebService;
    IBOutlet UIButton *btnCopy;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnWhtsp;
    IBOutlet UITableView *e3rafTableView;
    int selectedE3rafItemNum;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    float fontSize;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    
    IBOutlet UIButton *btnShare;
    
    NSMutableArray *e3rafHistoryMessages;
    NSMutableOrderedSet *e3rafHistorySet;
    NSMutableArray *e3rafHistorySetOfMessages;
}

@property (retain, nonatomic) NSMutableArray *e3rafMessages;
@property (retain, nonatomic) NSMutableArray *e3rafDisplayedMessages;
@property (assign, nonatomic) BOOL navigatingFromMain;
@property (assign, nonatomic) BOOL shouldHideActivityIndicator;

- (void)updateView;

@end


