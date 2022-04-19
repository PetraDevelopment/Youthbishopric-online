#import "MoreViewController.h"
#import "AppDelegate.h"

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"تواصل معنا", @"تواصل معنا");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize aboutViewController
    aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutView_i5" bundle:nil];
    [[txtData layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[txtData layer] setBorderWidth:.4];
    [[txtData layer] setCornerRadius:8.0f];
}

#pragma mark - Buttons Methods

- (IBAction)openFacebookPage:(id)sender { 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/youthbishopriconline?"]];
}

- (IBAction)openTwitterPage:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/YomByom"]];
}

- (IBAction)loadAboutView:(id)sender {
    [self showViewController:aboutViewController];
    [self performSelector:@selector(pushViewController:) withObject:aboutViewController afterDelay:0.5f];
}

- (IBAction)openApptronixPage {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.app-tronix.com"]];
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

- (IBAction)dismissMoreView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


