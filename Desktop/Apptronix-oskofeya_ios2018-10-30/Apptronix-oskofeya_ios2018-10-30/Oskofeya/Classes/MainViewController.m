#import "MainViewController.h"
#import "AppDelegate.h"


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"أسقفية الشباب", @"أسقفية الشباب");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    


    // Initialize ViewControllers
    salatyViewController = [[SalatyViewController alloc] initWithNibName:@"SalatyView_i5" bundle:nil];
    moreViewController = [[MoreViewController alloc] initWithNibName:@"MoreView_i5" bundle:nil];
    ektanyViewController = [[EktanyViewController alloc] initWithNibName:@"EktanyView_i5" bundle:nil];
    esma3ViewController = [[Esma3ViewController alloc] initWithNibName:@"Esma3View_i5" bundle:nil];
    ettamenViewController = [[EttamenViewController alloc] initWithNibName:@"EttamenView_i5" bundle:nil];
    shoufViewController = [[ShoufViewController alloc] initWithNibName:@"ShoufView_i5" bundle:nil];
    eshba3ViewController = [[Eshba3ViewController alloc] initWithNibName:@"Eshba3View_i5" bundle:nil];
    es2alViewController = [[Es2alViewController alloc] initWithNibName:@"Es2alView_I5" bundle:nil];
    e3rafViewController = [[E3rafViewController alloc] initWithNibName:@"E3rafView_i5" bundle:nil];
    
    // Initialize pushTokenWebService
    pushTokenWebService = [[PushTokenWebService alloc] init];
    [pushTokenWebService setPushTokenWsDelegate:self];
     // Update Device Push Token
    NSString *deviceToken;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).devicePushToken) {
        deviceToken = [NSString stringWithFormat:@"%@",((AppDelegate *)[UIApplication sharedApplication].delegate).devicePushToken];
        deviceToken = [[deviceToken componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" <>"]] componentsJoinedByString:@""];
    }
    [pushTokenWebService updateDevicePushTokenWithToken:[defaults objectForKey:@"authToken"] andPushToken:deviceToken];
    
    
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [dirPaths objectAtIndex:0];
    NSString *filePath = [documentDir stringByAppendingPathComponent:@"oskofia.txt"];

    NSFileManager *fileManagaer = [NSFileManager defaultManager];
    if([fileManagaer fileExistsAtPath:filePath])
    {
    }
    else {
        NSLog (@"File not found, file will be created");
    [fileManagaer createFileAtPath:filePath contents:nil attributes:nil];
            NSLog(@"Create file returned NO");
            
            //[fileManagaer WriteToStringFile:]
            NSString * zStr = [[NSString alloc]init];

        zStr = [zStr stringByAppendingFormat:@"%d,%d\n",1,3];
        
            [zStr writeToFile:filePath
                   atomically:YES
                     encoding:NSUTF8StringEncoding error:NULL];
            
        
        }
    
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDir = [dirPaths objectAtIndex:0];
    filePath = [documentDir stringByAppendingPathComponent:@"oskofianew.txt"];
    
    fileManagaer = [NSFileManager defaultManager];
    if([fileManagaer fileExistsAtPath:filePath])
    {
    }
    else {
        NSLog (@"File not found, file will be created");
        [fileManagaer createFileAtPath:filePath contents:nil attributes:nil];
        NSLog(@"Create file returned NO");
        
        //[fileManagaer WriteToStringFile:]
        NSString * zStr = [[NSString alloc]init];
        
        zStr = [zStr stringByAppendingFormat:@"%d,%d\n",40,1];
        
        [zStr writeToFile:filePath
               atomically:YES
                 encoding:NSUTF8StringEncoding error:NULL];
        
        
    }
    //}
}

- (void)viewWillAppear:(BOOL)animated {
    // Are there any Push Notifications
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).pushNotifInfo) {
         if ([[[((AppDelegate *)[UIApplication sharedApplication].delegate).pushNotifInfo objectForKey:@"aps"] objectForKey:@"module"] isEqualToString:@"E3raf"]) {
            // Navigate to YoumBeYoumView
            [self.navigationController pushViewController:eshba3ViewController animated:NO];
        } else {
            // Remain in the Main View (Do nothing)
        }
    }
    // Navigate to EttamenMsgView
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadEttamenView) {
        [self.navigationController pushViewController:eshba3ViewController animated:NO];
    }
    // Navigate to Be2engylakView
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadBe2engylakView) {
        [self.navigationController pushViewController:eshba3ViewController animated:NO];
    }
    
    
    
}

