#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "RegistrationViewController.h"
#import "LoginWebService.h"
#import "ForgotPassWebService.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@protocol LoginViewDelegate;

@interface LoginViewController : UIViewController <UITextFieldDelegate,UIActionSheetDelegate,LoginWebServiceDelegate,ForgotPassWebServiceDelegate,FBLoginViewDelegate> {
    RegistrationViewController *registrationViewController;
    LoginWebService *loginWebService;
    ForgotPassWebService *forgotPassWebService;
    IBOutlet UITextField *textEmail;
    IBOutlet UITextField *textPassword;
    NSString *passwordStr;
    NSString *emailStr;
    BOOL throughFbFlag;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    UIActionSheet *actionSheet;
    
    IBOutlet FBSDKLoginButton *loginButton;
    
}

@property (nonatomic, retain) id <LoginViewDelegate> loginViewDelegate;
@property (retain, nonatomic) NSString *loginFlag;

@end

@protocol LoginViewDelegate <NSObject>
@optional
- (void)loginViewController:(LoginViewController *)loginViewController setLoginFlag:(NSString *)loginFlag;

@end


