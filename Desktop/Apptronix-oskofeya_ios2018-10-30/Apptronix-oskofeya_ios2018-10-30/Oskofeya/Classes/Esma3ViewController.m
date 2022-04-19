#import "Esma3ViewController.h"
#import "AppDelegate.h"

@implementation Esma3ViewController

@synthesize todayMsgIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"إسمع", @"إسمع");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize esma3HistoryViewController

    esma3HistoryViewController = [[Esma3HistoryViewController alloc] initWithNibName:@"Esma3HistoryView_i5" bundle:nil];
    [esma3HistoryViewController setEsma3HistoryDelegate:self];
    // Initialize soundCloudWebService
    soundCloudWebService = [[SoundCloudWebService alloc] init];
    [soundCloudWebService setSoundCloudWsDelegate:self];
    // Initialize esma3WebService
    esma3WebService = [[Esma3WebService alloc] init];
    [esma3WebService setEsma3WsDelegate:self];
    // Get Present & Future esma3Messages
    [esma3WebService getEsma3MessagesForPresentAndFuture:YES];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (todayMsgIndex == 1000) {
        // Navigating from Estamte3
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromPeriodMessages:esma3Messages andDate:[NSDate date]];
        displayedMessage = [[esma3Messages objectAtIndex:todayMsgIndex] mutableCopy];
        [self updateView];
    }
    [self hideCFWbButtons];
}

- (void)setupView {
    // Hide & Disable Play/Pause Icon
    iconPlayPauseTrack.enabled = YES;
    // Initialize scAudioPlayerStatus Flag
    scAudioPlayerStatus = @"Stopped";
    // Set esma3Title
    esma3Title.font = [UIFont fontWithName:@"Helvetica-Bold" size:(17)];
    esma3Title.adjustsFontSizeToFitWidth = YES;
    esma3Title.text = [displayedMessage objectForKey:@"title"];
    // Add esma3Subject
    esma3Subject = [[UITextView alloc] initWithFrame:CGRectMake(15.0, 200.0, 284.0, 400.0)];
    esma3Subject.backgroundColor = [UIColor clearColor];
    esma3Subject.font = [UIFont fontWithName:@"Helvetica" size:15];
    [esma3Subject setTextColor: [UIColor blackColor]];
    [esma3Subject setTextAlignment:NSTextAlignmentRight];
    esma3Subject.editable = NO;
    [self.view addSubview:esma3Subject];
    esma3Subject.text = [displayedMessage objectForKey:@"body"];
    // Add esma3SubjectOverlay
    esma3SubjectOverlay = [[UIView alloc] init];
    if ( esma3Subject.contentSize.height >= esma3Subject.bounds.size.height) {
        [esma3SubjectOverlay setFrame:CGRectMake(0, 0, esma3Subject.contentSize.width, esma3Subject.contentSize.height)];
    } else {
        [esma3SubjectOverlay setFrame:CGRectMake(0, 0, esma3Subject.bounds.size.width, esma3Subject.bounds.size.height)];
    }
    esma3SubjectOverlay.backgroundColor = [UIColor clearColor];
    [esma3Subject addSubview:esma3SubjectOverlay];
    // Add LongPress Handling
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [esma3Subject addGestureRecognizer:longPress];
}

- (void)updateView {
    // Set fontSize
    fontSize = 17.0;
    [self updateTitleAndSubject];
}

- (void)updateTitleAndSubject {
    // Set esma3Title
  //  esma3Title.font = [UIFont fontWithName:@"Helvetica-Bold" size:(17)];
    esma3Title.text = [displayedMessage objectForKey:@"title"];
    // Add esma3Subject
    CGFloat adjTextHeight, textHeight;
    textHeight = [[displayedMessage objectForKey:@"body"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)] constrainedToSize:CGSizeMake(284.0,180.0) lineBreakMode:NSLineBreakByWordWrapping].height;
   
    if (textHeight > 19.0) {
        adjTextHeight = (textHeight + 100);
    } else {
        adjTextHeight =  100.0;
    }
    esma3Subject.frame = CGRectMake(15.0, 180.0, 284.0, adjTextHeight);
    esma3Subject.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    esma3Subject.text = [displayedMessage objectForKey:@"body"];
}

#pragma mark - esma3Messages Handling Methods

- (void)esma3WebService:(Esma3WebService *)esma3WebService errorMessage:(NSString *)errorMsg {
    // Load esma3Messages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"esma3Messages"] != NULL) {
        [self hideActivityIndicator];
        esma3Messages = [defaults objectForKey:@"esma3Messages"];
        // Extract todayMsgIndex
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromPeriodMessages:esma3Messages andDate:[NSDate date]];
        displayedMessage = [[esma3Messages objectAtIndex:todayMsgIndex] mutableCopy];
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
    // NSLog(@"esma3Messages = %d",[esma3Messages count]);
}

