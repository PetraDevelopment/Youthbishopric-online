#import <UIKit/UIKit.h>
#import "AgePickerViewController.h"
#import "RegistrationWebService.h"

@interface RegistrationViewController : UIViewController <UITextFieldDelegate,UIActionSheetDelegate,RegistrationWsDelegate> {
    RegistrationWebService *registrationWebService;
    IBOutlet UITextField *textUserName;
    IBOutlet UITextField *textEmail;
    IBOutlet UITextField *textPassword;
    IBOutlet UITextField *textConfPass;
    NSString *confPassStr;
    IBOutlet UIButton *ageGroupsButton;
    IBOutlet UIButton *registerButton;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    UIActionSheet *actionSheet;
    CGFloat viewScrollAmount;
    BOOL moveViewUp;
    AgePickerViewController *agePickerViewController;
    UIView *agePickerView;
    int selectedAgeInt;
}

@property (retain, nonatomic) NSString *loginFlag;
@property (retain, nonatomic) NSString *usernameStr;
@property (retain, nonatomic) NSString *passwordStr;
@property (retain, nonatomic) NSString *emailStr;
@property (assign, nonatomic) BOOL throughFbFlag;

@end


