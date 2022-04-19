
#import "EttamenViewController.h"
#import "AppDelegate.h"

#define FEELING_FACE1_TAG 101
#define FEELING_FACE2_TAG 102
#define FEELING_FACE3_TAG 103
#define FEELING_FACE4_TAG 104
#define FEELING_FACE5_TAG 105
#define FEELING_FACE6_TAG 106
#define FEELING_FACE7_TAG 107
#define FEELING_FACE8_TAG 108

bool isGrantedNotificationAccess;

@implementation EttamenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"إطمن", @"إطمن");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        isGrantedNotificationAccess = granted;
    }];
    // Initialize ettamenMsgViewController
    ettamenMsgViewController = [[EttamenMsgViewController alloc] initWithNibName:@"EttamenMsgView_i5" bundle:nil];
    // Initialize ettamenWebService
    ettamenWebService = [[EttamenWebService alloc] init];
   
    // Initialize Feelings Arrays
    
     ettamenFeelingsNames = [[NSArray alloc] initWithObjects:@"الرفض", @"الضيق", @"الشكر", @"الضعف", @"عدم الأمان", @" الاحتياج للحب",@"الظلم", @"الغضب", nil];
    ettamenFeelingMsgs = [[NSMutableArray alloc] init];
    // Get ettamenMessages
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [dirPaths objectAtIndex:0];
    NSString *filePath = [documentDir stringByAppendingPathComponent:@"etammen.txt"];
    NSString * xmlString = @"";
    NSFileManager *fileManagaer = [NSFileManager defaultManager];
    if([fileManagaer fileExistsAtPath:filePath])
    {
        xmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    }
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy:MM:dd"];
    NSString *dateString = [date stringFromDate:[NSDate date]];
    NSArray *testArray = [xmlString componentsSeparatedByString:@";;;"];
    if(testArray.count > 0 && [[testArray objectAtIndex:0] isEqualToString:dateString])
    {
        feelingFace1.enabled = NO;
        feelingFace2.enabled = NO;
        feelingFace3.enabled = NO;
        feelingFace4.enabled = NO;
        feelingFace5.enabled = NO;
        feelingFace6.enabled = NO;
        feelingFace7.enabled = NO;
        feelingFace8.enabled = NO;
        
        
    }
    else
    {
        [ettamenWebService setEttamenWebServiceDelegate:self];
        [ettamenWebService getEttamenMessages];
        // Display Scheduled Message
        if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadEttamenView) {
            [self displayScheduledMessage];
        }
        // Update Buttons Appearance
        if (ettamenMessages != NULL) {
            [self shouldEnableOrDisableFeelings];
        } else {
            //[self shouldEnableOrDisableFeelings];
            [self disableFacesAndShowOverlays];
        }
       
    }
    
   /* // Display Scheduled Message
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadEttamenView) {
        [self displayScheduledMessage];
    }
    // Update Buttons Appearance
    if (ettamenMessages != NULL) {
        [self shouldEnableOrDisableFeelings];
    } else {
         //[self shouldEnableOrDisableFeelings];
        [self disableFacesAndShowOverlays];
    }*/
}

- (void)displayScheduledMessage {

}

#pragma mark - ettamenMessages Handling Methods

- (void)ettamenWebService:(EttamenWebService *)ettamenWebService errorMessage:(NSString *)errorMsg {
    // Load ettamenMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ettamenMessages"] != NULL) {
        [self shouldEnableOrDisableFeelings];
        ettamenMessages = [defaults objectForKey:@"ettamenMessages"];
    } else {
        [AppDelegate showAlertView:@"برجاء التأكد من الاتصال بالانترنت"];
    }
}

- (void)ettamenWebService:(EttamenWebService *)ettamenWebService returnMessages:(NSMutableArray *)returnMsgs {
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [dirPaths objectAtIndex:0];
    NSString *filePath = [documentDir stringByAppendingPathComponent:@"etammen.txt"];
    NSString * xmlString = @"";
    NSFileManager *fileManagaer = [NSFileManager defaultManager];
    if([fileManagaer fileExistsAtPath:filePath])
    {
        xmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    }
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy:MM:dd"];
    NSString *dateString = [date stringFromDate:[NSDate date]];
    NSArray *testArray = [xmlString componentsSeparatedByString:@";;;"];
    if(testArray.count > 0 && [[testArray objectAtIndex:0] isEqualToString:dateString])
    {
    }
    else
    {
        [self shouldEnableOrDisableFeelings];
        // Retrieve ettamenMessages
        ettamenMessages = returnMsgs;
        // Save ettamenMessages
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[ettamenMessages mutableCopy] forKey:@"ettamenMessages"];
        [defaults synchronize];
    }
}

#pragma mark - Feelings Buttons Methods

