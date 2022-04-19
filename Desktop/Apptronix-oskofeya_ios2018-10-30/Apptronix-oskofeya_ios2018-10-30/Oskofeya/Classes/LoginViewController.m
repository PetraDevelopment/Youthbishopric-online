#import "LoginViewController.h"
#import "AppDelegate.h"

#define TXT_EMAIL_TAG 111
#define TXT_PASSWORD_TAG 222

@interface LoginViewController ()<FBSDKLoginButtonDelegate>

@end

@implementation LoginViewController

@synthesize loginViewDelegate;
@synthesize loginFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Login View", @"Login View");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    throughFbFlag = NO;
    [textEmail isFirstResponder];
   // FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"public_profile", @"email"];

    /*[loginButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"test"]
                           forState:UIControlStateNormal];
    

    [loginButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"tefffffst"]
                           forState:UIControlStateFocused];
    [loginButton setTitle:@"ddgfgdfgdf" forState:UIControlStateNormal];*/
    loginButton.delegate = self;

   // [self.view addSubview:loginButton];
    
    registrationViewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationView_i5" bundle:nil];
    // Set Delegates
    [textEmail setDelegate:self];
    [textPassword setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /*[loginButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"test"]
                           forState:UIControlStateNormal];
    
    
    [loginButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"tefffffst"]
                           forState:UIControlStateFocused];
    [loginButton setTitle:@"ddgfgdfgdf" forState:UIControlStateNormal];*/

}


- (void)  loginButton:(FBSDKLoginButton *) loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
error:(NSError *)error{
    if ([FBSDKAccessToken currentAccessToken]) {

        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 throughFbFlag = YES;
                 emailStr = [result objectForKey:@"email"];
                 textEmail.text = emailStr;

                 
                 NSLog(@"%hhd - Email = %@",throughFbFlag,emailStr);
                 [self loginWebServiceHandling];
                 NSLog(@"user:%@", result);
             }
         }];
    }
    //use your custom code here
    //redirect after successful login
}
- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    //use your custom code here
    //redirect after successful logout
    NSLog(@"");
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputModeDidChange:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];
    if ([registrationViewController.loginFlag isEqualToString:@"hideLogin"]) {
        [self dismissLoginView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextInputCurrentInputModeDidChangeNotification object:nil];
}

#pragma mark - TextFields Methods

- (void)textInputModeDidChange:(NSNotification *)notif {
    UITextField *textField;
    if ([textEmail isFirstResponder]) {
        textField = textEmail;
    } else if ([textPassword isFirstResponder]) {
        textField = textPassword;
    }
    [textField resignFirstResponder];
    [self performSelector:@selector(becomeFirstResponder:) withObject:textField afterDelay:0.3f];
   // if ([[UITextInputMode currentInputMode].primaryLanguage isEqualToString:@"ar"]) {
        textEmail.textAlignment = NSTextAlignmentRight;
        textPassword.textAlignment = NSTextAlignmentRight;
        textEmail.placeholder = @"البريد الإلكتروني";
        textPassword.placeholder = @"كلمة المرور";
    /*} else {
        textEmail.textAlignment = NSTextAlignmentLeft;
        textPassword.textAlignment = NSTextAlignmentLeft;
        textEmail.placeholder = @"E-mail";
        textPassword.placeholder = @"Password";
    }*/
}

- (void)becomeFirstResponder:(UITextField *)textField {
    [textField becomeFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Disable loginButton
    loginButton.enabled = NO; loginButton.alpha = 0.5;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == TXT_EMAIL_TAG) {
        emailStr = textEmail.text;
    } else if (textField.tag == TXT_PASSWORD_TAG) {
        passwordStr = textPassword.text;
    }
    // Enable loginButton
    loginButton.enabled = YES; loginButton.alpha = 1.0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.tag == TXT_EMAIL_TAG) {
        [textPassword becomeFirstResponder];
    }
    return YES;
}

- (IBAction)hideKeyboard:(id)sender {
    [textEmail resignFirstResponder];
    [textPassword resignFirstResponder];
}

#pragma mark - Buttons Methods

- (IBAction)loginButton:(id)sender {
    if (!emailStr || [emailStr isEqualToString:@""]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"برجاء إدخال البريد الإلكتروني" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
        [textEmail becomeFirstResponder];
    } else {
        if (!passwordStr || [passwordStr isEqualToString:@""]) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"برجاء إدخال كلمة المرور" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet showInView:self.view];
            [textPassword becomeFirstResponder];
        } else {
            [self loginWebServiceHandling];
        }
    }
}

- (IBAction)forgotPassword:(id)sender {
    if (!emailStr || [emailStr isEqualToString:@""]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"برجاء إدخال البريد الإلكتروني" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
        [textEmail becomeFirstResponder];
    } else {
        [self forgotPassWebServiceHandling];
    }
}

