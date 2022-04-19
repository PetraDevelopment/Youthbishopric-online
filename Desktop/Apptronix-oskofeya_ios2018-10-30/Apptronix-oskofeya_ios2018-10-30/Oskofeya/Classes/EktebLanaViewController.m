#import "EktebLanaViewController.h"
#import "AppDelegate.h"

@implementation EktebLanaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"إبعتلنا", @"إبعتلنا");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    ektebLanaWebService = [[EktebLanaWebService alloc] init];
    [ektebLanaWebService setEktebLanaWsDelegate:self];
    [[ektebLanaSubjectButton layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[ektebLanaSubjectButton layer] setBorderWidth:.4];
    [[ektebLanaSubjectButton layer] setCornerRadius:8.0f];
 
    [[ektebLanaSendButton layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[ektebLanaSendButton layer] setBorderWidth:.4];
    [[ektebLanaSendButton layer] setCornerRadius:8.0f];
    
    [[ektebLanaTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[ektebLanaTextView layer] setBorderWidth:.4];
    [[ektebLanaTextView layer] setCornerRadius:8.0f];
    
    [self setupView];
}

- (void)setupView {
    // Set the ektebLanaTextView
    [ektebLanaTextView setDelegate:self];
    ektebLanaTextView.text = @"نـص الـرسـاله";
    ektebLanaTextView.textAlignment = NSTextAlignmentRight;
    // subjectPickerViewController initialization
    if (subjectPickerViewController == nil) {
        subjectPickerViewController = [[SubjectPickerViewController alloc] init];
	}
    subjectPickerViewController.subjectsList = [[NSArray alloc] initWithObjects:@"اقـترح إقـتراح", @"اسأل في مـشكله فـنيـه", @"أخرى", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowMethod:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboardViewController) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - Keyboard Methods

- (void)keyboardWillShowMethod:(NSNotification *)notif {
    infoDictionary = [notif userInfo];
    NSValue *keyboardValue = [infoDictionary objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSizeVariable = [keyboardValue CGRectValue].size;
    float bottomPoint;
    bottomPoint = (ektebLanaTextView.frame.origin.y + ektebLanaTextView.frame.size.height + 55);
    viewScrollAmount = keyboardSizeVariable.height - (self.view.frame.size.height - bottomPoint);
    if (viewScrollAmount > 0) {
        moveViewUp = YES;
        [self scrollViewMethod:YES];
    } else {
        moveViewUp = NO;
    }
    // Disable Subject button
    ektebLanaSubjectButton.enabled = NO;
    ektebLanaSubjectButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    // Disable Send button
    ektebLanaSendButton.enabled = NO;
   // ektebLanaSendButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    // Clear placerholder text
    if ([ektebLanaTextView.text isEqualToString:@"نـص الـرسـاله"]) {
        ektebLanaTextView.text = @"";
    }
    // Change writing direction before showing the keyboard
    ektebLanaTextView.textAlignment = NSTextAlignmentRight; // NSTextAlignmentLeft
    [self showKeyboardMethod];
}

- (void)scrollViewMethod:(BOOL)movedUpValue {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.52]; // 0.3
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

- (void)showKeyboardMethod {
    float frameHeight;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        frameHeight = 728; // added +188
    } else {
        frameHeight = 651; // was 473 (if bottomPoint increases frameHeight should increase)
    }
    // Customize keyboardViewController
    keyboardViewController = [[UIViewController alloc] init];
    float keyboardViewHeight = 216;
    [keyboardViewController.view setFrame:CGRectMake(0, frameHeight, keyboardViewController.view.frame.size.width,keyboardViewHeight)];
    keyboardViewController.view.backgroundColor = [UIColor whiteColor];
    keyboardViewController.view.tag = 999; // Tag this view so we can find it again later to dismiss
    [self.view addSubview:keyboardViewController.view];
    // Customize navigationController
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    [navigationController pushViewController:keyboardViewController animated:YES];
    navigationController.view.frame = CGRectMake(0, frameHeight, 320, 260); // (216 + 44)
    navigationController.view.tag = 999; // Tag this view so we can find it again later to dismiss
    keyboardViewController.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent; // UIBarStyleBlack
    keyboardViewController.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    keyboardViewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    keyboardViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboardViewController)];
    [self.view addSubview:navigationController.view];
    // Animate Transition
    [UIView animateWithDuration:0.1 animations:^ {
        [navigationController.view setFrame:CGRectMake(0,(frameHeight - navigationController.view.frame.size.height), navigationController.view.frame.size.width, navigationController.view.frame.size.height)];
    }];
}

- (void)dismissKeyboardViewController {
    // find our tagged view
    for (UIView *tempView in self.view.subviews) {
        if (tempView.tag == 999) {
            keyboardViewController.view = tempView;
            break;
        }
    }
    if (keyboardViewController.view) {
        keyboardViewController.view.tag = 0; // clear tag
        [UIView animateWithDuration:0.1 animations:^ {
            [keyboardViewController.view setFrame:CGRectMake(0, self.view.frame.size.height, keyboardViewController.view.frame.size.width, keyboardViewController.view.frame.size.height)];
        }];
        [self performSelector:@selector(removeKeyboardViewFromSuperviewMethod) withObject:nil afterDelay:0.1f];
    }
    [ektebLanaTextView resignFirstResponder];
    if (moveViewUp) {
        [self scrollViewMethod:NO];
        infoDictionary = nil;
    }
    // Return ektebLanaMessageStr
    ektebLanaMessageStr = ektebLanaTextView.text;
    // Enable Subject button
    ektebLanaSubjectButton.enabled = YES;
    ektebLanaSubjectButton.backgroundColor = [UIColor clearColor];
    // Enable Send button
    ektebLanaSendButton.enabled = YES;
   // ektebLanaSendButton.backgroundColor = [UIColor clearColor];
}

- (void)removeKeyboardViewFromSuperviewMethod {
    [keyboardViewController.view removeFromSuperview];
}

#pragma mark - Subject Picker Methods

- (int)extractRowIndexFromPicker:(NSString *)subjectStr {
    int rowIndex = 0, retRowIndex = 0;
    for (NSString *tempStr in subjectPickerViewController.subjectsList) {
        if ([tempStr isEqualToString:subjectStr]) {
            retRowIndex  = rowIndex;
        }
        rowIndex ++;
    }
    return retRowIndex;
}

- (IBAction)chooseSubjectButton:(id)sender {
    ektebLanaSubjectButton.enabled = NO; ektebLanaSubjectButton.alpha = 0.4;
    ektebLanaTextView.editable = NO; ektebLanaTextView.alpha = 0.4;
    float pickerViewHeight = 216;
    [subjectPickerViewController.view setFrame:CGRectMake(0, self.view.frame.size.height, subjectPickerViewController.view.frame.size.width,pickerViewHeight)];
    subjectPickerViewController.view.backgroundColor = [UIColor whiteColor]; // blackColor
    subjectPickerViewController.view.tag = 254; // 2nd tagged view in the hierarcy
    subjectPickerViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(subjectPickerDoneButton)];
    subjectPickerViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(subjectPickerDismissButton)];
    [self.view addSubview:subjectPickerViewController.view];
    // Customize Picker View
    subjectPickerViewController.subjectsPicker = [[UIPickerView alloc] init];
    [subjectPickerViewController.subjectsPicker setDelegate:subjectPickerViewController];
    subjectPickerViewController.subjectsPicker.showsSelectionIndicator = YES;
    subjectPickerViewController.subjectsPicker.tag = 255; // 3rd tagged view in the hierarcy
    // Select the chosenSubject
    int selectedRow = [self extractRowIndexFromPicker:subjectPickerViewController.chosenSubject];
    [subjectPickerViewController.subjectsPicker selectRow:selectedRow inComponent:0 animated:YES];
    [subjectPickerViewController.view addSubview:subjectPickerViewController.subjectsPicker];
    // Customize navigationController
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    [navigationController pushViewController:subjectPickerViewController animated:YES];
    navigationController.view.frame = CGRectMake(0, self.view.frame.size.height, 320, 260);
    navigationController.view.tag = 253; // 1st tagged view in the hierarcy
    subjectPickerViewController.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent; // UIBarStyleBlack
    subjectPickerViewController.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    subjectPickerViewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.view addSubview:navigationController.view];
    // Animate Transition
    [UIView animateWithDuration:0.5 animations:^ {
        [navigationController.view setFrame:CGRectMake(0,(self.view.frame.size.height - navigationController.view.frame.size.height), navigationController.view.frame.size.width, navigationController.view.frame.size.height)];
    }];
}

