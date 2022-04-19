#import "AgpeyaViewController.h"
#import "AppDelegate.h"

@implementation AgpeyaViewController

@synthesize prayerNameFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@" ", @" ");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize agpeyaWebService
    agpeyaWebService = [[AgpeyaWebService alloc] init];
    [agpeyaWebService setAgpeyaWsDelegate:self];
    // Initialize soundCloudWebService
    soundCloudWebService = [[SoundCloudWebService alloc] init];
    [soundCloudWebService setSoundCloudWsDelegate:self];
    // Get Agpeya Prayers
    [agpeyaWebService getAgpeyaPrayersIn:prayerNameFlag];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    // Set fontSize
    fontSize = 17.0;
    // Check if coming from WriteNoteView
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldReturnToAgpeyaViewFromWNView) {
        // Reset shouldReturnToAgpeyaViewFromWNView Flag
        ((AppDelegate *)[UIApplication sharedApplication].delegate).shouldReturnToAgpeyaViewFromWNView = NO;
        [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:currentPageIndex showTableView:showTableViewLastState withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        // Navigating from SalatyView
        [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:0 showTableView:showTableViewLastState withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        currentPageIndex = 0;
    }
}

- (void)setupView {
    // Set fontSize
    fontSize = 17.0;
    // Hide & Disable Play/Pause Button
    btnPlayPauseTrack.hidden = YES;
    btnPlayPauseTrack.enabled = YES;
    // Initialize scAudioPlayerStatus Flag
    scAudioPlayerStatus = @"Stopped";
    // Initialize pageController
    pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageController.dataSource = self;
    pageController.view.frame = CGRectMake(19, 92, self.view.bounds.size.width - 38, self.view.bounds.size.height - 160);
    
    pageController.view.backgroundColor = [UIColor clearColor];
    AgpChildViewController *initialViewController = [self viewControllerAtIndex:0 showTableView:NO withFontSize:fontSize];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
}

#pragma mark - agpeyaPrayers Handling Methods

- (void)agpeyaWebService:(AgpeyaWebService *)agpeyaWebService errorMessage:(NSString *)errorMsg {
    // Display Error Message
    [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
    [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الاتصال بالانترنت",errorMsg]];
    aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    aiMsg.numberOfLines = 4;
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
}

- (void)agpeyaWebService:(AgpeyaWebService *)agpeyaWebService returnMessages:(NSMutableDictionary *)returnMsgs {
    [self hideActivityIndicator];
    // Retrieve agpeyaPrayers
    agpeyaPrayers = returnMsgs;
    [self calculateNumberOfPages];
    [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:0 showTableView:YES withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    // NSLog(@"agpeyaPrayers = %@",agpeyaPrayers);
}

- (void)calculateNumberOfPages {
    int dynamicPrayers = 7; int gotoPages = 2; int static1Prayers = [[agpeyaPrayers objectForKey:@"static1"] count];
    int static2Prayers = [[agpeyaPrayers objectForKey:@"static2"] count]; int static3Prayers = [[agpeyaPrayers objectForKey:@"static3"] count];
    numberofPagesInView = dynamicPrayers + static1Prayers + static2Prayers +static3Prayers + gotoPages;
}

#pragma mark - pageViewController Methods

- (NSMutableDictionary *)extractPrayerAtIndex:(NSUInteger)pageIndex {
    int static1Prayers = [[agpeyaPrayers objectForKey:@"static1"] count]; 
    int static2Prayers = [[agpeyaPrayers objectForKey:@"static2"] count];
    int static3Prayers = [[agpeyaPrayers objectForKey:@"static3"] count];
    if (pageIndex == 0) {
        return [agpeyaPrayers objectForKey:@"hymn_a"];
    } else if (pageIndex == 1) {
        return [agpeyaPrayers objectForKey:@"hymn_b"];
    } else if (pageIndex >= 2 && pageIndex < (2 + static1Prayers)) {
        return [[agpeyaPrayers objectForKey:@"static1"] objectForKey:[NSString stringWithFormat:@"prayer%d",(pageIndex - 1)]];
    } else if (pageIndex == 2 + static1Prayers) {
        return [agpeyaPrayers objectForKey:@"psalm_a"];
    } else if (pageIndex == 3 + static1Prayers) {
        return [agpeyaPrayers objectForKey:@"psalm_b"];
    } else if (pageIndex >= (4 + static1Prayers) && pageIndex < (4 + static1Prayers + static2Prayers)) {
        return [[agpeyaPrayers objectForKey:@"static2"] objectForKey:[NSString stringWithFormat:@"prayer%d",(pageIndex - (3 + static1Prayers))]];
    } else if (pageIndex == (4 + static1Prayers + static2Prayers)) {

        return [agpeyaPrayers objectForKey:@"mercy"];
    } else if (pageIndex >= (5 + static1Prayers + static2Prayers) && pageIndex < (5 + static1Prayers + static2Prayers +static3Prayers)) {
        return [[agpeyaPrayers objectForKey:@"static3"] objectForKey:[NSString stringWithFormat:@"prayer%d",(pageIndex - (4 + static1Prayers + static2Prayers))]];
    } else if (pageIndex == (5 + static1Prayers + static2Prayers +static3Prayers)) {
        return [agpeyaPrayers objectForKey:@"praise"];
    } else if (pageIndex == (6 + static1Prayers + static2Prayers +static3Prayers)) {
        return [agpeyaPrayers objectForKey:@"free"];
    } else if (pageIndex == (7 + static1Prayers + static2Prayers +static3Prayers)) {
        NSMutableDictionary *returnMutableDict = [[NSMutableDictionary alloc] init];
        [returnMutableDict setObject:@"OSK_GotoNotes" forKey:@"goto"];
        return returnMutableDict;
    } else if (pageIndex == (8 + static1Prayers + static2Prayers +static3Prayers)) {
        NSMutableDictionary *returnMutableDict = [[NSMutableDictionary alloc] init];
        [returnMutableDict setObject:@"OSK_GotoBe2engylak" forKey:@"goto"];
        return returnMutableDict;
    } else {
        NSLog(@"Error !");
        return nil;
    }
}

- (AgpChildViewController *)viewControllerAtIndex:(NSUInteger)pageIndex showTableView:(BOOL)boolVar withFontSize:(int)fontSizeVar {
    AgpChildViewController *childViewController = [[AgpChildViewController alloc] initWithNibName:@"AgpChildView" bundle:nil];
    [childViewController setAgpChildDelegate:self];
    childViewController.pageIndex = pageIndex;
    childViewController.displayedPrayer = [self extractPrayerAtIndex:pageIndex];
    showTableViewLastState = boolVar;
    childViewController.showTableView = boolVar;
    childViewController.fontSize = fontSizeVar;
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = [(AgpChildViewController *)viewController pageIndex];
    if (pageIndex == 0) {
        return nil;
    }
    pageIndex--;
    
    return [self viewControllerAtIndex:pageIndex showTableView:YES withFontSize:fontSize];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = [(AgpChildViewController *)viewController pageIndex];
    pageIndex++;
    if (pageIndex == numberofPagesInView) {
        return nil;
    }
    return [self viewControllerAtIndex:pageIndex showTableView:YES withFontSize:fontSize];
}

#pragma mark - Font Size Related Methods

- (IBAction)increaseFontSize {
    if(fontSize < 30)
    {
        fontSize = fontSize + 1;
        [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:[[pageController.viewControllers lastObject] pageIndex] showTableView:YES withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

- (IBAction)decreaseFontSize {
    if(fontSize > 6)
    {
        fontSize = fontSize - 1;
        [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:[[pageController.viewControllers lastObject] pageIndex] showTableView:YES withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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

#pragma mark - SoundCloud Handling Methods

- (IBAction)playPauseSoundCloudTrack {
    if ([scAudioPlayerStatus isEqualToString:@"Stopped"]) {
        [soundCloudWebService resolveSoundCloudTrackIDfromURL:scAudioTrackURL];
        [btnPlayPauseTrack setImage:[UIImage imageNamed:@"OSK_IconEsma3_Pause"] forState:UIControlStateNormal];
        btnPlayPauseTrack.enabled = NO;
        scAudioPlayerStatus = @"Playing";
    } else if ([scAudioPlayerStatus isEqualToString:@"Playing"]){
        [scAudioPlayer pause];
        [btnPlayPauseTrack setImage:[UIImage imageNamed:@"OSK_IconEsma3_Play"] forState:UIControlStateNormal];
        scAudioPlayerStatus = @"Paused";
    } else {
        [scAudioPlayer play];
        [btnPlayPauseTrack setImage:[UIImage imageNamed:@"OSK_IconEsma3_Pause"] forState:UIControlStateNormal];
        scAudioPlayerStatus = @"Playing";
    }
}

- (void)soundCloudWebService:(SoundCloudWebService *)soundCloudWebService errorMessage:(NSString *)errorMsg {
    [self unloadOldAudioTrackAndResetPlayButton];
    btnPlayPauseTrack.hidden = YES;
    [AppDelegate showAlertView:@"لا يوجد ملف صوت"];
}

- (void)soundCloudWebService:(SoundCloudWebService *)soundCloudWebService returnMessages:(NSMutableDictionary *)returnMsgs {
    // Retrieve scStreamURL
    NSString *scStreamURL = [self resolveSoundCloudStreamURL:[returnMsgs objectForKey:@"stream_url"]];
    // Load scTrackData
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        scTrackData =[NSData dataWithContentsOfURL:[NSURL URLWithString:scStreamURL]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (scTrackData && ![scAudioPlayerStatus isEqualToString:@"Stopped"]) {
                // Play Audio Track
                scAudioPlayer = [[AVAudioPlayer alloc]initWithData:scTrackData error:nil];
                [scAudioPlayer play];
                btnPlayPauseTrack.enabled = YES;
            } else {
                if (![scAudioPlayerStatus isEqualToString:@"Stopped"]) {
                    [AppDelegate showAlertView:[NSString stringWithFormat:@"%@",@"لا يمكن تحميل ملف الصوت"]]; // @"Could not load Audio Track"
                }
                [self unloadOldAudioTrackAndResetPlayButton];
            }
        });
    });
}

- (NSString *)resolveSoundCloudStreamURL:(NSString *)scStreamURL {
    NSArray *stringArray = [scStreamURL componentsSeparatedByString:@"secret_token"];
    if ([stringArray count] > 1) {
        // Private Track with secret_token
        scStreamURL = [scStreamURL stringByAppendingString:@"&client_id=ac49616664ca1f9c03baa38fef74a60c"];
    } else {
        // Public Track
        scStreamURL = [scStreamURL stringByAppendingString:@"?client_id=ac49616664ca1f9c03baa38fef74a60c"];
    }
    return scStreamURL;
}

#pragma mark - AgpChildDelegate Method

- (void)agpChildViewController:(AgpChildViewController *)agpChildViewController loadAudioTrackWithURL:(NSString *)retAudioTrackURL {
    scAudioTrackURL = retAudioTrackURL;
    [self unloadOldAudioTrackAndResetPlayButton];
    // Show or Hide the Play/Pause Button if there is an available new AudioTrack
    if (scAudioTrackURL && ![scAudioTrackURL isEqual:[NSNull null]]) {
        btnPlayPauseTrack.hidden = NO;
    } else {
        btnPlayPauseTrack.hidden = YES;
    }
}

- (void)unloadOldAudioTrackAndResetPlayButton {
    scAudioPlayer = [[AVAudioPlayer alloc]initWithData:nil error:nil];
    // Stop Audio Player
    [scAudioPlayer stop];
    [btnPlayPauseTrack setImage:[UIImage imageNamed:@"OSK_IconEsma3_Play"] forState:UIControlStateNormal];
    btnPlayPauseTrack.enabled = YES;
    scAudioPlayerStatus = @"Stopped";
}

- (void)agpChildViewController:(AgpChildViewController *)agpChildViewController gotoPageViewModification:(NSString *)gotoPage andSetPageIndex:(NSInteger)pageIndex {
    currentPageIndex = pageIndex;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.jpg"]];
    if(currentPageIndex == numberofPagesInView - 2)
    {
        [backgroundImage setImage:[UIImage imageNamed:@"IMG_Tamol.jpg"]];
    }
    else if(currentPageIndex == numberofPagesInView - 1)
    {
        [backgroundImage setImage:[UIImage imageNamed:@"bengelk.jpg"]];
    }
    btnIncFont.hidden = YES;
    btnDecFont.hidden = YES;
}

- (void)agpChildViewControllerResetViewModification:(AgpChildViewController *)agpChildViewController {
    // Reset backgroundImage & Buttons
    [backgroundImage setImage:[UIImage imageNamed:@"bg.jpg"]];
    btnIncFont.hidden = NO;
    btnDecFont.hidden = NO;
}

- (void)agpChildViewController:(AgpChildViewController *)agpChildViewController gotoView:(NSString *)gotoView {
    if ([gotoView isEqualToString:@"OSK_GotoNotes"]) {
        // Set shouldLoadWriteNoteView Flag
        ((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadWriteNoteView = YES;
        [self dismissAgpeyaView:nil];
    } else if ([gotoView isEqualToString:@"OSK_GotoBe2engylak"]) {
        // Set shouldLoadBe2engylakView Flag
        ((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadBe2engylakView = YES;
        [self dismissAgpeyaView:nil];
    }
}


#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissAgpeyaView:(id)sender {
    [self unloadOldAudioTrackAndResetPlayButton];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


