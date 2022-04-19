#import <UIKit/UIKit.h>
#import "PostNoteWebService.h"

@interface WriteNoteViewController : UIViewController <UITextViewDelegate,PostNoteWsDelegate,UIActionSheetDelegate> {
    PostNoteWebService *postNoteWebService;
    IBOutlet UITextView *writeNoteTextView;
    IBOutlet UIButton *writeNoteSaveButton;
    NSString *writeNoteMessageStr;
    CGFloat viewScrollAmount;
    BOOL moveViewUp;
    UIViewController *keyboardViewController;
    UIActionSheet *actionSheet;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSDictionary *infoDictionary;
}

@end


