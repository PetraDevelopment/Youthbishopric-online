#import "SplashViewController.h"
#import "AppDelegate.h"

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Splash View", @"Splash View");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    moviePlaying = YES;
    // Initialize loginViewController
    loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView_i5" bundle:nil];

    [loginViewController setLoginViewDelegate:self];
    loginViewController.loginFlag = @"showLogin";
    
    // play the Movie
    [self prepareMovie];
    [moviePlayerController play];
    
    mailBoxViewController = [[MailBoxViewController alloc] initWithNibName:@"MailBoxView_i5" bundle:nil];
    [mailBoxViewController setMailBoxViewDelegate:self];
      // Initialize mailBoxWebService
    mailBoxWebService = [[MailBoxWebService alloc] init];
    [mailBoxWebService setMailBoxWsDelegate:self];
    // Update Device Push Token
    NSString *deviceToken;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).devicePushToken) {
        deviceToken = [NSString stringWithFormat:@"%@",((AppDelegate *)[UIApplication sharedApplication].delegate).devicePushToken];
        deviceToken = [[deviceToken componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" <>"]] componentsJoinedByString:@""];
    }
    // Get mailBoxMessages
    [mailBoxWebService getMailBoxMessages];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).pushNotifInfo) {
        if ([[[((AppDelegate *)[UIApplication sharedApplication].delegate).pushNotifInfo objectForKey:@"aps"] objectForKey:@"module"] isEqualToString:@"Mailbox"]) {
            // Get mailBoxMessages
            [mailBoxWebService getMailBoxMessages];
            mailBoxViewController.shouldHideActivityIndicator = NO;
            [mailBoxViewController updateView];
            // Navigate to MailboxView
            [self.navigationController pushViewController:mailBoxViewController animated:NO];
            // Clear the Push Notification Message
            ((AppDelegate *)[UIApplication sharedApplication].delegate).pushNotifInfo = nil;
        }
    }
    // Check for Unread Messages
    [self checkForUnreadMailboxMessages];
}





- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

#pragma mark - MoviePlayer Methods

- (void)prepareMovie {
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"SplashMovie" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
   // [moviePlayerController.view setFrame:self.view.frame];
    [moviePlayerController.view setFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]))];
    [self.view addSubview:moviePlayerController.view];
    moviePlayerController.controlStyle = MPMovieControlStyleNone;
    [moviePlayerController prepareToPlay];
}

- (void)playbackStateChanged {
    if (moviePlaying) {
        if (moviePlayerController.playbackState == MPMoviePlaybackStatePaused) {
            moviePlaying = NO;
            // Insert delay for devices that don't show the movie
            [self performSelector:@selector(checkLoginFlagStatus) withObject:nil afterDelay:0.5f];
        }
    }
}

#pragma mark - View Loading Methods

- (void)checkLoginFlagStatus {
    if (!moviePlaying) {
        // Loading loginFlag from UserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"loginFlag"] != NULL) {
            loginViewController.loginFlag = [defaults objectForKey:@"loginFlag"];
        }
        NSLog(@"loginFlag = %@",loginViewController.loginFlag);
        if ([loginViewController.loginFlag isEqual:@"showLogin"]) {
            [self showViewController:loginViewController];
            [self performSelector:@selector(pushViewController:) withObject:loginViewController afterDelay:0.5f];
        }
        else
        {

            SidebarMenuViewController *sidebarMenuVC = [[SidebarMenuViewController alloc] initWithNibName:@"SidebarMenuViewController" bundle:nil];
            MainViewController *mainform = [[MainViewController alloc] initWithNibName:@"NewMainView_i5" bundle:nil];
            agpyalist *agpyalistAVC = [[agpyalist alloc] initWithNibName:@"agpyalistView_i5" bundle:nil];
            BibleViewController *BibleViewControllerVC = [[BibleViewController alloc] initWithNibName:@"BibleView" bundle:nil];
            MoreViewController *MoreViewControllerAVC = [[MoreViewController alloc] initWithNibName:@"MoreView_i5" bundle:nil];
            sidebarMenuVC.menuItemViewControllers = [NSArray arrayWithObjects:mainform, agpyalistAVC,BibleViewControllerVC,mailBoxViewController,MoreViewControllerAVC, nil];
            sidebarMenuVC.menuItemNames = [NSArray arrayWithObjects:@"أسقفية الشباب", @"الأجبية المقدسة",@"الكتاب المقدس" ,@"صندوق الوارد" ,@"المزيد" , nil];
            sidebarMenuVC.sideBarButtonImageName = @"menu-button";
            [self showViewController:sidebarMenuVC];
            [sidebarMenuVC.view removeFromSuperview];
            [self.navigationController pushViewController:sidebarMenuVC animated:NO];
        }
    }
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

#pragma mark - LoginView Delegate Method

