#import "WriteNoteViewController.h"
#import "AppDelegate.h"

@implementation WriteNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"كتابة تأمل", @"كتابة تأمل");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    [[writeNoteTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[writeNoteTextView layer] setBorderWidth:.9];
    [[writeNoteTextView layer] setCornerRadius:8.0f];
    
    [[writeNoteSaveButton layer] setCornerRadius:8.0f];
}

- (void)setupView {
    // Set the writeNoteTextView
    [writeNoteTextView setDelegate:self];
    writeNoteTextView.text = @"اكتب هنا"; // @"Note contents"
    writeNoteTextView.textAlignment = NSTextAlignmentRight;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowMethod:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboardViewController) name:UIApplicationDidEnterBackgroundNotification object:nil];
    // Check if coming from AgpeyaView
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadWriteNoteView) {
        // Reset shouldLoadWriteNoteView Flag
        ((AppDelegate *)[UIApplication sharedApplication].delegate).shouldLoadWriteNoteView = NO;
        // Set shouldReturnToAgpeyaViewFromWNView Flag
        ((AppDelegate *)[UIApplication sharedApplication].delegate).shouldReturnToAgpeyaViewFromWNView = YES;
    }
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
    bottomPoint = (writeNoteTextView.frame.origin.y + writeNoteTextView.frame.size.height + 52);
    viewScrollAmount = keyboardSizeVariable.height - (self.view.frame.size.height - bottomPoint);
    if (viewScrollAmount > 0) {
        moveViewUp = YES;
        [self scrollViewMethod:YES];
    } else {
        moveViewUp = NO;
    }
    // Clear placerholder text
    if ([writeNoteTextView.text isEqualToString:@"اكتب هنا"]) {
        writeNoteTextView.text = @"";
    }
    // Change writing direction before showing the keyboard
    writeNoteTextView.textAlignment = NSTextAlignmentRight;
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
        frameHeight = 695;
    } else {
        frameHeight = 600;
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
    [writeNoteTextView resignFirstResponder];
    if (moveViewUp) {
        [self scrollViewMethod:NO];
        infoDictionary = nil;
    }
    // Return writeNoteMessageStr
    writeNoteMessageStr = writeNoteTextView.text;
    // Enable Save button
    writeNoteSaveButton.enabled = YES;
  //  writeNoteSaveButton.backgroundColor = [UIColor clearColor];
}

- (void)removeKeyboardViewFromSuperviewMethod {
    [keyboardViewController.view removeFromSuperview];
}

#pragma mark - Save Button Method

- (IBAction)writeNoteSaveButton:(id)sender {
    // NSLog(@"writeNoteMessageStr = %@",writeNoteMessageStr);
    if (!writeNoteMessageStr || [writeNoteMessageStr isEqualToString:@""]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"لا يمكن حفظ تأمل بدون محتوى" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil]; // @"You cannot save an empty note"
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
        [writeNoteTextView becomeFirstResponder];
    } else {
        [self postNoteWebServiceHandling];
    }
}

#pragma mark - postNoteWebService Handling Methods

- (void)postNoteWebServiceHandling {
    [aiMsg setText:@""]; // @"Saving note"
    aiView.hidden = NO;
    // Initialize postNoteWebService
    postNoteWebService = [[PostNoteWebService alloc] init];
    [postNoteWebService setPostNoteWsDelegate:self];
    [postNoteWebService postNote:writeNoteMessageStr];
}

- (void)postNoteWebService:(PostNoteWebService *)postNoteWebService errorMessage:(NSString *)errorMsg {
    // Display Error Message
    [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
    [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الاتصال بالانترنت",errorMsg]];
    aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    aiMsg.numberOfLines = 4;
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
}

- (void)postNoteWebService:(PostNoteWebService *)postNoteWebService returnMessage:(NSDictionary *)returnMsg {
    NSLog(@"returnMsg: %@",returnMsg);
    if ([returnMsg objectForKey:@"success"] == [NSNumber numberWithBool:YES]) {
        // Note Saved
        [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
        [aiMsg setText:@"تم حفظ التأمل"]; // @"The note was saved"
        aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
        aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
        aiMsg.numberOfLines = 4;
        [self performSelector:@selector(hideClearAndDismiss) withObject:nil afterDelay:5.0f];
    } else {
        // Note not Saved
        [aiMsg setText:@"برجاء المحاولة مرة اخرى"];
        [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
    }
}

#pragma mark - Dismiss Methods

- (void)hideClearAndDismiss {
    [self hideActivityIndicator];
    writeNoteTextView.text = @"اكتب هنا";
    writeNoteMessageStr = nil;
    [self dismissWriteNoteView:nil];
}

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissWriteNoteView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


