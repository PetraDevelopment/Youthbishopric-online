#import <UIKit/UIKit.h>
#import "Es2alHistoryViewController.h"
#import "Es2alWebService.h"
#import "Es2alQuestionWebService.h"
#import "CFWObject.h"
#import "DateIndexObject.h"

@interface Es2alViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,Es2alHistoryDelegate,Es2alWsDelegate,Es2alQuestionWsDelegate,UITextViewDelegate,UIActionSheetDelegate> {
    Es2alHistoryViewController *es2alHistoryViewController;
    Es2alWebService *es2alWebService;
    Es2alQuestionWebService *es2alQuestionWebService;
    IBOutlet UIButton *btnCopy;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnWhtsp;
    IBOutlet UITableView *es2alTableView;
    IBOutlet UITextView *es2alTextView;
    IBOutlet UIButton *es2alSendButton;
    NSMutableArray *es2alMessages;
    NSMutableDictionary *displayedMessage;
    NSData *mediaData;
    UIDocumentInteractionController *documentInteractionController;
    NSString *es2alQuestionStr;
    CGFloat viewScrollAmount;
    BOOL moveViewUp;
    UIViewController *keyboardViewController;
    UIActionSheet *actionSheet;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    float fontSize;
    NSDictionary *infoDictionary;
    IBOutlet UIButton *btnShare;
    IBOutlet UIImageView *andyso2al;
}

@property (assign, nonatomic) int todayMsgIndex;

@end