/*- (IBAction)loadFBLoginView:(id)sender {
    
   if (!FBSession.activeSession.isOpen) {
        // Session is closed
        NSArray *permissions = [NSArray arrayWithObjects:@"email",nil];
       
       
        [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             if (error) {
                 NSLog(@"Error = %@",error.localizedDescription);
             } else if (session.isOpen) {
                 [self loadFBLoginView:sender];
             }
         }];
        return;
    }



    // Session is open
    [[FBRequest requestForMe] startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
        NSLog(@"error");
        NSLog(@"%@", error);
        if (!error) {
            throughFbFlag = YES;
            emailStr = [user objectForKey:@"email"];
            textEmail.text = emailStr;

            
        
            
            
            NSLog(@"%hhd - Email = %@",throughFbFlag,emailStr);
            [self loginWebServiceHandling];
        }
    }];
    // Display fbLoginView
    FBLoginView *fbLoginView = [[FBLoginView alloc] init];
    fbLoginView.frame = CGRectOffset(fbLoginView.frame, 5, 5);
    fbLoginView.readPermissions = @[@"public_profile", @"email"];
    fbLoginView.isAccessibilityElement = true;

    fbLoginView.delegate = self;
    [fbLoginView sizeToFit];
    
    
}
*/
/*
- (IBAction)verificationMailButton:(id)sender {
 
}
*/

- (IBAction)loadRegistrationView:(id)sender {
    registrationViewController.loginFlag = loginFlag;
    registrationViewController.passwordStr = passwordStr;
    registrationViewController.emailStr = emailStr;
    registrationViewController.throughFbFlag = throughFbFlag;
    [self showViewController:registrationViewController];
    [self performSelector:@selector(pushViewController:) withObject:registrationViewController afterDelay:0.5f];
}

#pragma mark - loginWebService Methods

- (void)loginWebServiceHandling {
    // Logging In
    [aiMsg setText:@""];
    aiView.hidden = NO;
    // Initialize loginWebService
    loginWebService = [[LoginWebService alloc] init];
    [loginWebService setLoginWebServiceDelegate:self];
    int fbFlag = (throughFbFlag ? 1 : 0);

    [loginWebService loginWithEmail:emailStr andPassword:passwordStr andFbFlag:fbFlag];
}

- (void)loginWebService:(LoginWebService *)loginWebService errorMessage:(NSString *)errorMsg {
    // Display Error Message
    [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
    [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الإتصال بالانترنت",errorMsg]];
    aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    aiMsg.numberOfLines = 4;
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
}

- (void)loginWebService:(LoginWebService *)loginWebService returnMessage:(NSDictionary *)returnMsg {
    NSLog(@"returnMsg: %@",returnMsg);
    if ([returnMsg objectForKey:@"success"] == [NSNumber numberWithBool:YES]) {
        // Successful Login
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[[returnMsg objectForKey:@"auth_token"] mutableCopy] forKey:@"authToken"];
        [defaults synchronize];
        [self loginMethod];
    } else {
        if ([[returnMsg objectForKey:@"message"] isEqualToString:@"User does not exist"]) {
            [self loadRegistrationView:nil];
        }
        // Login failed
        [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
        [aiMsg setText:[returnMsg objectForKey:@"message"]];
        aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:25];
        aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
        aiMsg.numberOfLines = 4;
        [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
    }
}

- (void)loginMethod {
    [aiView removeFromSuperview];
    aiView = nil;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"مرحبا بك" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    [self dismissLoginView];
}

#pragma mark - forgotPassWebService Methods

- (void)forgotPassWebServiceHandling {
    // Sending Forgot Pass
    [aiMsg setText:@""];
    aiView.hidden = NO;
    // Initialize forgotPassWebService
    forgotPassWebService = [[ForgotPassWebService alloc] init];
    [forgotPassWebService setForgotPassWebServiceDelegate:self];
    [forgotPassWebService sendForgotPasswordForEmail:emailStr];
}

- (void)forgotPassWebService:(ForgotPassWebService *)forgotPassWebService errorMessage:(NSString *)errorMsg {
    // Display Error Message
    [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
    [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الإتصال بالانترنت",errorMsg]];
    aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    aiMsg.numberOfLines = 4;
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
}

- (void)forgotPassWebService:(ForgotPassWebService *)forgotPassWebService returnMessage:(NSDictionary *)returnMsg {
    // NSLog(@"returnMsg: %@",returnMsg);
    if ([returnMsg objectForKey:@"success"] == [NSNumber numberWithBool:YES]) {
         // Successful ForgotPass
        [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
        [aiMsg setText:[NSString stringWithFormat:@"تم ارسال بريد اليكتروني به إرشادات لإعادة كلمة المرور"]];
        aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:25];
        aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
        aiMsg.numberOfLines = 4;
        [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
    } else {
         // ForgotPass failed
         [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
         [aiMsg setText:[returnMsg objectForKey:@"email"]]; 
         aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:25];
         aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
         aiMsg.numberOfLines = 4;
         [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
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

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    aiView.hidden = YES;
}

- (void)dismissLoginView {
    [self.loginViewDelegate loginViewController:self setLoginFlag:@"hideLogin"];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


