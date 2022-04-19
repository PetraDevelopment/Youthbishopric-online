#import "SalatyViewController.h"
#import "AppDelegate.h"

@implementation SalatyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"صلاتى", @"صلاتى");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize ViewControllers
    agpeyaViewController = [[AgpeyaViewController alloc] initWithNibName:@"AgpeyaView_i5" bundle:nil];
    notesHistoryViewController = [[NotesHistoryViewController alloc] initWithNibName:@"NotesHistoryView_i5" bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self displayPrayerName];
    // Navigate to Be2engylakView
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadBe2engylakView) {
        [self dismissSalatyView:nil];
    }
    // Navigate to WriteNoteView
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadWriteNoteView) {
        [self.navigationController pushViewController:notesHistoryViewController animated:NO];
    }
    // Navigate back to AgpeyaView
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldReturnToAgpeyaViewFromWNView) {
        [self.navigationController pushViewController:agpeyaViewController animated:NO];
    }
}

- (void)displayPrayerName {
    // Extract Prayer Name
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    agpeyaViewController.prayerNameFlag = [dateIndexObject extractPrayerName];
   if ([agpeyaViewController.prayerNameFlag isEqualToString:@"Prime"]) {
        lblAgpeya.text = @"علمنى أصلى باكر";
    } else if ([agpeyaViewController.prayerNameFlag isEqualToString:@"Vespers"]) {
         lblAgpeya.text = @"علمنى أصلى غروب";
    } else if ([agpeyaViewController.prayerNameFlag isEqualToString:@"Compline"]) {
        lblAgpeya.text = @"علمنى أصلى نوم";
    }
}

#pragma mark - Buttons Methods

- (IBAction)loadAgpeyaView:(id)sender {
    [self showViewController:agpeyaViewController];
    [self performSelector:@selector(pushViewController:) withObject:agpeyaViewController afterDelay:0.5f];
}

- (IBAction)loadNotesHistoryView:(id)sender {
    [self showViewController:notesHistoryViewController];
    [self performSelector:@selector(pushViewController:) withObject:notesHistoryViewController afterDelay:0.5f];
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

#pragma mark - Dismiss Method

- (IBAction)dismissSalatyView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