- (void)esma3WebService:(Esma3WebService *)esma3WebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    // Retrieve esma3Messages
    esma3Messages = returnMsgs;
    // Save esma3Messages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[esma3Messages mutableCopy] forKey:@"esma3Messages"];
    [defaults synchronize];
    // Extract today MsgIndex
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    todayMsgIndex = [dateIndexObject extractDateIndexFromPeriodMessages:esma3Messages andDate:[NSDate date]];
    displayedMessage = [[esma3Messages objectAtIndex:todayMsgIndex] mutableCopy];
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
        esma3Subject.backgroundColor = [UIColor colorWithRed:0.247 green:0.518 blue:0.91 alpha:1];
        esma3Subject.textColor = [UIColor whiteColor];
        [self performSelector:@selector(clearBackgroundColor) withObject:nil afterDelay:0.5f];
        // Show CFW Buttons
        btnCopy.hidden = NO;
        btnFb.hidden = NO;
        btnWhtsp.hidden = NO;
        btnShare.hidden = NO;
    }
}

- (void)clearBackgroundColor {
    esma3Subject.backgroundColor = [UIColor clearColor];
    esma3Subject.textColor = [UIColor blackColor];
}

- (IBAction)copyFeature {
    [self hideCFWbButtons];
    NSString *copiedString = [NSString stringWithFormat:@"%@\n%@\n%@", esma3Title.text, esma3Subject.text, [displayedMessage objectForKey:@"url"]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject copyContent:copiedString];
}

- (IBAction)facebookShare {
    [self hideCFWbButtons];
    NSString *facebookMsg = [NSString stringWithFormat:@"%@\n%@\n%@\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", esma3Title.text, esma3Subject.text, [displayedMessage objectForKey:@"url"]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject facebookShareContent:facebookMsg fromViewController:self];
}

- (IBAction)whatsAppShare {
    [self hideCFWbButtons];
    NSString *contentString = [[NSString stringWithFormat:@"%@\n%@\n",esma3Title.text, esma3Subject.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *tarneemaUrlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[displayedMessage objectForKey:@"url"],NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    NSString *oskofeyaUrlString = [[NSString stringWithFormat:@"\n\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@%@%@",contentString,tarneemaUrlString,oskofeyaUrlString]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject whatsAppShareURL:url];
}

- (void)hideCFWbButtons {
    btnCopy.hidden = YES;
    btnFb.hidden = YES;
    btnWhtsp.hidden = YES;
    btnShare.hidden = YES;
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


#pragma mark - SoundCloud Handling Methods

- (IBAction)playPauseSoundCloudTrack {
    if ([scAudioPlayerStatus isEqualToString:@"Stopped"]) {
        [soundCloudWebService resolveSoundCloudTrackIDfromURL:[displayedMessage objectForKey:@"url"]];
        [iconPlayPauseTrack setImage:[UIImage imageNamed:@"OSK_IconEsma3_Pause"] forState:UIControlStateNormal];
        iconPlayPauseTrack.enabled = NO;
        scAudioPlayerStatus = @"Playing";
    } else if ([scAudioPlayerStatus isEqualToString:@"Playing"]){
        [scAudioPlayer pause];
        [iconPlayPauseTrack setImage:[UIImage imageNamed:@"OSK_IconEsma3_Play"] forState:UIControlStateNormal];
        scAudioPlayerStatus = @"Paused";
    } else {
        [scAudioPlayer play];
        [iconPlayPauseTrack setImage:[UIImage imageNamed:@"OSK_IconEsma3_Pause"] forState:UIControlStateNormal];
        scAudioPlayerStatus = @"Playing";
    }
}

- (void)soundCloudWebService:(SoundCloudWebService *)soundCloudWebService errorMessage:(NSString *)errorMsg {
    [self unloadOldAudioTrackAndResetPlayButton];
    iconPlayPauseTrack.hidden = YES;
    [AppDelegate showAlertView:@"لا يوجد ملف صوت"]; // @"There is no Audio Track"
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
                iconPlayPauseTrack.enabled = YES;
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

- (void)unloadOldAudioTrackAndResetPlayButton {
    scAudioPlayer = [[AVAudioPlayer alloc]initWithData:nil error:nil];
    // Stop Audio Player
    [scAudioPlayer stop];
    [iconPlayPauseTrack setImage:[UIImage imageNamed:@"OSK_IconEsma3_Play"] forState:UIControlStateNormal];
    iconPlayPauseTrack.enabled = YES;
    scAudioPlayerStatus = @"Stopped";
}

#pragma mark - History Button Method

- (IBAction)loadEsma3HistoryView:(id)sender {
    [self unloadOldAudioTrackAndResetPlayButton];
    [self showViewController:esma3HistoryViewController];
    [self performSelector:@selector(pushViewController:) withObject:esma3HistoryViewController afterDelay:0.5f];
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

#pragma mark - Esma3HistoryDelegate Method

- (void)esma3HistoryViewController:(Esma3HistoryViewController *)esma3HistoryViewController setMessage:(NSMutableDictionary *)historyMessage {
    displayedMessage = historyMessage;
    [self updateView];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissEsma3View:(id)sender {
    [self unloadOldAudioTrackAndResetPlayButton];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


