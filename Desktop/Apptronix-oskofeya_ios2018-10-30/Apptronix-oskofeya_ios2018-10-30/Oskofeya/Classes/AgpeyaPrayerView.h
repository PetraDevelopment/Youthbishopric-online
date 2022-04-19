#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AgpPrayerChildViewControlle.h"

@interface AgpeyaPrayerView : UIViewController <UIPageViewControllerDataSource,AgpPrayerChildViewControlleDelegate> {
    AgpPrayerChildViewControlle *agpChildViewController;
    UIPageViewController *pageController;
    NSMutableDictionary *displayedMessage;
    BOOL showTableViewLastState;
    float fontSize;
    NSInteger currentPageIndex;
    UIDocumentInteractionController *documentInteractionController;
    int numberofPagesInView;

}

@property (retain, nonatomic) NSString *bookid2;
@property (assign, nonatomic) NSInteger pageind;
@end


