
#import <UIKit/UIKit.h>
#import "BibleChapters.h"

@interface BibleNewList : UIViewController <UITableViewDelegate,UITableViewDataSource> {

    IBOutlet UITableView *prayers_contentTable;
    NSMutableArray *prayers_contentList;
    NSMutableArray *chapters;
    BibleChapters *BibleChaptersController;
    IBOutlet UIButton *btn_Header;
    IBOutlet UITableView *tableChapters;
    NSString *selectedbook;
    NSMutableArray *bookMarkList;
    
    NSString *xmlString;
    NSString *chapterIdMark;
    NSString *bookIdMark;
    
    
    NSString *newxmlString;
    NSString *newchapterIdMark;
    NSString *newbookIdMark;
    IBOutlet UILabel *bookHeader;
    
}

@property (retain, nonatomic) NSString *contentid;



@end


