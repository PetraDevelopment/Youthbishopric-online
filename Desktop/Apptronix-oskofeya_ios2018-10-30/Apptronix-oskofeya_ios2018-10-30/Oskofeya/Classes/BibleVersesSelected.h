#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "BibleChapters.h"

@interface BibleVersesSelected : UIViewController <UITableViewDelegate,UITableViewDataSource> {

    IBOutlet UITableView *prayers_contentTable;
    NSMutableArray *prayers_contentList;
    sqlite3 *contactDB;
    BibleChapters *BibleChaptersController;
}

@property (retain, nonatomic) NSString *contentid;



@end


