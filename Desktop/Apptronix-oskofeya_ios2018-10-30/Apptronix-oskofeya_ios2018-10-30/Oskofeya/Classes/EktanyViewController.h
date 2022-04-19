#import <UIKit/UIKit.h>
#import "EktanyHistoryViewController.h"
#import "EktanyWebService.h"
#import "CFWObject.h"
#import "DateIndexObject.h"

@interface EktanyViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,EktanyHistoryDelegate,EktanyWsDelegate> {
    EktanyHistoryViewController *ektanyHistoryViewController;
    EktanyWebService *ektanyWebService;
    IBOutlet UIButton *btnCopy;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnWhtsp;
    IBOutlet UITableView *ektanyTableView;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *ektanyMessages;
    NSMutableDictionary *displayedMessage;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    float fontSize;
    NSData *mediaData;
    UIDocumentInteractionController *documentInteractionController;
    NSMutableArray *ektanyHistoryListNew;
    
    IBOutlet UIButton *btnShare;
}

@property (assign, nonatomic) int todayMsgIndex;

@end


