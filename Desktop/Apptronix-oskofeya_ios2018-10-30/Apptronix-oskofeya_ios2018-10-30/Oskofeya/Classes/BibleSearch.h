
#import <UIKit/UIKit.h>

@interface BibleSearch : UIViewController <UITableViewDelegate,UITableViewDataSource> {

    IBOutlet UITableView *prayers_contentTable;
    NSMutableArray *prayers_contentList;
    IBOutlet UIButton *btn_Search;
    IBOutlet UISearchBar *searchtext;
    
    NSArray *filteredArray;
}

@property (retain, nonatomic) NSString *searchTxt;



@end


