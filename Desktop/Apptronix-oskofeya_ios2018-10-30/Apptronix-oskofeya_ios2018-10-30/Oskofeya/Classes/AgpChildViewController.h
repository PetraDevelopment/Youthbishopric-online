#import <UIKit/UIKit.h>
#import "CFWObject.h"

@protocol AgpChildDelegate;

@interface AgpChildViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *agpeyaTableView;
    IBOutlet UIButton *gotoButton;
    NSData *mediaData;
}

@property (nonatomic, retain) id <AgpChildDelegate> agpChildDelegate;
@property (assign, nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableDictionary *displayedPrayer;
@property (assign, nonatomic) BOOL showTableView;
@property (assign, nonatomic) int fontSize;
@property (nonatomic, strong) UIImageView *e7fazMedia;

@end

@protocol AgpChildDelegate <NSObject>
@optional
- (void)agpChildViewController:(AgpChildViewController *)agpChildViewController loadAudioTrackWithURL:(NSString *)scAudioTrackURL;
- (void)agpChildViewController:(AgpChildViewController *)agpChildViewController gotoPageViewModification:(NSString *)gotoPage andSetPageIndex:(NSInteger)pageIndex;
- (void)agpChildViewControllerResetViewModification:(AgpChildViewController *)agpChildViewController;
- (void)agpChildViewController:(AgpChildViewController *)agpChildViewController gotoView:(NSString *)gotoView;

@end