#pragma mark - Buttons Methods

- (IBAction)loadEshba3View:(id)sender {
    [self showViewController:eshba3ViewController];
    [self performSelector:@selector(pushViewController:) withObject:eshba3ViewController afterDelay:0.5f];
}

- (IBAction)loadSalatyView:(id)sender {
    [self showViewController:salatyViewController];
    [self performSelector:@selector(pushViewController:) withObject:salatyViewController afterDelay:0.5f];
}

- (IBAction)openPlayToBuildGame:(id)sender {

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"P2B://app"]]) {
       // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"P2B://app"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/p2b/id1137587878?ls=1&mt=8"]];
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/p2b/id1137587878?ls=1&mt=8"]];
    }
  
}

- (IBAction)openHoneyGame:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Honey://app"]]) {
        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"P2B://app"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/honey-yb/id1407293007?ls=1&mt=8"]];
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/honey-yb/id1407293007?ls=1&mt=8"]];
    }
   
}



- (IBAction)loadMoreView:(id)sender {
    [self showViewController:moreViewController];
    [self performSelector:@selector(pushViewController:) withObject:moreViewController afterDelay:0.5f];
}

- (IBAction)loadEsma3View:(id)sender {
    esma3ViewController.todayMsgIndex = 1000;
    [self showViewController:esma3ViewController];
    [self performSelector:@selector(pushViewController:) withObject:esma3ViewController afterDelay:0.5f];
}

- (IBAction)loadEttamenView:(id)sender {
    
    
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
        ettamenMsgViewController = [[EttamenMsgViewController alloc] initWithNibName:@"EttamenMsgView_i5" bundle:nil];
        ettamenMsgViewController.feelingNameStr = [testArray objectAtIndex:1];
        ettamenMsgViewController.feelingMsgBody = [testArray objectAtIndex:2];
        ettamenMsgViewController.feelingMsgQuote = [testArray objectAtIndex:3];
        
        [self showViewController:ettamenMsgViewController];
        [self performSelector:@selector(pushViewController:) withObject:ettamenMsgViewController afterDelay:0.5f];
    }else
    {

        [self showViewController:ettamenViewController];
        [self performSelector:@selector(pushViewController:) withObject:ettamenViewController afterDelay:0.5f];
      
    }

}

- (IBAction)loadEktanyView:(id)sender {
    ektanyViewController.todayMsgIndex = 1000;
    [self showViewController:ektanyViewController];
    [self performSelector:@selector(pushViewController:) withObject:ektanyViewController afterDelay:0.5f];
}

- (IBAction)loadShoufView:(id)sender {
    shoufViewController.todayMsgIndex = 1000;
    [self showViewController:shoufViewController];
    [self performSelector:@selector(pushViewController:) withObject:shoufViewController afterDelay:0.5f];
}

- (IBAction)loadEs2alView:(id)sender {
    es2alViewController.todayMsgIndex = 1000;
    [self showViewController:es2alViewController];
    [self performSelector:@selector(pushViewController:) withObject:es2alViewController afterDelay:0.5f];
}


- (IBAction)loadE3rafView:(id)sender {
    e3rafViewController.navigatingFromMain = YES;
    [self showViewController:e3rafViewController];
    [self performSelector:@selector(pushViewController:) withObject:e3rafViewController afterDelay:0.5f];
}

#pragma mark - pushTokenWebService Handling Methods

- (void)pushTokenWebService:(PushTokenWebService *)pushTokenWebService errorMessage:(NSString *)errorMsg {
    // Display Error Message
}

- (void)pushTokenWebService:(PushTokenWebService *)pushTokenWebService returnMessage:(NSDictionary *)returnMsg {
    NSLog(@"returnMsg: %@",returnMsg);
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

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