- (void)loginViewController:(LoginViewController *)viewController setLoginFlag:(NSString *)loginFlag {
    // Login & Registration Ended
    loginViewController.loginFlag = loginFlag;
    // Updating loginFlag
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[loginViewController.loginFlag mutableCopy] forKey:@"loginFlag"];
    [defaults synchronize];
    // Set shouldEnableFeelings Flag (1st Usage)
    [defaults setBool:YES forKey:@"shouldEnableFeelings"];
    [defaults synchronize];
    SidebarMenuViewController *sidebarMenuVC = [[SidebarMenuViewController alloc] initWithNibName:@"SidebarMenuViewController" bundle:nil];
    MainViewController *mainform = [[MainViewController alloc] initWithNibName:@"NewMainView_i5" bundle:nil];
    agpyalist *agpyalistAVC = [[agpyalist alloc] initWithNibName:@"agpyalistView_i5" bundle:nil];
    BibleViewController *BibleViewControllerVC = [[BibleViewController alloc] initWithNibName:@"BibleView" bundle:nil];
    MoreViewController *MoreViewControllerAVC = [[MoreViewController alloc] initWithNibName:@"MoreView_i5" bundle:nil];
    sidebarMenuVC.menuItemViewControllers = [NSArray arrayWithObjects:mainform, agpyalistAVC,BibleViewControllerVC,mailBoxViewController,MoreViewControllerAVC, nil];
    sidebarMenuVC.menuItemNames = [NSArray arrayWithObjects:@"أسقفية الشباب", @"الأجبية المقدسة",@"الكتاب المقدس" ,@"صندوق الوارد" ,@"المزيد" , nil];
    sidebarMenuVC.sideBarButtonImageName = @"menu-button";
    [self showViewController:sidebarMenuVC];
    [sidebarMenuVC.view removeFromSuperview];
    [self performSelector:@selector(pushViewController:) withObject:sidebarMenuVC afterDelay:0.5f];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




#pragma mark - mailBoxMessages Handling Methods

- (void)mailBoxWebService:(MailBoxWebService *)mailBoxWebService errorMessage:(NSString *)errorMsg {
    // Load mailBoxMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"mailBoxMessages"] != NULL) {
        mailBoxViewController.mailBoxMessages = [NSMutableOrderedSet orderedSetWithArray:[defaults objectForKey:@"mailBoxMessages"]];
        // Hide Activity Indicator in MailboxView
        mailBoxViewController.shouldHideActivityIndicator = YES;
        [mailBoxViewController updateView];
        // Check for Unread Messages
        [self checkForUnreadMailboxMessages];
    } else {
        // Show Activity Indicator in MailboxView (No Internet)
        mailBoxViewController.shouldHideActivityIndicator = NO;
        [mailBoxViewController updateView];
    }
}

- (void)mailBoxWebService:(MailBoxWebService *)mailBoxWebService returnMessages:(NSMutableArray *)returnMsgs {
    // Load mailBoxMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"mailBoxMessages"] != NULL) {
        mailBoxViewController.mailBoxMessages = [NSMutableOrderedSet orderedSetWithArray:[defaults objectForKey:@"mailBoxMessages"]];
    }
    // Update mailBoxMessages
    mailBoxViewController.mailBoxMessages = [self updateMailBoxMessages:[[mailBoxViewController.mailBoxMessages array] mutableCopy] fromMessages:returnMsgs];
    // Sort mailBoxMessages accordign to date (descendingly)
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"updated_at" ascending:NO]; // "id"
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameSort];
    mailBoxViewController.mailBoxMessages = [NSMutableOrderedSet orderedSetWithArray:[[mailBoxViewController.mailBoxMessages array] sortedArrayUsingDescriptors:sortDescriptors]];
    // Save updated mailBoxMessages
    NSArray *mailBoxMessagesArray = [mailBoxViewController.mailBoxMessages array];
    NSMutableArray *mailBoxMessagesMutableArray = [mailBoxMessagesArray mutableCopy];
    [defaults setObject:mailBoxMessagesMutableArray forKey:@"mailBoxMessages"];
    [defaults synchronize];
    // Hide Activity Indicator in MailboxView
    mailBoxViewController.shouldHideActivityIndicator = YES;
    [mailBoxViewController updateView];
    // Check for Unread Messages
    [self checkForUnreadMailboxMessages];
}

- (NSMutableOrderedSet *)updateMailBoxMessages:(NSMutableArray *)outputMessages fromMessages:(NSMutableArray *)inputMessages {
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    BOOL keyExists;
    if ([outputMessages count] == 0) {
        outputMessages = [[NSMutableArray alloc] initWithArray:inputMessages];
    } else {
        for (NSDictionary *tempDict in inputMessages) {
            NSMutableDictionary *tempMutableDict = [tempDict mutableCopy];
            NSNumber *keyUnderTest = [tempMutableDict objectForKey:@"id"];
            keyExists = [dateIndexObject isKey:keyUnderTest inMessages:outputMessages];
            if (!keyExists) {
                [outputMessages addObject:[tempMutableDict mutableCopy]];
            }
        }
    }
    return [NSMutableOrderedSet orderedSetWithArray:outputMessages];
}

- (void)checkForUnreadMailboxMessages {
    for (NSDictionary *TempDict in mailBoxViewController.mailBoxMessages) {
        if ([[TempDict objectForKey:@"status"] isEqualToString: @"unread"] && [[TempDict objectForKey:@"visibility"] isEqualToString: @"visible"]) {
           
        }
    }
}

#pragma mark - MailBoxViewDelegate Method

- (void)mailBoxViewController:(MailBoxViewController *)mailBoxViewController {
    // Refresh mailBoxMessages from server
    [mailBoxWebService getMailBoxMessages];
}

@end


