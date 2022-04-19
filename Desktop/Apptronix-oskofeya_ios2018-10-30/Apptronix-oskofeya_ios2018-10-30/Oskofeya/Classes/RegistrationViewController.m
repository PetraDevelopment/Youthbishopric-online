#import "RegistrationViewController.h"
#import "AppDelegate.h"

#define TXT_USERNAME_TAG 111
#define TXT_PASSWORD_TAG 222
#define TXT_CONFPASS_TAG 333
#define TXT_EMAIL_TAG 444

@implementation RegistrationViewController

@synthesize loginFlag;
@synthesize usernameStr;
@synthesize passwordStr;
@synthesize emailStr;
@synthesize throughFbFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Registration View", @"Registration View");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set Delegates
    [textUserName setDelegate:self];
    [textEmail setDelegate:self];
    [textPassword setDelegate:self];
    [textConfPass setDelegate:self];
    ageGroupsButton.layer.cornerRadius = 8;
    ageGroupsButton.layer.borderWidth = 2.0;
    ageGroupsButton.layer.masksToBounds = true;
    
    // agePickerViewController initialization
    if (agePickerViewController == nil) {
        agePickerViewController = [[AgePickerViewController alloc] init];
	}
    agePickerViewController.ageGroupsList = [[NSArray alloc] initWithObjects:@"تحـت 18", @"18 - 25", @"26 - 35", @"36 - 45", @"فـوق 45", @"أخـرى", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputModeDidChange:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowMethod:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    // Set the textFields with values from LoginView
    textUserName.text = usernameStr;
    textEmail.text = emailStr;
    textPassword.text = passwordStr;
    textConfPass.text = passwordStr;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextInputCurrentInputModeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - TextFields Methods

- (void)textInputModeDidChange:(NSNotification *)notif {
    UITextField *textField;
    if ([textUserName isFirstResponder]) {
        textField = textUserName;
    } else if ([textEmail isFirstResponder]) {
        textField = textEmail;
    } else if ([textPassword isFirstResponder]) {
        textField = textPassword;
    } else if ([textConfPass isFirstResponder]) {
        textField = textConfPass;
    }
    [textField resignFirstResponder];
    [self performSelector:@selector(becomeFirstResponder:) withObject:textField afterDelay:0.3f];
    [self checkKeyboardLanguageAndAdjustAlignment:textField];
}

- (void)checkKeyboardLanguageAndAdjustAlignment:(UITextField *)textField {
    //if (!(textField.tag == TXT_EMAIL_TAG)) {
      //  if ([[UITextInputMode currentInputMode].primaryLanguage isEqualToString:@"ar"]) {
            textUserName.textAlignment = NSTextAlignmentRight;
            textEmail.textAlignment = NSTextAlignmentRight;
            textPassword.textAlignment = NSTextAlignmentRight;
            textConfPass.textAlignment = NSTextAlignmentRight;
            textUserName.placeholder = @"ادخل الإسم";
            textEmail.placeholder = @"ادخل بريدك الإلكتروني";
            textPassword.placeholder = @"ادخل كلمة المرور";
            textConfPass.placeholder = @"تأكيد كلمة المرور";
       /* } else {
            textUserName.textAlignment = NSTextAlignmentLeft;
            textEmail.textAlignment = NSTextAlignmentLeft;
            textPassword.textAlignment = NSTextAlignmentLeft;
            textConfPass.textAlignment = NSTextAlignmentLeft;
            textUserName.placeholder = @"Enter your name";
            textEmail.placeholder = @"Enter your E-mail";
            textPassword.placeholder = @"Pick a password";
            textConfPass.placeholder = @"Retype password";
        }*/
    //}
}

- (void)becomeFirstResponder:(UITextField *)textField {
    [textField becomeFirstResponder];
}

- (void)keyboardWillShowMethod:(NSNotification *)notif {
    [self checkKeyboardLanguageAndAdjustAlignment:nil];
    NSDictionary *infoDictionary = [notif userInfo];
    NSValue *keyboardValue = [infoDictionary objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSizeVariable = [keyboardValue CGRectValue].size;
    float bottomPoint = 0;
    if (textConfPass.editing) {
        bottomPoint = (textConfPass.frame.origin.y + textConfPass.frame.size.height + 10);
    }
    viewScrollAmount = keyboardSizeVariable.height - (self.view.frame.size.height - bottomPoint);
    if (viewScrollAmount > 0) {
        moveViewUp = YES;
        [self scrollViewMethod:YES];
    } else {
        moveViewUp = NO;
    }
}

- (void)scrollViewMethod:(BOOL)movedUpValue {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rectVariable = self.view.frame;
    if (movedUpValue) {
        rectVariable.origin.y -= viewScrollAmount;
    } else {
        rectVariable.origin.y += viewScrollAmount;
        moveViewUp = NO;
    }
    self.view.frame = rectVariable;
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Disable registerButton
    registerButton.enabled = NO; registerButton.alpha = 0.5;
    // Disable ageGroupButton
    ageGroupsButton.enabled = NO; ageGroupsButton.alpha = 0.5;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == TXT_USERNAME_TAG) {
        usernameStr = textUserName.text;
    } else if (textField.tag == TXT_EMAIL_TAG) {
        emailStr = textEmail.text;
    } else if (textField.tag == TXT_PASSWORD_TAG) {
        passwordStr = textPassword.text;
    } else if (textField.tag == TXT_CONFPASS_TAG) {
        confPassStr = textConfPass.text;
    }
    // Enable registerButton
    registerButton.enabled = YES; registerButton.alpha = 1.0;
    // Enable ageGroupButton
    ageGroupsButton.enabled = YES; ageGroupsButton.alpha = 1.0;
    [self hideKeyboard:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.tag == TXT_USERNAME_TAG) {
        [textEmail becomeFirstResponder];
    } else if (textField.tag == TXT_EMAIL_TAG) {
        [textPassword becomeFirstResponder];
    } else if (textField.tag == TXT_PASSWORD_TAG) {
        [textConfPass becomeFirstResponder];
    }
    return YES;
}

- (IBAction)hideKeyboard:(id)sender {
    [textUserName resignFirstResponder];
    [textEmail resignFirstResponder];
    [textPassword resignFirstResponder];
    [textConfPass resignFirstResponder];
    if (moveViewUp) {
        [self scrollViewMethod:NO];
    }
}

#pragma mark - Age Picker Methods

- (int)extractRowIndexFromPicker:(NSString *)ageGroupStr {
    int rowIndex = 0, retRowIndex = 0;
    for (NSString *tempStr in agePickerViewController.ageGroupsList) {
        if ([tempStr isEqualToString:ageGroupStr]) {
            retRowIndex  = rowIndex;
        }
        rowIndex ++;
    }
    return retRowIndex;
}

- (IBAction)selectAgeGroup:(id)sender {
    ageGroupsButton.enabled = NO; ageGroupsButton.alpha = 0.5;
    textUserName.enabled = NO; textUserName.alpha = 0.5;
    textEmail.enabled = NO; textEmail.alpha = 0.5;
    textPassword.enabled = NO; textPassword.alpha = 0.5;
    textConfPass.enabled = NO; textConfPass.alpha = 0.5;
    float pickerViewHeight = 216;
    [agePickerViewController.view setFrame:CGRectMake(0, self.view.frame.size.height, agePickerViewController.view.frame.size.width,pickerViewHeight)];
    agePickerViewController.view.backgroundColor = [UIColor whiteColor]; // blackColor
    agePickerViewController.view.tag = 254; // 2nd tagged view in the hierarcy
    agePickerViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(subjectPickerDoneButton)];
    agePickerViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(subjectPickerDismissButton)];
    [self.view addSubview:agePickerViewController.view];
    // Customize Picker View
    agePickerViewController.agePicker = [[UIPickerView alloc] init];
    [agePickerViewController.agePicker setDelegate: agePickerViewController];
    agePickerViewController.agePicker.showsSelectionIndicator = YES;
    agePickerViewController.agePicker.tag = 255; // 3rd tagged view in the hierarcy
    // Select the selectedAge
    int selectedRow = [self extractRowIndexFromPicker:agePickerViewController.selectedAge];
    [agePickerViewController.agePicker selectRow:selectedRow inComponent:0 animated:YES];
    [agePickerViewController.view addSubview:agePickerViewController.agePicker];
    // Customize navigationController
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    [navigationController pushViewController:agePickerViewController animated:YES];
    navigationController.view.frame = CGRectMake(0, self.view.frame.size.height, 320, 260);
    navigationController.view.tag = 253; // 1st tagged view in the hierarcy
    agePickerViewController.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent; // UIBarStyleBlack
    agePickerViewController.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    agePickerViewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.view addSubview:navigationController.view];
    // Animate Transition
    [UIView animateWithDuration:0.5 animations:^ {
        [navigationController.view setFrame:CGRectMake(0,(self.view.frame.size.height - navigationController.view.frame.size.height), navigationController.view.frame.size.width, navigationController.view.frame.size.height)];
    }];
}

