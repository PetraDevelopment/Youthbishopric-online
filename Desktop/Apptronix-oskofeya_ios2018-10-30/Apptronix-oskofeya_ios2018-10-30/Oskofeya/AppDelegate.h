
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "SplashViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIActionSheetDelegate> {
    SplashViewController *splashViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSession *fbSession;
@property (assign, nonatomic) BOOL shouldLoadEttamenView;
@property (retain, nonatomic) NSData *devicePushToken;
@property (retain, nonatomic) NSMutableDictionary *pushNotifInfo;
@property (assign, nonatomic) BOOL shouldLoadWriteNoteView;
@property (assign, nonatomic) BOOL shouldLoadBe2engylakView;
@property (assign, nonatomic) BOOL shouldReturnToAgpeyaViewFromWNView;

+ (void)showAlertView:(NSString *)message;

@end


