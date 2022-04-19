#import "Be2engylakViewController.h"
#import "AppDelegate.h"

@implementation Be2engylakViewController

@synthesize todayMsgIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"إشبع بإنجيلك", @"إشبع بإنجيلك");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize b2kHistoryViewController
    b2kHistoryViewController = [[B2kHistoryViewController alloc] initWithNibName:@"B2kHistoryView_i5" bundle:nil];
    [b2kHistoryViewController setB2kHistoryDelegate:self];
    // Initialize engylakWebService
    engylakWebService = [[EngylakWebService alloc] init];
    [engylakWebService setEngylakWsDelegate:self];
    // Get Present & Future engylakMessages
    [engylakWebService getEngylakMessagesForPresentAndFuture:YES];
    [self hideCFWbButtons];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    // Set fontSize
    fontSize = 17.0;
    if (todayMsgIndex == 1000) {
        // Navigating from Eshba3View
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:engylakMessages andDate:[NSDate date]];
        displayedMessage = [[engylakMessages objectAtIndex:todayMsgIndex] mutableCopy];
        [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:0 showTableView:showTableViewLastState withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        currentPageIndex = 0;
    }
    [self hideCFWbButtons];
}

- (void)setupView {
    // Set fontSize
    fontSize = 17.0;
    // Initialize pageController
    pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageController.dataSource = self;
    pageController.view.frame = CGRectMake(19, 120,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 50);
    pageController.view.backgroundColor = [UIColor clearColor];
    B2kChildViewController *initialViewController = [self viewControllerAtIndex:0 showTableView:NO withFontSize:fontSize];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
}

#pragma mark - engylakMessages Handling Methods

