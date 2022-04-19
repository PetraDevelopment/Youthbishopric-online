#import <UIKit/UIKit.h>
#import "CFWObject.h"

@interface EttamenMsgViewController : UIViewController {
    IBOutlet UIButton *btnCopy;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnWhtsp;
    IBOutlet UITableView *ettamenMsgTableView;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    float fontSize;

    IBOutlet UIButton *btnShare;

}

@property (nonatomic, strong) NSString *feelingNameStr;
@property (nonatomic, strong) NSString *feelingMsgBody;
@property (nonatomic, strong) NSString *feelingMsgQuote;

@end


