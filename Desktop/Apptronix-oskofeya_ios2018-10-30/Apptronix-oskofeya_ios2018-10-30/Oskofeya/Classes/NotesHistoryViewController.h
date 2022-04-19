#import <UIKit/UIKit.h>
#import "WriteNoteViewController.h"
#import "ReadNoteViewController.h"
#import "NotesWebService.h"
#import "DeleteNoteWebService.h"

@interface NotesHistoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,NotesWsDelegate,DeleteNoteWsDelegate> {
    WriteNoteViewController *writeNoteViewController;
    ReadNoteViewController *readNoteViewController;
    NotesWebService *notesWebService;
    DeleteNoteWebService *deleteNoteWebService;
    IBOutlet UITableView *notesHistoryTable;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *notesMessages;
    NSMutableArray *notesHistoryList;
}

@end