- (void)subjectPickerDoneButton {
    if (subjectPickerViewController.chosenSubject != nil) {
        [ektebLanaSubjectButton setTitle:subjectPickerViewController.chosenSubject forState:UIControlStateNormal];
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
            subjectPickerView = tempView;
            break;
        }
    }
    // find the 3rd tagged view in the hierarcy
    UIView *taggedView;
    for (UIView *tempView in subjectPickerView.subviews) {
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
    if (subjectPickerView) {
        subjectPickerView.tag = 0; // clear tag
        [UIView animateWithDuration:(animated ? 0.5 : 0.0) animations:^ {
             [subjectPickerView setFrame:CGRectMake(0, self.view.frame.size.height, subjectPickerView.frame.size.width, subjectPickerView.frame.size.height)];
        }];
        [self performSelector:@selector(removeSubjectPickerViewFromSuperviewMethod) withObject:nil afterDelay:1.0f];
    }
    ektebLanaSubjectButton.enabled = YES; ektebLanaSubjectButton.alpha = 1.0;
    ektebLanaTextView.editable = YES; ektebLanaTextView.alpha = 1.0;
}

- (void)removeSubjectPickerViewFromSuperviewMethod {
    [subjectPickerView removeFromSuperview];
}

#pragma mark - Send Button Method

