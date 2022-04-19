#import <UIKit/UIKit.h>
#import "DateIndexObject.h"
#import "BibleChildViewController.h"

@interface BibleChapters : UIViewController <UIPageViewControllerDataSource, BibleChildViewControllerDelegate> {
  
    BibleChildViewController *b2kChildViewController;

 
    UIPageViewController *pageController;
    NSMutableDictionary *displayedMessage;
    BOOL showTableViewLastState;
    float fontSize;
    NSInteger currentPageIndex;
    UIDocumentInteractionController *documentInteractionController;
    int numberofPagesInView;
    IBOutlet UIButton *BookMark;
    int bookmarkvalue;
    NSString *xmlString;
    NSString *chapterid;
}
@property (retain, nonatomic) NSString *bookid2;
@property (assign, nonatomic) NSInteger pageind;
@end


