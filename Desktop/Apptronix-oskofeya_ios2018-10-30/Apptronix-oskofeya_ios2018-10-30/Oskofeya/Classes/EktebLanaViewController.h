#import <UIKit/UIKit.h>
#import "SubjectPickerViewController.h"
#import "EktebLanaWebService.h"

@interface EktebLanaViewController : UIViewController <UITextViewDelegate,EktebLanaWsDelegate,UIActionSheetDelegate> {
    EktebLanaWebService *ektebLanaWebService;
    IBOutlet UITextView *ektebLanaTextView;
    IBOutlet UIButton *ektebLanaSubjectButton;
    IBOutlet UIButton *ektebLanaSendButton;
    NSString *ektebLanaMessageStr;
    CGFloat viewScrollAmount;
    BOOL moveViewUp;
    UIViewController *keyboardViewController;
    SubjectPickerViewController *subjectPickerViewController;
    UIView *subjectPickerView;
    UIActionSheet *actionSheet;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSDictionary *infoDictionary;
}

@end