- (IBAction)ektebLanaSendButton:(id)sender {
    if (!ektebLanaMessageStr || [ektebLanaMessageStr isEqualToString:@""]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"لا يمكن إرسال رسالة فارغة" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
        [ektebLanaTextView becomeFirstResponder];
    } else {
        if (!subjectPickerViewController.chosenSubject || [subjectPickerViewController.chosenSubject isEqualToString:@""]) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"برجاء اختيار الموضوع" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet showInView:self.view];
        } else {
            [self ektebLanaWebServiceHandling];
        }
    }
}

#pragma mark - ektebLanaWebService Handling Methods

- (void)ektebLanaWebServiceHandling {
    [aiMsg setText:@"جاري الإرسال"];
    aiView.hidden = NO;
    // Initialize ektebLanaWebService
    ektebLanaWebService = [[EktebLanaWebService alloc] init];
    [ektebLanaWebService setEktebLanaWsDelegate:self];
    [ektebLanaWebService postQuestionWithTitle:subjectPickerViewController.chosenSubject andBody:ektebLanaMessageStr];
}

- (void)ektebLanaWebService:(EktebLanaWebService *)ektebLanaWebService errorMessage:(NSString *)errorMsg {
    // Display Error Message
    [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
    [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الاتصال بالانترنت",errorMsg]];
    aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    aiMsg.numberOfLines = 4;
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
}

- (void)ektebLanaWebService:(EktebLanaWebService *)ektebLanaWebService returnMessage:(NSDictionary *)returnMsg {
    // NSLog(@"returnMsg: %@",returnMsg);
    if ([returnMsg objectForKey:@"success"] == [NSNumber numberWithBool:YES]) {
        // Message Sent
        [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
        [aiMsg setText:@"تم استلام رسالتك. سيتم مراجعة الرسائل و الرد عليها في أقرب وقت"];
        aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
        aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
        aiMsg.numberOfLines = 4;
        [self performSelector:@selector(hideClearAndDismiss) withObject:nil afterDelay:5.0f];
    } else {
        // Message Failed
        [aiMsg setText:@"برجاء المحاولة مرة اخرى"];
        [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
    }
}

#pragma mark - Dismiss Methods

- (void)hideClearAndDismiss {
    [self hideActivityIndicator];
    ektebLanaTextView.text = @"نـص الـرسـاله";
    ektebLanaMessageStr = nil;
    [self dismissEktebLanaView:nil];
}

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissEktebLanaView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