- (void)subjectPickerDoneButton {
    if (agePickerViewController.selectedAge != nil) {
        [ageGroupsButton setTitle:agePickerViewController.selectedAge forState:UIControlStateNormal];
    }
    [self dismissSubjectPickerNavigationControllerAnimated:YES];
}

- (void)subjectPickerDismissButton {
    [self dismissSubjectPickerNavigationControllerAnimated:YES];
}

- (void)dismissSubjectPickerNavigationControllerAnimated:(BOOL)animated {
    // find the 1st tagged view in the hierarcy
    for (UIView *tempView in self.view.subviews) {
        if (tempView.tag == 253) {
            agePickerView = tempView;
            break;
        }
    }
    // find the 3rd tagged view in the hierarcy
    UIView *taggedView;
    for (UIView *tempView in agePickerView.subviews) {
        for (UIView *tempSubView in tempView.subviews) {
            for (UIView *tempSubSubView in tempSubView.subviews) {
                for (UIView *tempSubSubSubView in tempSubSubView.subviews) {
                    if (tempSubSubSubView.tag == 255) {
                        taggedView = tempSubSubSubView;
                        goto doBreak;
                    }
                }
            }
        }
    }
doBreak:
    [taggedView removeFromSuperview];
    taggedView = nil;
    if (agePickerView) {
        agePickerView.tag = 0; // clear tag
        [UIView animateWithDuration:(animated ? 0.5 : 0.0) animations:^ {
             [agePickerView setFrame:CGRectMake(0, self.view.frame.size.height, agePickerView.frame.size.width, agePickerView.frame.size.height)];
        }];
        [self performSelector:@selector(removeAgePickerViewFromSuperviewMethod) withObject:nil afterDelay:1.0f];
    }
    ageGroupsButton.enabled = YES; ageGroupsButton.alpha = 1.0;
    textUserName.enabled = YES; textUserName.alpha = 1.0;
    textEmail.enabled = YES; textEmail.alpha = 1.0;
    textPassword.enabled = YES; textPassword.alpha = 1.0;
    textConfPass.enabled = YES; textConfPass.alpha = 1.0;
    // Decode the selectedAge value
    [self decodeSelectedAge];
}

