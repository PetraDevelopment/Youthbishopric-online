#import <UIKit/UIKit.h>
#import "CFWObject.h"

@protocol B2kChildDelegate;

@interface B2kChildViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *be2engylakTableView;
    NSData *mediaData;
}

@property (nonatomic, retain) id <B2kChildDelegate> b2kChildDelegate;
@property (assign, nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableDictionary *displayedMessage;
@property (assign, nonatomic) int todayMsgIndex;
@property (assign, nonatomic) BOOL showTableView;
@property (assign, nonatomic) int fontSize;
@property (nonatomic, strong) UIImageView *e7fazMedia;

@end

@protocol B2kChildDelegate <NSObject>
@optional
- (void)b2kChildViewController:(B2kChildViewController *)b2kChildViewController hideCFW_Buttons:(BOOL)hideOrShow withPageIndex:(NSInteger)pageIndex;

@end


