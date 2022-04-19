#import "ShoufViewController.h"

@implementation ShoufViewController

@synthesize todayMsgIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"إتفرج", @"إتفرج");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize shoufHistoryViewController
    shoufHistoryViewController = [[ShoufHistoryViewController alloc] initWithNibName:@"ShoufHistoryView_i5" bundle:nil];
    [shoufHistoryViewController setShoufHistoryDelegate:self];
    // Initialize shoufWebService
    shoufWebService = [[ShoufWebService alloc] init];
    [shoufWebService setShoufWsDelegate:self];
    // Initialize youTubeViewController
    youTubeViewController = [[YouTubeViewController alloc] initWithNibName:@"YouTubeView_i5" bundle:nil];
    // Get Present & Future shoufMessages
    [shoufWebService getShoufMessagesForPresentAndFuture:YES];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (todayMsgIndex == 1000) {
        // Navigating from Estamte3
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromPeriodMessages:shoufMessages andDate:[NSDate date]];
        displayedMessage = [[shoufMessages objectAtIndex:todayMsgIndex] mutableCopy];
        [self updateView];
    }
    [self hideCFWbButtons];
}

- (void)setupView {
    // Set shoufTitle
    shoufTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    shoufTitle.adjustsFontSizeToFitWidth = YES;
    shoufTitle.text = [displayedMessage objectForKey:@"title"];
    // Add shoufSubject
    shoufSubject = [[UITextView alloc] initWithFrame:CGRectMake(19.0, 180.0, 284.0, 200.0)];
    shoufSubject.backgroundColor = [UIColor clearColor];
    shoufSubject.font = [UIFont fontWithName:@"Helvetica" size:15];
    [shoufSubject setTextColor: [UIColor blackColor]];
    [shoufSubject setTextAlignment:NSTextAlignmentRight];
    shoufSubject.editable = NO;
    [self.view addSubview:shoufSubject];
    shoufSubject.text = [displayedMessage objectForKey:@"body"];
    // Add shoufSubjectOverlay
    shoufSubjectOverlay = [[UIView alloc] init];
    if ( shoufSubject.contentSize.height >= shoufSubject.bounds.size.height) {
        [shoufSubjectOverlay setFrame:CGRectMake(0, 0, shoufSubject.contentSize.width, shoufSubject.contentSize.height)];
    } else {
        [shoufSubjectOverlay setFrame:CGRectMake(0, 0, shoufSubject.bounds.size.width, shoufSubject.bounds.size.height)];
    }
    shoufSubjectOverlay.backgroundColor = [UIColor clearColor];
    [shoufSubject addSubview:shoufSubjectOverlay];
    // Add LongPress Handling
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [shoufSubject addGestureRecognizer:longPress];
}

- (void)updateView {
    // Set fontSize
    fontSize = 17.0;
    [self updateTitleAndSubject];
}

- (void)updateTitleAndSubject {
    // Set shoufTitle
    shoufTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:(fontSize - 3)];
    shoufTitle.text = [displayedMessage objectForKey:@"title"];
    // Add shoufSubject
    CGFloat adjTextHeight, textHeight;
    textHeight = [[displayedMessage objectForKey:@"body"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)] constrainedToSize:CGSizeMake(284.0,200.0) lineBreakMode:NSLineBreakByWordWrapping].height;
    if (textHeight > 19.0) {
        adjTextHeight = (textHeight + 40);
    } else {
        adjTextHeight =  40.0;
    }
    shoufSubject.frame = CGRectMake(19.0, 180.0, 284.0, adjTextHeight);
    shoufSubject.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    shoufSubject.text = [displayedMessage objectForKey:@"body"];
}

#pragma mark - shoufMessages Handling Methods