- (IBAction)loadEttamenMsgView:(id)sender {
    [self disableFacesAndShowOverlays];
    // Choose a random message
    [self extractEttamenFeelingMsgsFromEttamenMessagesForId:sender];
    int randomIntNumber;
    randomIntNumber = [self chooseRandomIndex];
    ettamenMsgViewController.feelingNameStr = [ettamenFeelingsNames objectAtIndex:([sender tag] - 101)];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [dirPaths objectAtIndex:0];
    NSString *filePath = [documentDir stringByAppendingPathComponent:@"etammen.txt"];
    NSString * xmlString = @"";
    NSFileManager *fileManagaer = [NSFileManager defaultManager];
    if([fileManagaer fileExistsAtPath:filePath])
    {
        xmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    }
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy:MM:dd"];
    NSString *dateString = [date stringFromDate:[NSDate date]];
     NSArray *testArray = [xmlString componentsSeparatedByString:@";;;"];
    if(testArray.count > 0 && [[testArray objectAtIndex:0] isEqualToString:dateString])
    {

    }else
    {
        NSString * zStr = [[NSString alloc]init];
        
        zStr = [zStr stringByAppendingFormat:@"%@;;;%@;;;%@;;;%@",dateString,[ettamenFeelingsNames objectAtIndex:([sender tag] - 101)],[[ettamenFeelingMsgs objectAtIndex:randomIntNumber] objectForKey:@"body"],[[ettamenFeelingMsgs objectAtIndex:randomIntNumber] objectForKey:@"quote"]];
        xmlString = zStr;
        [zStr writeToFile:filePath
               atomically:YES
                 encoding:NSUTF8StringEncoding error:NULL];
        if(isGrantedNotificationAccess)
        {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = [NSString stringWithFormat:@"لو انت لسه حاسس بـ \"%@\"، ادخل اقرأ الرساله",ettamenMsgViewController.feelingNameStr];
            content.subtitle = [ettamenFeelingsNames objectAtIndex:([sender tag] - 101)];
            content.body = [[ettamenFeelingMsgs objectAtIndex:randomIntNumber] objectForKey:@"body"];
            content.sound = [UNNotificationSound defaultSound];
            
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:7200 repeats:NO];
            
            UNNotificationRequest *request = [UNNotificationRequest                                                                                                    requestWithIdentifier:@"UYLLocalNotification" content:content trigger:trigger];
            
            [center addNotificationRequest:request withCompletionHandler:nil];
        }
        
    }
   
    ettamenMsgViewController.feelingMsgBody = [[ettamenFeelingMsgs objectAtIndex:randomIntNumber] objectForKey:@"body"];
    ettamenMsgViewController.feelingMsgQuote = [[ettamenFeelingMsgs objectAtIndex:randomIntNumber] objectForKey:@"quote"];
    // Choose another random message for the Alarm
    previousRandomNumber = randomIntNumber;
    randomIntNumber = [self chooseRandomIndex];
    [self generateEttamenNotifWithFeelingName:ettamenMsgViewController.feelingNameStr andMsgNumber:randomIntNumber];
    // Load ettamenMsgViewController
    [self showViewController:ettamenMsgViewController];
    [self performSelector:@selector(pushViewController:) withObject:ettamenMsgViewController afterDelay:0.5f];
    [ettamenFeelingMsgs removeAllObjects];
}

- (void)extractEttamenFeelingMsgsFromEttamenMessagesForId:(id)sender {
    for (NSDictionary *tempDict in ettamenMessages) {
        if ([[tempDict objectForKey:@"feeling"] isEqualToString:[NSString stringWithFormat:@"%d",([sender tag] - 100)]]) {
            [ettamenFeelingMsgs addObject:tempDict];
        }
    }
}

- (int)chooseRandomIndex {
    int randomIntNumber;
    srandomdev();
    randomIntNumber = random()%[ettamenFeelingMsgs count];
    if (randomIntNumber == previousRandomNumber) {
        randomIntNumber = [self chooseRandomIndex];
    }
    return randomIntNumber;
}

- (void)generateEttamenNotifWithFeelingName:(NSString *)feelingName andMsgNumber:(int)randomNumber {

}

#pragma mark - Faces & Overlays Methods

- (void)shouldEnableOrDisableFeelings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (([defaults boolForKey:@"shouldEnableFeelings"] == YES) || ([[NSDate date] timeIntervalSinceDate:[defaults objectForKey:@"fireDate"]] > 0)) {
        [self enableFacesAndHideOverlays];
    } else {
        [self disableFacesAndShowOverlays];
    }
}

- (void)enableFacesAndHideOverlays {
    feelingFace1.enabled = YES;
    feelingFace2.enabled = YES;
    feelingFace3.enabled = YES;
    feelingFace4.enabled = YES;
    feelingFace5.enabled = YES;
    feelingFace6.enabled = YES;
    feelingFace7.enabled = YES;
    feelingFace8.enabled = YES;
}

- (void)disableFacesAndShowOverlays {
    feelingFace1.enabled = NO;
    feelingFace2.enabled = NO;
    feelingFace3.enabled = NO;
    feelingFace4.enabled = NO;
    feelingFace5.enabled = NO;
    feelingFace6.enabled = NO;
    feelingFace7.enabled = NO;
    feelingFace8.enabled = NO;
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

#pragma mark - Dismiss Methods

- (IBAction)dismissEttamenView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

