//
//  YoumBeYoumViewController.m
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/11/15.
//  Copyright (c) 2015 Apptronix. All rights reserved.
//

#import "YoumBeYoumViewController.h"
#import "AppDelegate.h"

@implementation YoumBeYoumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"YoumBeYoum View", @"YoumBeYoum View");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize ViewControllers

    eshba3ViewController = [[Eshba3ViewController alloc] initWithNibName:@"Eshba3View_i5" bundle:nil];
    ettamenViewController = [[EttamenViewController alloc] initWithNibName:@"EttamenView_i5" bundle:nil];
    ektanyViewController = [[EktanyViewController alloc] initWithNibName:@"EktanyView_i5" bundle:nil];
    estamte3ViewController = [[Estamte3ViewController alloc] initWithNibName:@"Estamte3View_i5" bundle:nil];
    es2alViewController = [[Es2alViewController alloc] initWithNibName:@"Es2alView_I5" bundle:nil];
    e3rafViewController = [[E3rafViewController alloc] initWithNibName:@"E3rafView_i5" bundle:nil];
    
   
    // Initialize e3rafWebService
    e3rafWebService = [[E3rafWebService alloc] init];
    [e3rafWebService setE3rafWsDelegate:self];
    // Get Present & Future e3rafMessages
    [e3rafWebService getE3rafMessagesForPresentAndFuture:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    // Are there any Push Notifications
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).pushNotifInfo) {
        if ([[[((AppDelegate *)[UIApplication sharedApplication].delegate).pushNotifInfo objectForKey:@"aps"] objectForKey:@"module"] isEqualToString:@"E3raf"]) {
            // Get Present & Future e3rafMessages
            [e3rafWebService getE3rafMessagesForPresentAndFuture:YES];
            e3rafViewController.shouldHideActivityIndicator = NO;
            [e3rafViewController updateView];
            // Navigate to E3rafView
            [self.navigationController pushViewController:e3rafViewController animated:NO];
            // Clear the Push Notification Message
            ((AppDelegate *)[UIApplication sharedApplication].delegate).pushNotifInfo = nil;
        }
    }
    // Reset btnE3raf
    [btnE3raf setBackgroundImage:[UIImage imageNamed:@"OSK_BtnE3rafNone"] forState:UIControlStateNormal];
    // Check for Today E3raf Messages
    [self checkForTodayE3rafMessages];
    // Navigate to EttamenMsgView
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadEttamenView) {
        [self.navigationController pushViewController:ettamenViewController animated:NO];
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

- (IBAction)loadEttamenView:(id)sender {
    [self showViewController:ettamenViewController];
    [self performSelector:@selector(pushViewController:) withObject:ettamenViewController afterDelay:0.5f];
}

- (IBAction)loadEktanyView:(id)sender {
    ektanyViewController.todayMsgIndex = 1000;
    [self showViewController:ektanyViewController];
    [self performSelector:@selector(pushViewController:) withObject:ektanyViewController afterDelay:0.5f];
}

- (IBAction)loadEstamte3View:(id)sender {
    [self showViewController:estamte3ViewController];
    [self performSelector:@selector(pushViewController:) withObject:estamte3ViewController afterDelay:0.5f];
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



#pragma mark - e3rafMessages Handling Methods

- (void)e3rafWebService:(E3rafWebService *)e3rafWebService errorMessage:(NSString *)errorMsg {
    // Load e3rafMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"e3rafMessages"] != NULL) {
        e3rafViewController.e3rafMessages = [defaults objectForKey:@"e3rafMessages"];
        // Display only current and past Publish Date messages
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        e3rafViewController.e3rafDisplayedMessages = [dateIndexObject extractPresentAndPastPublishDateMessagesFromMessages:[e3rafViewController.e3rafMessages mutableCopy] andCurrentDate:[NSDate date]];
        // Hide Activity Indicator in E3rafView
        e3rafViewController.shouldHideActivityIndicator = YES;
        [e3rafViewController updateView];
    } else {
        // Show Activity Indicator in E3rafView (No Internet)
        e3rafViewController.shouldHideActivityIndicator = NO;
        [e3rafViewController updateView];
    }
    // NSLog(@"e3rafViewController.e3rafDisplayedMessages = %@",e3rafViewController.e3rafDisplayedMessages);
}

- (void)e3rafWebService:(E3rafWebService *)e3rafWebService returnMessages:(NSMutableArray *)returnMsgs {
    // Sort e3rafMessages accordign to date (descendingly)
    e3rafViewController.e3rafMessages = returnMsgs;
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"publish_date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateSort];
    e3rafViewController.e3rafMessages = [NSMutableArray arrayWithArray:[e3rafViewController.e3rafMessages sortedArrayUsingDescriptors:sortDescriptors]];
    // Save e3rafMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[e3rafViewController.e3rafMessages mutableCopy] forKey:@"e3rafMessages"];
    [defaults synchronize];
    // Display only current and past Publish Date messages
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    e3rafViewController.e3rafDisplayedMessages = [dateIndexObject extractPresentAndPastPublishDateMessagesFromMessages:[e3rafViewController.e3rafMessages mutableCopy] andCurrentDate:[NSDate date]];
    // Hide Activity Indicator in E3rafView
    e3rafViewController.shouldHideActivityIndicator = YES;
    [e3rafViewController updateView];
    // Check for Today E3raf Messages
    [self checkForTodayE3rafMessages];
    // NSLog(@"e3rafViewController.e3rafDisplayedMessages = %@",e3rafViewController.e3rafDisplayedMessages);
}

- (void)checkForTodayE3rafMessages {
    // Check if there are messages with today's publish date
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    BOOL areThereMessagesForToday = [dateIndexObject checkForDateInMessages:e3rafViewController.e3rafDisplayedMessages andDate:[NSDate date]];
    if (areThereMessagesForToday == YES) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // NSLog(@"lastDateE3rafWasChecked = %@",[defaults objectForKey:@"lastDateE3rafWasChecked"]);
        if ([defaults objectForKey:@"lastDateE3rafWasChecked"] == NULL) {
            // E3raf Module was never opened (1st Run)
            [btnE3raf setBackgroundImage:[UIImage imageNamed:@"OSK_BtnE3rafNew"] forState:UIControlStateNormal];
        } else {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            // NSLog(@"timeSinceE3rafWasChecked = %f",[[NSDate date] timeIntervalSinceDate:[dateFormat dateFromString:[defaults objectForKey:@"lastDateE3rafWasChecked"]]]);
            if ([[NSDate date] timeIntervalSinceDate:[dateFormat dateFromString:[defaults objectForKey:@"lastDateE3rafWasChecked"]]] > 86400.00) {
                // E3raf Module was not opened today
                [btnE3raf setBackgroundImage:[UIImage imageNamed:@"OSK_BtnE3rafNew"] forState:UIControlStateNormal];
            } else {
                // E3raf Module was already opened today
                [btnE3raf setBackgroundImage:[UIImage imageNamed:@"OSK_BtnE3rafNone"] forState:UIControlStateNormal];
            }
        }
    } else {
        // There are no messages with today's publish date
        [btnE3raf setBackgroundImage:[UIImage imageNamed:@"OSK_BtnE3rafNone"] forState:UIControlStateNormal];
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

#pragma mark - Dismiss Method

- (IBAction)dismissYoumBeYoumView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


