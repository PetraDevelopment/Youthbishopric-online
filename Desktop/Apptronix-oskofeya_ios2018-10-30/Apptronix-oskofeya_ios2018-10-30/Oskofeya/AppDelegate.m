
#import "AppDelegate.h"

#import "PushTokenWebService.h"
#import "MailBoxWebService.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate() <UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate

@synthesize fbSession;
@synthesize shouldLoadEttamenView;
@synthesize devicePushToken;
@synthesize pushNotifInfo;
@synthesize shouldLoadWriteNoteView;
@synthesize shouldLoadBe2engylakView;
@synthesize shouldReturnToAgpeyaViewFromWNView;

#pragma mark - Application Status Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Initialize splashViewController
    splashViewController = [[SplashViewController alloc] initWithNibName:@"SplashView" bundle:nil];
    // Initialize NavigationController
    UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:splashViewController];
    [rootNavigationController setNavigationBarHidden:YES];
    self.window.rootViewController = rootNavigationController;
    [FBLoginView class];
    [self.window makeKeyAndVisible];
    // Are there any Local Notifications
/*    UILocalNotification *localNotifFromLaunchOptions = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotifFromLaunchOptions.repeatInterval == NSEraCalendarUnit) {
        // Navigate to EttamenMsgView
        shouldLoadEttamenView = YES;
    }
    // Register for Push Notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];*/
    // Retrieve Push Notifications
    pushNotifInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    //facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center  willPresentNotification:(UNNotification *)notification     withCompletionHandler:(void (^)        (UNNotificationPresentationOptions))completionHandler
{
    UNNotificationPresentationOptions presentationOptions =         UNNotificationPresentationOptionSound      +UNNotificationPresentationOptionAlert;
    completionHandler(presentationOptions);
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.fbSession];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.fbSession close];
}

#pragma mark - Push Notifications Methods

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    devicePushToken = deviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    pushNotifInfo = [userInfo mutableCopy];
}

#pragma mark - Local Notifications Methods

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
    if (notif.repeatInterval == NSEraCalendarUnit) {
        // Navigate to EttamenMsgView
        shouldLoadEttamenView = YES;
        [splashViewController viewDidAppear:YES];
    }
}

#pragma mark - Facebook Session Methods

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // Extract token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.fbSession];
    
    
   /* BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:optind[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;*/
}

#pragma mark - AlertView Methods

+ (void)showAlertView:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"أسقفية الشباب" message:[NSString stringWithFormat:@"\n%@",message] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:4.0f];
    [alertView show];
}

+ (void)dismissAlertView:(UIAlertView *)alertView {
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}




@end