- (void)shoufWebService:(ShoufWebService *)shoufWebService errorMessage:(NSString *)errorMsg {
    // Load shoufMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"shoufMessages"] != NULL) {
        [self hideActivityIndicator];
        shoufMessages = [defaults objectForKey:@"shoufMessages"];
        // Extract todayMsgIndex
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromPeriodMessages:shoufMessages andDate:[NSDate date]];
        displayedMessage = [[shoufMessages objectAtIndex:todayMsgIndex] mutableCopy];
        [self updateView];
    } else {
        // Display Error Message
        [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
        [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الاتصال بالانترنت",errorMsg]];
        aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
        aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
        aiMsg.numberOfLines = 4;
        [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
    }
    // NSLog(@"shoufMessages = %d",[shoufMessages count]);
}

- (void)shoufWebService:(ShoufWebService *)shoufWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    // Retrieve shoufMessages
    shoufMessages = returnMsgs;
    // Save shoufMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[shoufMessages mutableCopy] forKey:@"shoufMessages"];
    [defaults synchronize];
    // Extract todayMsgIndex
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    todayMsgIndex = [dateIndexObject extractDateIndexFromPeriodMessages:shoufMessages andDate:[NSDate date]];
    displayedMessage = [[shoufMessages objectAtIndex:todayMsgIndex] mutableCopy];
    [self updateView];
}

#pragma mark - Font Size Related Methods

- (IBAction)increaseFontSize {
    if(fontSize < 30)
    {
        fontSize = fontSize + 1;
        [self updateTitleAndSubject];
    }
}

- (IBAction)decreaseFontSize {
    if(fontSize > 6)
    {
        fontSize = fontSize - 1;
        [self updateTitleAndSubject];
    }
}

#pragma mark - CFW Related Methods

- (void)handleLongPress:(UIGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        // Highlight Text
        shoufSubject.backgroundColor = [UIColor colorWithRed:0.247 green:0.518 blue:0.91 alpha:1]; // Select Color
        shoufSubject.textColor = [UIColor whiteColor];
        [self performSelector:@selector(clearBackgroundColor) withObject:nil afterDelay:0.5f];
        // Show CFW Buttons
        btnCopy.hidden = NO;
        btnFb.hidden = NO;
        btnWhtsp.hidden = NO;
        btnShare.hidden = NO;
    }
}

- (IBAction)publicShare:(id)sender {
    [self hideCFWbButtons];
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *newPNG=UIImagePNGRepresentation(img);
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:@"whatsapp://send?text=%@\n%@\n\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp",newPNG, nil] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[ UIActivityTypeMessage ,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)clearBackgroundColor {
    shoufSubject.backgroundColor = [UIColor clearColor];
    shoufSubject.textColor = [UIColor blackColor];
}

- (IBAction)copyFeature {
    [self hideCFWbButtons];
    NSString *copiedString = [NSString stringWithFormat:@"%@\n%@\n%@", shoufTitle.text, shoufSubject.text, [displayedMessage objectForKey:@"url"]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject copyContent:copiedString];
}

- (IBAction)facebookShare {
    [self hideCFWbButtons];
    NSString *facebookMsg = [NSString stringWithFormat:@"%@\n%@\n%@\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", shoufTitle.text, shoufSubject.text, [displayedMessage objectForKey:@"url"]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject facebookShareContent:facebookMsg fromViewController:self];
}

- (IBAction)whatsAppShare {
    [self hideCFWbButtons];
    NSString *contentString = [[NSString stringWithFormat:@"%@\n%@\n",shoufTitle.text, shoufSubject.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *videoUrlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[displayedMessage objectForKey:@"url"],NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    NSString *oskofeyaUrlString = [[NSString stringWithFormat:@"\n\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@%@%@",contentString,videoUrlString,oskofeyaUrlString]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject whatsAppShareURL:url];
}

- (void)hideCFWbButtons {
    btnCopy.hidden = YES;
    btnFb.hidden = YES;
    btnWhtsp.hidden = YES;
    btnShare.hidden = YES;
}

#pragma mark - YouTube Method

- (IBAction)loadYouTubeView:(id)sender {
    youTubeViewController.youTubeLink = [displayedMessage objectForKey:@"url"];
    [self showViewController:youTubeViewController];
    [self performSelector:@selector(pushViewController:) withObject:youTubeViewController afterDelay:0.5f];
}

#pragma mark - History Button Method

- (IBAction)loadShoufHistoryView:(id)sender {
    [self showViewController:shoufHistoryViewController];
    [self performSelector:@selector(pushViewController:) withObject:shoufHistoryViewController afterDelay:0.5f];
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

#pragma mark - ShoufHistoryDelegate Method

- (void)shoufHistoryViewController:(ShoufHistoryViewController *)shoufHistoryViewController setMessage:(NSMutableDictionary *)historyMessage {
    displayedMessage = historyMessage;
    [self updateView];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissShoufView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


