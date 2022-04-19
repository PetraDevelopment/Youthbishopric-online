
#import <UIKit/UIKit.h>

@interface ReadNoteViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *noteTableView;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    float fontSize;
}

@property (retain, nonatomic) NSString *noteTitleStr;
@property (retain, nonatomic) NSString *noteBodyStr;

@end


