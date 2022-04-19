#import <UIKit/UIKit.h>
#import "agpyalistSalwat.h"

@interface agpyalist : UIViewController <UITableViewDelegate,UITableViewDataSource> {

    IBOutlet UITableView *prayersNamesTable;
    NSMutableArray *prayers_namesList;
    agpyalistSalwat *agpyalistSalwatView;
}

@end


