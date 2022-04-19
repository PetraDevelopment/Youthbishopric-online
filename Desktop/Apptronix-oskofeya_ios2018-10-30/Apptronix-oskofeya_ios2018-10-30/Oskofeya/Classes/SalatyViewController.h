#import <UIKit/UIKit.h>
#import "AgpeyaViewController.h"
#import "NotesHistoryViewController.h"
#import "DateIndexObject.h"

@interface SalatyViewController : UIViewController {
    AgpeyaViewController *agpeyaViewController;
    NotesHistoryViewController *notesHistoryViewController;
    IBOutlet UIButton *agpeyaButton;
    IBOutlet UILabel *lblAgpeya;
}

@end


