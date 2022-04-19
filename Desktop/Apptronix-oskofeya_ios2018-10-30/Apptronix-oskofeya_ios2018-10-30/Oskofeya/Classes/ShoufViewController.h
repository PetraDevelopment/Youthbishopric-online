#import <UIKit/UIKit.h>
#import "ShoufHistoryViewController.h"
#import "ShoufWebService.h"
#import "CFWObject.h"
#import "DateIndexObject.h"
#import "YouTubeViewController.h"

@interface ShoufViewController : UIViewController <ShoufHistoryDelegate,ShoufWsDelegate> {
    ShoufHistoryViewController *shoufHistoryViewController;
    ShoufWebService *shoufWebService;
    YouTubeViewController *youTubeViewController;
    IBOutlet UIButton *btnCopy;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnWhtsp;
    IBOutlet UILabel *shoufTitle;
    UITextView *shoufSubject;
    UIView *shoufSubjectOverlay;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *shoufMessages;
    NSMutableDictionary *displayedMessage;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    float fontSize;
    
    IBOutlet UIButton *btnShare;
}

@property (assign, nonatomic) int todayMsgIndex;

@end


