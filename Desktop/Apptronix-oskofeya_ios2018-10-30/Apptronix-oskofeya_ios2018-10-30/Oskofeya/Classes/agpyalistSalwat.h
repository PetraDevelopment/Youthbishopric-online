
#import <UIKit/UIKit.h>
#import "AgpeyaPrayerView.h"

@interface agpyalistSalwat : UIViewController <UITableViewDelegate,UITableViewDataSource> {

    IBOutlet UITableView *prayers_contentTable;
    NSMutableArray *prayers_contentList;
    IBOutlet UILabel *lblHeader;
    AgpeyaPrayerView *agpeyaViewController;
}

@property (retain, nonatomic) NSString *contentid;
@property (retain, nonatomic) NSString *contentName;


@end


