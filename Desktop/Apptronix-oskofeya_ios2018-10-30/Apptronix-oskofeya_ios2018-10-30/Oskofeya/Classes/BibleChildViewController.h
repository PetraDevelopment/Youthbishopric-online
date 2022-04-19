#import <UIKit/UIKit.h>
#import "CFWObject.h"
#import "sqlite3.h"

@protocol BibleChildViewControllerDelegate;

@interface BibleChildViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *agpeyaTableView;
    NSArray *testArray;
    sqlite3 *contactDB;
    NSInteger Rowselected;
}

@property (nonatomic, retain) id <BibleChildViewControllerDelegate> BibleChildViewControllerDelegate;
@property (assign, nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableDictionary *displayedPrayer;
@property (assign, nonatomic) BOOL showTableView;
@property (assign, nonatomic) int fontSize;
@property (retain, nonatomic) NSString *bookid;

@end

@protocol BibleChildViewControllerDelegate <NSObject>
@optional



@end


