#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LoginViewController.h"
#import "MainViewController.h"
#import "SidebarMenuViewController.h"
#import "AgpeyaViewController.h"
#import "MoreViewController.h"
#import "BibleViewController.h"
#import "agpyalist.h"
#import "MailBoxViewController.h"
#import "MailBoxWebService.h"

@interface SplashViewController : UIViewController <LoginViewDelegate,MailBoxViewDelegate,MailBoxWsDelegate> {
    MPMoviePlayerController *moviePlayerController;
    LoginViewController *loginViewController ;
    BOOL moviePlaying;
    MailBoxViewController *mailBoxViewController;
    MailBoxWebService *mailBoxWebService;
}

@end


