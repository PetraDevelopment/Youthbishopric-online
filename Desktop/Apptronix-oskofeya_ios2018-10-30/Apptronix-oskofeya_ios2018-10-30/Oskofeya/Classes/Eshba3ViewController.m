#import "Eshba3ViewController.h"
#import "AppDelegate.h"

@implementation Eshba3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"إشبع", @"إشبع");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize ViewControllers
    be2engylakViewController = [[Be2engylakViewController alloc] initWithNibName:@"Be2engylakView_i5" bundle:nil];
    bekenystakViewController = [[BekenystakViewController alloc] initWithNibName:@"BekenystakView_i5" bundle:nil];
    belma3refaViewController = [[Belma3refaViewController alloc] initWithNibName:@"Belma3refaView_i5" bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    // Navigate to Be2engylakView
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadBe2engylakView) {
        ((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadBe2engylakView = NO;
        [self.navigationController pushViewController:be2engylakViewController animated:NO];
    }
}

#pragma mark - Buttons Methods

- (IBAction)loadBe2engylakView:(id)sender {
    be2engylakViewController.todayMsgIndex = 1000;
    [self showViewController:be2engylakViewController];
    [self performSelector:@selector(pushViewController:) withObject:be2engylakViewController afterDelay:0.5f];
}

- (IBAction)loadBekenystakView:(id)sender {
    [self showViewController:bekenystakViewController];
    [self performSelector:@selector(pushViewController:) withObject:bekenystakViewController afterDelay:0.5f];
}

- (IBAction)loadBelma3refaView:(id)sender {
    belma3refaViewController.todayMsgIndex = 1000;
    [self showViewController:belma3refaViewController];
    [self performSelector:@selector(pushViewController:) withObject:belma3refaViewController afterDelay:0.5f];
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

- (IBAction)dismissEshba3View:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


