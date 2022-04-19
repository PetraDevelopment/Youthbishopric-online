#import <UIKit/UIKit.h>

@protocol MsgViewDelegate;

@interface MsgViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UILabel *msgTitleLabel;
    IBOutlet UITableView *msgTableView;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    float fontSize;
}

@property (nonatomic, retain) id <MsgViewDelegate> msgViewDelegate;
@property (assign, nonatomic) int msgIndexPathRow;
@property (retain, nonatomic) NSString *msgTitleStr;
@property (retain, nonatomic) NSString *msgSubjectStr;
@property (retain, nonatomic) NSString *msgMedia;

@end

@protocol MsgViewDelegate <NSObject>
@optional
- (void)msgViewController:(MsgViewController *)msgViewController deleteMsgWithIndexPathRow:(int)indexPathRow;

@end