- (void)removeAgePickerViewFromSuperviewMethod {
    [agePickerView removeFromSuperview];
}

- (void)decodeSelectedAge {
    NSLog(@"selectedAge = %@",agePickerViewController.selectedAge);
    if ([agePickerViewController.selectedAge isEqualToString:@""]) {
        selectedAgeInt = 0;
    } else if ([agePickerViewController.selectedAge isEqualToString:@"تحـت 18"]) {
        selectedAgeInt = 1;
    } else if ([agePickerViewController.selectedAge isEqualToString:@"18 - 25"]) {
        selectedAgeInt = 2;
    } else if ([agePickerViewController.selectedAge isEqualToString:@"26 - 35"]) {
        selectedAgeInt = 3;
    } else if ([agePickerViewController.selectedAge isEqualToString:@"36 - 45"]) {
        selectedAgeInt = 4;
    } else if ([agePickerViewController.selectedAge isEqualToString:@"فـوق 45"]) {
        selectedAgeInt = 5;
    } else if ([agePickerViewController.selectedAge isEqualToString:@"أخـرى"]) {
        selectedAgeInt = 0;
    } else if ([agePickerViewController.selectedAge isEqual:[NSNull null]]) {
        selectedAgeInt = 0;
    }
    NSLog(@"selectedAgeInt = %d",selectedAgeInt);
}

