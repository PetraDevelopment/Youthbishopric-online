#import <UIKit/UIKit.h>
#import "EttamenMsgViewController.h"
#import "EttamenWebService.h"
#import <UserNotifications/UserNotifications.h>

@interface EttamenViewController : UIViewController <EttamenWebServiceDelegate> {
    EttamenMsgViewController *ettamenMsgViewController;
    EttamenWebService *ettamenWebService;
    IBOutlet UIButton *feelingFace1;
    IBOutlet UIButton *feelingFace2;
    IBOutlet UIButton *feelingFace3;
    IBOutlet UIButton *feelingFace4;
    IBOutlet UIButton *feelingFace5;
    IBOutlet UIButton *feelingFace6;
    IBOutlet UIButton *feelingFace7;
    IBOutlet UIButton *feelingFace8;
    NSArray *ettamenFeelingsNames;
    NSMutableArray *ettamenMessages;
    NSMutableArray *ettamenFeelingMsgs;
    int previousRandomNumber;
}

@end


