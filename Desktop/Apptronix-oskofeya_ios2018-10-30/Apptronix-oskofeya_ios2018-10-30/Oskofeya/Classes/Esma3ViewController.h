#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Esma3HistoryViewController.h"
#import "Esma3WebService.h"
#import "CFWObject.h"
#import "DateIndexObject.h"
#import "SoundCloudWebService.h"

@interface Esma3ViewController : UIViewController <Esma3HistoryDelegate,Esma3WsDelegate,SoundCloudWsDelegate> {
    Esma3HistoryViewController *esma3HistoryViewController;
    Esma3WebService *esma3WebService;
    SoundCloudWebService *soundCloudWebService;
    IBOutlet UIButton *btnCopy;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnWhtsp;
    IBOutlet UILabel *esma3Title;
    UITextView *esma3Subject;
    UIView *esma3SubjectOverlay;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *esma3Messages;
    NSMutableDictionary *displayedMessage;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    IBOutlet UIButton *iconPlayPauseTrack;
    AVAudioPlayer *scAudioPlayer;
    NSString *scAudioPlayerStatus;
    NSData *scTrackData;
    float fontSize;
    
    IBOutlet UIButton *btnShare;
}

@property (assign, nonatomic) int todayMsgIndex;

@end


