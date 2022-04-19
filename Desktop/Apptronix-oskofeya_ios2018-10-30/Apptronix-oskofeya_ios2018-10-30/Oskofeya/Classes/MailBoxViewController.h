#import <UIKit/UIKit.h>
#import "MsgViewController.h"
#import "EktebLanaViewController.h"

@protocol MailBoxViewDelegate;

@interface MailBoxViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MsgViewDelegate> {
    MsgViewController *msgViewController;
    EktebLanaViewController *ektebLanaViewController;
    IBOutlet UITableView *mailBoxTableView;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    IBOutlet UIButton *btn_send;
}

@property (nonatomic, retain) id <MailBoxViewDelegate> mailBoxViewDelegate;
@property (retain, nonatomic) NSMutableOrderedSet *mailBoxMessages;
@property (assign, nonatomic) BOOL shouldHideActivityIndicator;

- (void)updateView;

@end

@protocol MailBoxViewDelegate <NSObject>
@optional
- (void)mailBoxViewController:(MailBoxViewController *)mailBoxViewController;

@end