#pragma mark - Register Button Method

- (IBAction)registerButton:(id)sender {
    if ([textUserName.text length] < 3) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"برجاء إدخال الاسم" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
        [textUserName becomeFirstResponder];
    } else {
        usernameStr = textUserName.text;
        if ([textEmail.text isEqualToString:@""]) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"برجاء إدخال البريد الإلكتروني" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet showInView:self.view];
            [textEmail becomeFirstResponder];
        } else {
            NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
            //Validate email address
            if ([emailTest evaluateWithObject:textEmail.text] != YES) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"برجاء إدخال بريد الكتروني صحيح" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
                actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                [actionSheet showInView:self.view];
                [textEmail becomeFirstResponder];
            } else {
                emailStr = textEmail.text;
                if ([textPassword.text length] < 8) {
                    actionSheet = [[UIActionSheet alloc] initWithTitle:@"كلمة المرور يجب أن تكون 8 أحرف على الأقل" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
                    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                    [actionSheet showInView:self.view];
                    [textPassword becomeFirstResponder];
                } else {
                    passwordStr = textPassword.text;
                    if ([textConfPass.text isEqualToString:@""]) {
                        actionSheet = [[UIActionSheet alloc] initWithTitle:@"برجاء إدخال كلمة المرور مرة أخرى" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
                        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                        [actionSheet showInView:self.view];
                        [textConfPass becomeFirstResponder];
                    } else {
                        confPassStr = textConfPass.text;
                        if (![passwordStr isEqualToString:confPassStr]) {
                            actionSheet = [[UIActionSheet alloc] initWithTitle:@"كلمة المرور غير متطابقة. برجاء المراجعة" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
                            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                            [actionSheet showInView:self.view];
                        } else {
                            [self registrationWebServiceHandling];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - registrationWebService Methods

- (void)registrationWebServiceHandling {
    [aiMsg setText:@"جاري التسجيل"];
    aiView.hidden = NO;
    // Initialize registrationWebService
    registrationWebService = [[RegistrationWebService alloc] init];
    [registrationWebService setRegistrationWsDelegate:self];
    int fbFlag = (throughFbFlag ? 1 : 0);
    [registrationWebService registerWithUsername:usernameStr andPassword:passwordStr andEmail:emailStr andAge:selectedAgeInt andFbFlag:fbFlag];
}

- (void)registrationWebService:(RegistrationWebService *)registrationWebService errorMessage:(NSString *)errorMsg {
    // Display Error Message
    [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
    [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الاتصال بالانترنت",errorMsg]];
    aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    aiMsg.numberOfLines = 4;
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
}

- (void)registrationWebService:(RegistrationWebService *)registrationWebService returnMessage:(NSDictionary *)returnMsg {
    NSLog(@"returnMsg: %@",returnMsg);
    if ([returnMsg objectForKey:@"authentication_token"]) {
        // Successful Registration
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[[returnMsg objectForKey:@"authentication_token"] mutableCopy] forKey:@"authToken"];
        [defaults synchronize];
        [self registrationMethod];
    } else {
        // Registration failed
        [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
        [aiMsg setText:[NSString stringWithFormat:@"Email %@",[returnMsg objectForKey:@"email"]]];
        aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:25];
        aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
        aiMsg.numberOfLines = 4;
        [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
    }
}

- (void)registrationMethod {
    [aiView removeFromSuperview];
    aiView = nil;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"تم التسجيل بنجاح" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    loginFlag = @"hideLogin";
    [self dismissRegistrationView:nil];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    aiView.hidden = YES;
}

- (IBAction)dismissRegistrationView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


