#import "BibleViewController.h"
#import "AppDelegate.h"
#import "FMDB.h"

@implementation BibleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"الكتاب المقدس", @"الكتاب المقدس");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[btn_Search layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[btn_Search layer] setBorderWidth:.4];
    [[btn_Search layer] setCornerRadius:8.0f];
    [self createDatabase];
    //[self saveData];
   // [self readFromDatabase];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // add the button to the main view
    UIButton *overlayButton = [[UIButton alloc] initWithFrame:self.view.frame];
    
    // set the background to black and have some transparency
    overlayButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
    
    // add an event listener to the button
    [overlayButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    
    // add to main view
    [self.view addSubview:overlayButton];
}

- (void)hideKeyboard:(UIButton *)sender
{
    // hide the keyboard
    [searchtext resignFirstResponder];
    // remove the overlay button
    [sender removeFromSuperview];
}

-(void)createDatabase
{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
   NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"oskofiacomment.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = " CREATE TABLE IF NOT EXISTS verse_comment (`vc_id`    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,`vc_book_id`    INTEGER, `vc_chapter_id`    INTEGER,`vc_verse_id`    INTEGER,`vc_comment`    TEXT, `vc_color`    TEXT )";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
               NSLog(@"Failed to create table");
            }
            
            sqlite3_close(contactDB);
            
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldReturnToAgpeyaViewFromWNView) {
        [self.navigationController pushViewController:BibleNewListViewController animated:NO];
    }
}
- (IBAction)searchEvent:(id)sender {
     searchTextStr = searchtext.text;
    if(![searchTextStr  isEqual: @""])
    {
        BibleSearchViewController = [[BibleSearch alloc] initWithNibName:@"BibleSearchView" bundle:nil];
        BibleSearchViewController.searchTxt = searchtext.text;
        [self showViewController:BibleSearchViewController];
        [self performSelector:@selector(pushViewController:) withObject:BibleSearchViewController afterDelay:0.5f];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"من فضلك أدخل النص" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];

    }
}

#pragma mark - Buttons Methods

- (IBAction)load_old:(id)sender {
    BibleNewListViewController = [[BibleNewList alloc] initWithNibName:@"BibleNewListView" bundle:nil];
    BibleNewListViewController.contentid = @"1";
    [self showViewController:BibleNewListViewController];
    [self performSelector:@selector(pushViewController:) withObject:BibleNewListViewController afterDelay:0.5f];
}

- (IBAction)load_new:(id)sender {
    BibleNewListViewController = [[BibleNewList alloc] initWithNibName:@"BibleNewListView" bundle:nil];
    BibleNewListViewController.contentid = @"2";
    [self showViewController:BibleNewListViewController];
    [self performSelector:@selector(pushViewController:) withObject:BibleNewListViewController afterDelay:0.5f];
}
- (IBAction)load_verses:(id)sender {
    BibleVersesSelectedController = [[BibleVersesSelected alloc] initWithNibName:@"BibleVersesSelectedView" bundle:nil];
    [self showViewController:BibleVersesSelectedController];
    [self performSelector:@selector(pushViewController:) withObject:BibleVersesSelectedController afterDelay:0.5f];
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

@end