- (void)engylakWebService:(EngylakWebService *)engylakWebService errorMessage:(NSString *)errorMsg {
    // Load engylakMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"engylakMessages"] != NULL) {
        [self hideActivityIndicator];
        engylakMessages = [defaults objectForKey:@"engylakMessages"];
        // Extract today MsgIndex
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:engylakMessages andDate:[NSDate date]];
        displayedMessage = [[engylakMessages objectAtIndex:todayMsgIndex] mutableCopy];
        [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:0 showTableView:YES withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        // Display Error Message
        [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
        [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الاتصال بالانترنت",errorMsg]];
        aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
        aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
        aiMsg.numberOfLines = 4;
        [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
    }
    // NSLog(@"engylakMessages = %d",[engylakMessages count]);
}

- (void)engylakWebService:(EngylakWebService *)engylakWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    // Retrieve engylakMessages
    engylakMessages = returnMsgs;
    // Save engylakMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[engylakMessages mutableCopy] forKey:@"engylakMessages"];
    [defaults synchronize];
    // Extract today MsgIndex
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:engylakMessages andDate:[NSDate date]];
    displayedMessage = [[engylakMessages objectAtIndex:todayMsgIndex] mutableCopy];
    [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:0 showTableView:YES withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - pageViewController Methods

- (B2kChildViewController *)viewControllerAtIndex:(NSUInteger)pageIndex showTableView:(BOOL)boolVar withFontSize:(int)fontSizeVar {
    B2kChildViewController *childViewController = [[B2kChildViewController alloc] initWithNibName:@"B2kChildView" bundle:nil];
    [childViewController setB2kChildDelegate:self];
    childViewController.pageIndex = pageIndex;
    childViewController.displayedMessage = displayedMessage;
    childViewController.todayMsgIndex = todayMsgIndex;
    showTableViewLastState = boolVar;
    childViewController.showTableView = boolVar;
    childViewController.fontSize = fontSizeVar;
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = [(B2kChildViewController *)viewController pageIndex];
    if (pageIndex == 0) {
        return nil;
    }
    pageIndex--;
    
    return [self viewControllerAtIndex:pageIndex showTableView:YES withFontSize:fontSize];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = [(B2kChildViewController *)viewController pageIndex];
    pageIndex++;
    if (pageIndex == 4) {
        return nil;
    }
    
    return [self viewControllerAtIndex:pageIndex showTableView:YES withFontSize:fontSize];
}



#pragma mark - Font Size Related Methods

- (IBAction)increaseFontSize {
    
    if([[pageController.viewControllers lastObject] pageIndex] !=3)
    {
        if(fontSize < 30)
        {
            fontSize = fontSize + 1;
            [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:[[pageController.viewControllers lastObject] pageIndex] showTableView:YES withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
    }
}

- (IBAction)decreaseFontSize {
    
    if([[pageController.viewControllers lastObject] pageIndex] !=3)
    {
        if(fontSize > 6)
        {
            fontSize = fontSize - 1;
            [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:[[pageController.viewControllers lastObject] pageIndex] showTableView:YES withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
    }
}

#pragma mark - CFW Related Methods

- (IBAction)copyFeature {
    [self hideCFWbButtons];
    NSString *copiedString;
    switch (currentPageIndex) {
        case 0:
            copiedString = [NSString stringWithFormat:@"%@\n%@", [displayedMessage objectForKey:@"header_subject"], [displayedMessage objectForKey:@"header_body"]];
            break;
        case 1:
            copiedString = [NSString stringWithFormat:@"%@\n%@", [displayedMessage objectForKey:@"content_subject"], [displayedMessage objectForKey:@"content_body"]];
            break;
        case 2:
            copiedString = [NSString stringWithFormat:@"%@\n%@", [displayedMessage objectForKey:@"footer_subject"], [displayedMessage objectForKey:@"footer_body"]];
            break;
        default:
            copiedString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@", [displayedMessage objectForKey:@"header_subject"], [displayedMessage objectForKey:@"header_body"], [displayedMessage objectForKey:@"content_subject"], [displayedMessage objectForKey:@"content_body"], [displayedMessage objectForKey:@"footer_subject"], [displayedMessage objectForKey:@"footer_body"]];
            break;
    }
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject copyContent:copiedString];
}

- (IBAction)facebookShare {
    [self hideCFWbButtons];
    
    NSString *facebookMsg;
    CFWObject *cfwObject = [[CFWObject alloc] init];
    switch (currentPageIndex) {
        case 0:
            // facebookMsg = [NSString stringWithFormat:@"%@\n%@\n\nمشاركة من خلال تطبيق اسقفية الشباب أونلاين", [displayedMessage objectForKey:@"header_subject"], [displayedMessage objectForKey:@"header_body"]];
            facebookMsg = [NSString stringWithFormat:@"%@\n%@\n\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", [displayedMessage objectForKey:@"header_subject"], [displayedMessage objectForKey:@"header_body"]];
            [cfwObject facebookShareContent:facebookMsg fromViewController:self];
            break;
        case 1:
            facebookMsg = [NSString stringWithFormat:@"%@\n%@\n\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", [displayedMessage objectForKey:@"content_subject"], [displayedMessage objectForKey:@"content_body"]];
            [cfwObject facebookShareContent:facebookMsg fromViewController:self];
            break;
        case 2:
            facebookMsg = [NSString stringWithFormat:@"%@\n%@\n\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", [displayedMessage objectForKey:@"footer_subject"], [displayedMessage objectForKey:@"footer_body"]];
            [cfwObject facebookShareContent:facebookMsg fromViewController:self];
            break;
        default:
            // facebookMsg = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n\nمشاركة من خلال تطبيق اسقفية الشباب أونلاين", [displayedMessage objectForKey:@"header_subject"], [displayedMessage objectForKey:@"header_body"], [displayedMessage objectForKey:@"content_subject"], [displayedMessage objectForKey:@"content_body"], [displayedMessage objectForKey:@"footer_subject"], [displayedMessage objectForKey:@"footer_body"]];
            facebookMsg = [NSString stringWithFormat:@"%@\n\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", [displayedMessage objectForKey:@"ehfaz_title"]];
            NSData *mediaData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/%@",[displayedMessage objectForKey:@"ehfaz_image"]]]];
            [cfwObject facebookShareContent:facebookMsg fromViewController:self withImage:mediaData];
            break;
    }
}

- (IBAction)whatsAppShare {
    [self hideCFWbButtons];
    NSURL *url;
    CFWObject *cfwObject = [[CFWObject alloc] init];
    switch (currentPageIndex) {
        case 0:
            url = [NSURL URLWithString:[[NSString stringWithFormat:@"whatsapp://send?text=%@\n%@\n\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", [displayedMessage objectForKey:@"header_subject"], [displayedMessage objectForKey:@"header_body"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [cfwObject whatsAppShareURL:url];
            break;
        case 1:
            url = [NSURL URLWithString:[[NSString stringWithFormat:@"whatsapp://send?text=%@\n%@\n\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", [displayedMessage objectForKey:@"content_subject"], [displayedMessage objectForKey:@"content_body"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [cfwObject whatsAppShareURL:url];
            break;
        case 2:
            url = [NSURL URLWithString:[[NSString stringWithFormat:@"whatsapp://send?text=%@\n%@\n\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", [displayedMessage objectForKey:@"footer_subject"], [displayedMessage objectForKey:@"footer_body"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [cfwObject whatsAppShareURL:url];
            break;
        default:
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://app"]]) {
                NSData *mediaData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/%@",[displayedMessage objectForKey:@"ehfaz_image"]]]];
                UIImage *iconImage = [UIImage imageWithData:mediaData];
                NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.wai"];
                [UIImageJPEGRepresentation(iconImage, 1.0) writeToFile:savePath atomically:YES];
                documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
                documentInteractionController.UTI = @"net.whatsapp.image";
                [documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = [NSString stringWithFormat:@"%@\n\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", [displayedMessage objectForKey:@"ehfaz_title"]];
                // Add text as caption
                [AppDelegate showAlertView:@"برجاء لصق المحتوى في المساحة المخصصة\nPlease click paste in the caption area"];
            }
            else {
                [AppDelegate showAlertView:[NSString stringWithFormat:@"برجاء تحميل برنامج الواتس اب   "]];
            }
            break;
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
    /*NSArray* sharedObjects=[NSArray arrayWithObjects:@"sharecontent",  nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];*/

}


- (void)hideCFWbButtons {
    btnCopy.hidden = YES;
    btnFb.hidden = YES;
    btnWhtsp.hidden = YES;
    btnShare.hidden = YES;
}

#pragma mark - History Button Method

- (IBAction)loadB2kHistoryView:(id)sender {
    [self showViewController:b2kHistoryViewController];
    [self performSelector:@selector(pushViewController:) withObject:b2kHistoryViewController afterDelay:0.5f];
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

#pragma mark - B2kHistoryDelegate Method

- (void)b2kHistoryViewController:(B2kHistoryViewController *)b2kHistoryViewController setMessage:(NSMutableDictionary *)historyMessage {
    // Set fontSize
    fontSize = 17.0;
    displayedMessage = historyMessage;
    [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:0 showTableView:YES withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - B2kChildDelegate Method

- (void)b2kChildViewController:(B2kChildViewController *)b2kChildViewController hideCFW_Buttons:(BOOL)hideOrShow withPageIndex:(NSInteger)pageIndex {
    currentPageIndex = pageIndex;
    if (hideOrShow == YES) {
        // Hide CFW Buttons
        btnCopy.hidden = YES;
        btnFb.hidden = YES;
        btnWhtsp.hidden = YES;
         btnShare.hidden = YES;
    } else {
        // Show CFW Buttons
        btnCopy.hidden = NO;
        btnFb.hidden = NO;
        btnWhtsp.hidden = NO;
        btnShare.hidden = NO;
    }
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissBe2engylakView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


