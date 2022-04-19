
#import "BekenystakViewController.h"
#import "AppDelegate.h"

@implementation BekenystakViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"إشبع بكنيستك",@"إشبع بكنيستك");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize soundCloudWebService
    soundCloudWebService = [[SoundCloudWebService alloc] init];
    [soundCloudWebService setSoundCloudWsDelegate:self];
    // Initialize kenystakWebService
    kenystakWebService = [[KenystakWebService alloc] init];
    [kenystakWebService setKenystakWsDelegate:self];
    // Get Present & Future kenystakMessages
    [kenystakWebService getKenystakMessagesForPresentAndFuture:YES];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateView];
    [self hideCFWbButtons];
}
- (void)setupView {
    // Hide & Disable Play/Pause Icon
    iconPlayPauseTrack.enabled = YES;
    // Initialize scAudioPlayerStatus Flag
    scAudioPlayerStatus = @"Stopped";
    // Set bekenystakTitle
    bekenystakTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:(17)];
    bekenystakTitle.adjustsFontSizeToFitWidth = YES;
    bekenystakTitle.text = [displayedMessage objectForKey:@"title"];
    // Add bekenystakSubject
    bekenystakSubject = [[UITextView alloc] initWithFrame:CGRectMake(19.0, 180.0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 290)];
    bekenystakSubject.backgroundColor = [UIColor clearColor];
    bekenystakSubject.font = [UIFont fontWithName:@"Helvetica" size:15];
    [bekenystakSubject setTextColor: [UIColor blackColor]];
    [bekenystakSubject setTextAlignment:NSTextAlignmentRight];
    bekenystakSubject.editable = NO;
    [self.view addSubview:bekenystakSubject];
    bekenystakSubject.text = [displayedMessage objectForKey:@"body"];
    // Add bekenystakSubjectOverlay
    bekenystakSubjectOverlay = [[UIView alloc] init];
    if ( bekenystakSubject.contentSize.height >= bekenystakSubject.bounds.size.height) {
        [bekenystakSubjectOverlay setFrame:CGRectMake(0, 0, bekenystakSubject.contentSize.width, bekenystakSubject.contentSize.height)];
    } else {
        [bekenystakSubjectOverlay setFrame:CGRectMake(0, 0, bekenystakSubject.bounds.size.width, bekenystakSubject.bounds.size.height)];
    }
    bekenystakSubjectOverlay.backgroundColor = [UIColor clearColor];
    [bekenystakSubject addSubview:bekenystakSubjectOverlay];
    // Add LongPress Handling
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [bekenystakSubject addGestureRecognizer:longPress];
}

- (void)updateView {
    // Set fontSize
    fontSize = 17.0;
    [self updateTitleAndSubject];
}

- (void)updateTitleAndSubject {
    // Set bekenystakTitle
    bekenystakTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:(17)];
    bekenystakTitle.text = [displayedMessage objectForKey:@"title"];
    // Add bekenystakSubject
    CGFloat adjTextHeight, textHeight;
    
    textHeight = [[displayedMessage objectForKey:@"body"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)] constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 290) lineBreakMode:NSLineBreakByWordWrapping].height;
    if (textHeight > 19.0) {
        adjTextHeight = (textHeight + 40);
    } else {
        adjTextHeight =  40.0;
    }
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        bekenystakSubject.frame = CGRectMake(19.0, 180.0, 284.0, adjTextHeight);
    } else {
        bekenystakSubject.frame = CGRectMake(15.0, 180.0, 284.0, adjTextHeight);
    }
    bekenystakSubject.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    bekenystakSubject.text = [displayedMessage objectForKey:@"body"];
}

#pragma mark - kenystakMessages Handling Methods

- (void)kenystakWebService:(KenystakWebService *)kenystakWebService errorMessage:(NSString *)errorMsg {
    // Load kenystakMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"kenystakMessages"] != NULL) {
        [self hideActivityIndicator];
        kenystakMessages = [defaults objectForKey:@"kenystakMessages"];
        // Extract todayMsgIndex
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromPeriodMessages:kenystakMessages andDate:[NSDate date]];
        displayedMessage = [[kenystakMessages objectAtIndex:todayMsgIndex] mutableCopy];
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
}

- (void)kenystakWebService:(KenystakWebService *)kenystakWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    // Retrieve kenystakMessages
    kenystakMessages = returnMsgs;
    // Save kenystakMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[kenystakMessages mutableCopy] forKey:@"kenystakMessages"];
    [defaults synchronize];
    // Extract today MsgIndex
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    todayMsgIndex = [dateIndexObject extractDateIndexFromPeriodMessages:kenystakMessages andDate:[NSDate date]];
    displayedMessage = [[kenystakMessages objectAtIndex:todayMsgIndex] mutableCopy];
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
        bekenystakSubject.backgroundColor = [UIColor colorWithRed:0.247 green:0.518 blue:0.91 alpha:1];
        bekenystakSubject.textColor = [UIColor whiteColor];
        [self performSelector:@selector(clearBackgroundColor) withObject:nil afterDelay:0.5f];
        // Show CFW Buttons
        btnCopy.hidden = NO;
        btnFb.hidden = NO;
        btnWhtsp.hidden = NO;
        btnShare.hidden = NO;
    }
}

- (void)clearBackgroundColor {
    bekenystakSubject.backgroundColor = [UIColor clearColor];
    bekenystakSubject.textColor = [UIColor blackColor];
}

- (IBAction)copyFeature {
    [self hideCFWbButtons];
    NSString *copiedString = [NSString stringWithFormat:@"%@\n%@\n%@", bekenystakTitle.text, bekenystakSubject.text, [displayedMessage objectForKey:@"url"]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject copyContent:copiedString];
}

- (IBAction)facebookShare {
    [self hideCFWbButtons];
    NSString *facebookMsg = [NSString stringWithFormat:@"%@\n%@\n%@\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", bekenystakTitle.text, bekenystakSubject.text, [displayedMessage objectForKey:@"url"]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject facebookShareContent:facebookMsg fromViewController:self];
}

- (IBAction)whatsAppShare {
    [self hideCFWbButtons];
    NSString *contentString = [[NSString stringWithFormat:@"%@\n%@\n",bekenystakTitle.text, bekenystakSubject.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *hymnUrlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[displayedMessage objectForKey:@"url"],NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    NSString *oskofeyaUrlString = [[NSString stringWithFormat:@"\n\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@%@%@",contentString,hymnUrlString,oskofeyaUrlString]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject whatsAppShareURL:url];
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

- (void)hideCFWbButtons {
    btnCopy.hidden = YES;
    btnFb.hidden = YES;
    btnWhtsp.hidden = YES;
    btnShare.hidden = YES;
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

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissBekenystakView:(id)sender {
    [self unloadOldAudioTrackAndResetPlayButton];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


