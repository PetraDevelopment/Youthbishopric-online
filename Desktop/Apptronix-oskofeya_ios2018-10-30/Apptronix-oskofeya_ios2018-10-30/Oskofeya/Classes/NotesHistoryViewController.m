#import "NotesHistoryViewController.h"
#import "AppDelegate.h"

#define ROW_HEIGHT 40

@implementation NotesHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"تأملاتى", @"تأملاتى");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize writeNoteViewController
    writeNoteViewController = [[WriteNoteViewController alloc] initWithNibName:@"WriteNoteView_i5" bundle:nil];
    // Initialize readNoteViewController
    readNoteViewController = [[ReadNoteViewController alloc] initWithNibName:@"ReadNoteView_i5" bundle:nil];
    // Initialize notesWebService
    notesWebService = [[NotesWebService alloc] init];
    [notesWebService setNotesWsDelegate:self];
    // Initialize notesHistoryList
    notesHistoryList = [[NSMutableArray alloc] initWithObjects:nil];
    [self setupView];
}

- (void)setupView {
    // Set the notesHistoryTable
    notesHistoryTable.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    // Get notesMessages
    [notesWebService getNotesMessages];
    // Show Activity Indicator
    [self showActivityIndicatorWithMessage:@"جاري التحـمـيل"];
    // Navigate to WriteNoteView
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadWriteNoteView) {
        [self.navigationController pushViewController:writeNoteViewController animated:NO];
    }
    // Navigate back to AgpeyaView
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldReturnToAgpeyaViewFromWNView) {
        [self dismissNotesHistoryView:nil];
    }
}

#pragma mark - notesMessages Handling Methods

- (void)notesWebService:(NotesWebService *)notesWebService errorMessage:(NSString *)errorMsg {
    // Display Error Message
    [self showActivityIndicatorWithMessage:@"برجاء التأكد من الاتصال بالانترنت"];
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
}

- (void)notesWebService:(NotesWebService *)notesWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    // Clear notesHistoryList
    [notesHistoryList removeAllObjects];
    notesMessages = returnMsgs;
    NSMutableDictionary *tempMutableDict = [[NSMutableDictionary alloc] init];
    if ([notesMessages count] == 0) {
        [tempMutableDict setObject:@"لا يوجد لديك تأملات محفوظة" forKey:@"title"]; // @"You have no saved notes"
        [tempMutableDict setObject:@"لا يوجد لديك تأملات محفوظة" forKey:@"body"];
        [tempMutableDict setObject:@"----------" forKey:@"send_date"];
        [notesHistoryList addObject:tempMutableDict];
    } else {
        // Load notesHistoryList
        int index = 0;
        for (__unused NSDictionary *tempDict in notesMessages) {
            [tempMutableDict setObject:[self extractTitleFromNoteWithIndex:index] forKey:@"title"];
            [tempMutableDict setObject:[[notesMessages objectAtIndex:index] objectForKey:@"body"] forKey:@"body"];
            [tempMutableDict setObject:[[notesMessages objectAtIndex:index] objectForKey:@"send_date"] forKey:@"send_date"];
            [tempMutableDict setObject:[[notesMessages objectAtIndex:index] objectForKey:@"id"] forKey:@"id"];
            [notesHistoryList addObject:[tempMutableDict mutableCopy]];
            index ++;
        }
    }
    [notesHistoryTable reloadData];
}

- (NSString *)extractTitleFromNoteWithIndex:(int)index {
    // Extract first line from Notes body
    NSString *noteTitleStr = [[notesMessages objectAtIndex:index] objectForKey:@"body"];
    if ([noteTitleStr length] > 15) {
        noteTitleStr = [noteTitleStr substringToIndex:15];
    }
    return noteTitleStr;
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [notesHistoryList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@\n%@\t\t\t\t\t\t\t\t",[[notesHistoryList objectAtIndex:indexPath.row] objectForKey:@"title"],[[notesHistoryList objectAtIndex:indexPath.row] objectForKey:@"send_date"]]];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.borderWidth = 1.2;
    cell.layer.cornerRadius = 10;

    cell.clipsToBounds = true;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    readNoteViewController.noteTitleStr = [[notesHistoryList objectAtIndex:indexPath.row] objectForKey:@"title"];
    readNoteViewController.noteBodyStr = [[notesHistoryList objectAtIndex:indexPath.row] objectForKey:@"body"];
    [self showViewController:readNoteViewController];
    [self performSelector:@selector(pushViewController:) withObject:readNoteViewController afterDelay:0.5f];

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [aiMsg setText:@""]; // @"Deleting note"
        aiView.hidden = NO;
        // Extract noteID
        NSString *noteID = [NSString stringWithFormat:@"%@",[[notesHistoryList objectAtIndex:indexPath.row] objectForKey:@"id"]];
        // Initialize deleteNoteWebService
        deleteNoteWebService = [[DeleteNoteWebService alloc] init];
        [deleteNoteWebService setDeleteNoteWsDelegate:self];
        [deleteNoteWebService deleteNote:noteID];
    }
    [tableView reloadData];
}

#pragma mark - deleteNoteWebService Handling Methods

- (void)deleteNoteWebService:(DeleteNoteWebService *)deleteNoteWebService errorMessage:(NSString *)errorMsg {
    // Display Error Message
    [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
    [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الاتصال بالانترنت",errorMsg]];
    aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    aiMsg.numberOfLines = 4;
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
}

- (void)deleteNoteWebService:(DeleteNoteWebService *)deleteNoteWebService returnMessage:(NSDictionary *)returnMsg {
    NSLog(@"returnMsg: %@",returnMsg);
    if ([returnMsg objectForKey:@"success"] == [NSNumber numberWithBool:YES]) {
        // Note deleted
        [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
        [aiMsg setText:@"تم حذف التأمل"]; // @"The note was deleted"
        aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
        aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
        aiMsg.numberOfLines = 4;
        [self performSelector:@selector(updateNotesFromBackend) withObject:nil afterDelay:3.0f];
    } else {
        // Note not deleted
        [aiMsg setText:@"لم يتم حذف التأمل \nبرجاء المحاولة مرة أخرى"]; // @"The note was not deleted. \nPlease try again"
        [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:3.0f];
    }
}

- (void)updateNotesFromBackend {
    // Get notesMessages
    [notesWebService getNotesMessages];
}

#pragma mark - Buttons Methods

- (IBAction)loadWriteNoteView:(id)sender {
    [self showViewController:writeNoteViewController];
    [self performSelector:@selector(pushViewController:) withObject:writeNoteViewController afterDelay:0.5f];
}

#pragma mark - View Loading Methods

- (void)showViewController:(UIViewController *)viewController {
    viewController.view.frame = [[UIScreen mainScreen] bounds];
    [viewController.view setAlpha:0];
    [self.navigationController.view addSubview:viewController.view];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    viewController.view.alpha = 1;
    [UIView commitAnimations];
}

- (void)pushViewController:(UIViewController *)viewController {
    [viewController.view removeFromSuperview];
    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark - Activity Indicator Methods

- (void)showActivityIndicatorWithMessage:(NSString *)message {
    // Display Message
    aiView.hidden = NO;
    [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
    [aiMsg setText:message];
    aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    aiMsg.numberOfLines = 4;
}

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

#pragma mark - Dismiss Methods

- (IBAction)dismissNotesHistoryView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


