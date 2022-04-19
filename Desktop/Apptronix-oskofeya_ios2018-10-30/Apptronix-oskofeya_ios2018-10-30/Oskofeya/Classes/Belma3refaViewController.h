#import <UIKit/UIKit.h>
#import "BelmaHistoryViewController.h"
#import "Ma3refaWebService.h"
#import "CFWObject.h"
#import "DateIndexObject.h"

@interface Belma3refaViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,BelmaHistoryDelegate,Ma3refaWsDelegate,UIGestureRecognizerDelegate> {
    BelmaHistoryViewController *belmaHistoryViewController;
    Ma3refaWebService *ma3refaWebService;
    IBOutlet UIButton *btnCopy;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnWhtsp;
    IBOutlet UILabel *belma3refaTitle;
    IBOutlet UITableView *belma3refaTableView;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *ma3refaMessages;
    NSMutableDictionary *displayedMessage;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    float fontSize;
     IBOutlet UIButton *btnShare;
}

@property (assign, nonatomic) int todayMsgIndex;

@end


