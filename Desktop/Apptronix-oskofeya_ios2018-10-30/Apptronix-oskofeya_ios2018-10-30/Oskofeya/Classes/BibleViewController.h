#import <UIKit/UIKit.h>
#import "BibleNewList.h"
#import "NotesHistoryViewController.h"
#import "DateIndexObject.h"
#import "BibleSearch.h"
#import "sqlite3.h"
#import "BibleVersesSelected.h"

@interface BibleViewController : UIViewController {
    BibleNewList *BibleNewListViewController;
    IBOutlet UIButton *btn_Search;
    IBOutlet UISearchBar *searchtext;
    BibleSearch *BibleSearchViewController;
    BibleVersesSelected *BibleVersesSelectedController;
    UIActionSheet *actionSheet;
    NSMutableArray *contentList;
    NSString *searchTextStr;
    sqlite3 *contactDB;
}

@end


