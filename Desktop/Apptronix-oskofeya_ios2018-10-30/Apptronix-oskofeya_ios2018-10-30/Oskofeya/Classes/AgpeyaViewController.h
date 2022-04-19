#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AgpChildViewController.h"
#import "AgpeyaWebService.h"
#import "SoundCloudWebService.h"

@interface AgpeyaViewController : UIViewController <UIPageViewControllerDataSource,AgpChildDelegate,AgpeyaWsDelegate,SoundCloudWsDelegate,UIActionSheetDelegate> {
    AgpChildViewController *agpChildViewController;
    AgpeyaWebService *agpeyaWebService;
    SoundCloudWebService *soundCloudWebService;
    UIPageViewController *pageController;
    int numberofPagesInView;
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableDictionary *agpeyaPrayers;
    BOOL showTableViewLastState;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    float fontSize;
    NSInteger currentPageIndex;
    IBOutlet UIButton *btnPlayPauseTrack;
    AVAudioPlayer *scAudioPlayer;
    NSString *scAudioPlayerStatus;
    NSData *scTrackData;
    NSString *scAudioTrackURL;
    UIActionSheet *actionSheet;
    
}

@property (retain, nonatomic) NSString *prayerNameFlag;

@end


