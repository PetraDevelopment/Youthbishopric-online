#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KenystakWebService.h"
#import "CFWObject.h"
#import "DateIndexObject.h"
#import "SoundCloudWebService.h"

@interface BekenystakViewController : UIViewController <KenystakWsDelegate,SoundCloudWsDelegate> {
    KenystakWebService *kenystakWebService;
    SoundCloudWebService *soundCloudWebService;
    IBOutlet UIButton *btnCopy;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnWhtsp;
    IBOutlet UILabel *bekenystakTitle;
    UITextView *bekenystakSubject;
    UIView *bekenystakSubjectOverlay;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *kenystakMessages;
    NSMutableDictionary *displayedMessage;
    int todayMsgIndex;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    IBOutlet UIButton *iconPlayPauseTrack;
    AVAudioPlayer *scAudioPlayer;
    NSString *scAudioPlayerStatus;
    NSData *scTrackData;
    float fontSize;
    
    IBOutlet UIButton *btnShare;
}

@end


