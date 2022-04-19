#import "Es2alViewController.h"
#import "AppDelegate.h"

#define MEDIA_TAG 777

@implementation Es2alViewController

@synthesize todayMsgIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"إسال", @"إسال");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize es2alHistoryViewController
    es2alHistoryViewController = [[Es2alHistoryViewController alloc] initWithNibName:@"Es2alHistoryView_i5" bundle:nil];
    [es2alHistoryViewController setEs2alHistoryDelegate:self];
    
    // Initialize es2alWebService
    es2alWebService = [[Es2alWebService alloc] init];
    [es2alWebService setEs2alWsDelegate:self];
    // Get Present & Future es2alMessages
    [es2alWebService getEs2alMessagesForPresentAndFuture:YES];
    [[es2alTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[es2alTextView layer] setBorderWidth:.4];
    [[es2alTextView layer] setCornerRadius:8.0f];
    [[es2alSendButton layer] setCornerRadius:8.0f];
    [self setupView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)setupView {
    // Set the es2alTableView
    es2alTableView.backgroundColor = [UIColor clearColor];
    es2alTableView.separatorColor = [UIColor whiteColor];
    es2alTableView.allowsSelection = NO;
    // Set the es2alTextView
    [es2alTextView setDelegate:self];
    es2alTextView.text = @"اكتب سؤالك هنا";
    es2alTextView.textAlignment = NSTextAlignmentRight;
    es2alTextView.textColor = [UIColor lightGrayColor];

}
// to hidden keyboard when click at any position in view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

    if ([es2alTextView.text isEqualToString:@"اكتب سؤالك هنا"]) {
        es2alTextView.text = @"";
        es2alTextView.textColor = [UIColor blackColor]; //optional
    }
    [es2alTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([es2alTextView.text isEqualToString:@""]) {
        es2alTextView.text = @"اكتب سؤالك هنا";
        es2alTextView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y + 150, textView.frame.size.width, textView.frame.size.height)];
    [andyso2al setFrame:CGRectMake(andyso2al.frame.origin.x, andyso2al.frame.origin.y + 150, andyso2al.frame.size.width, andyso2al.frame.size.height)];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y - 150, textView.frame.size.width, textView.frame.size.height)];
    textView.backgroundColor = [UIColor whiteColor];
     [andyso2al setFrame:CGRectMake(andyso2al.frame.origin.x, andyso2al.frame.origin.y - 150, andyso2al.frame.size.width, andyso2al.frame.size.height)];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowMethod:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboardViewController) name:UIApplicationDidEnterBackgroundNotification object:nil];
    if (todayMsgIndex == 1000) {
        // Navigating from MainView
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:es2alMessages andDate:[NSDate date]];
        displayedMessage = [[es2alMessages objectAtIndex:todayMsgIndex] mutableCopy];
    }
    es2alTextView.text = @"اكتب سؤالك هنا";
    es2alTextView.textAlignment = NSTextAlignmentRight;
    es2alTextView.textColor = [UIColor lightGrayColor];
    [self updateView];
    [self hideCFWbButtons];
}

- (void)viewWillDisappear:(BOOL)animated {
   [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];


}
- (void) viewDidDisappear:(BOOL)animated{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"testtt2");
    for (UIView *tempView in self.view.subviews) {
        if (tempView.tag == 999) {
          //  keyboardViewController.view = tempView;
            [tempView removeFromSuperview];
            break;
        }
    }
}

- (void)updateView {
    // Set fontSize
    fontSize = 17.0;
    // Scroll to top of view
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 0];
    [es2alTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    // Load mediaData
    if ([displayedMessage objectForKey:@"photo"] && (![[displayedMessage objectForKey:@"photo"] isEqualToString:@""])) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            mediaData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/%@", [displayedMessage objectForKey:@"photo"]]]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [es2alTableView reloadData];
            });
        });
    }
    [self updateTable];
}

- (void)updateTable {
    [es2alTableView reloadData];
}

#pragma mark - es2alMessages Handling Methods

- (void)es2alWebService:(Es2alWebService *)es2alWebService errorMessage:(NSString *)errorMsg {
    // Load es2alMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"es2alMessages"] != NULL) {
        [self hideActivityIndicator];
        es2alMessages = [defaults objectForKey:@"es2alMessages"];
        // Extract today MsgIndex
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:es2alMessages andDate:[NSDate date]];
        displayedMessage = [[es2alMessages objectAtIndex:todayMsgIndex] mutableCopy];
        [es2alTableView reloadData];
    } else {
        // Display Error Message
        [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
        [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الاتصال بالانترنت",errorMsg]];
        aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
        aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
        aiMsg.numberOfLines = 4;
        [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
    }
    // NSLog(@"es2alMessages = %d",[es2alMessages count]);
}

- (void)es2alWebService:(Es2alWebService *)es2alWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    // Retrieve es2alMessages
    es2alMessages = returnMsgs;
    // Save es2alMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[es2alMessages mutableCopy] forKey:@"es2alMessages"];
    [defaults synchronize];
    // Extract today MsgIndex
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:es2alMessages andDate:[NSDate date]];
    displayedMessage = [[es2alMessages objectAtIndex:todayMsgIndex] mutableCopy];
    [self updateView];
    // NSLog(@"defaults_es2alMessages = %d",[[defaults objectForKey:@"es2alMessages"] count]);
}



#pragma mark - tableView Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 25.0f)];
    //[view setBackgroundColor:[UIColor lightGrayColor]];
    [view setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:240.0/255.0f blue:241.0/255.0f alpha:1.0]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, 0, 70, 70)];
    imageView.image = [UIImage imageNamed:@"es2al.png"];
    [view addSubview:imageView];
    
    UILabel *es2al = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 150, 20)];
    es2al.text = @"إسأل";
    es2al.font = [UIFont fontWithName:@"Helvetica-Bold" size:(17)];
    es2al.adjustsFontSizeToFitWidth = YES;
    es2al.textColor = [UIColor redColor];
    es2al.textAlignment = NSTextAlignmentRight;
    [view addSubview:es2al];
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width - 110, 40)];
    sectionHeader.text = [displayedMessage objectForKey:@"title"];
    sectionHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:(15)];
    sectionHeader.adjustsFontSizeToFitWidth = YES;
    sectionHeader.textColor = [UIColor colorWithRed:47.0/255.0f green:83.0/255.0f blue:90.0/255.0f alpha:1.0];
    sectionHeader.textAlignment = NSTextAlignmentRight;
    sectionHeader.numberOfLines = 0;
    [view addSubview:sectionHeader];
    
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowsCount = 1;
    if (todayMsgIndex != 1000) {
        if ([displayedMessage objectForKey:@"photo"] && (![[displayedMessage objectForKey:@"photo"] isEqualToString:@""])) {
            rowsCount += 1;
        }
    }
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (([displayedMessage objectForKey:@"photo"] && (![[displayedMessage objectForKey:@"photo"] isEqualToString:@""])) && (indexPath.row == 0)) {
        // Image
        float mediaHeight = 270.0f * (([[UIImage imageWithData:mediaData] size].height * 2) / ([[UIImage imageWithData:mediaData] size].width * 2));
        if (mediaData) {
            return (mediaHeight + 20.0);
        } else {
            return 0;
        }
    } else {
        if ([displayedMessage objectForKey:@"body"] && (![[displayedMessage objectForKey:@"body"] isEqualToString:@""])) {
            // Body
            NSAttributedString *bodyText = [[NSAttributedString alloc] initWithString:[displayedMessage objectForKey:@"body"] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)]}];
            CGRect bodyTextRect = [bodyText boundingRectWithSize:(CGSize){es2alTableView.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            CGSize bodyTextSize = bodyTextRect.size;
            CGFloat rowHeight = bodyTextSize.height;
            if (rowHeight <= 45.0) { // One line
                rowHeight = 45.0;
            }
            return rowHeight;
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell.contentView viewWithTag:MEDIA_TAG] removeFromSuperview];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor blackColor];
    if (([displayedMessage objectForKey:@"photo"] && (![[displayedMessage objectForKey:@"photo"] isEqualToString:@""])) && (indexPath.row == 0)) {
        // Image
        float mediaHeight = 270.0f * (([[UIImage imageWithData:mediaData] size].height * 2) / ([[UIImage imageWithData:mediaData] size].width * 2));
        UIImageView *es2alImageView;
        if (mediaData) {
            es2alImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 270.0f, mediaHeight)];
            es2alImageView.image = [UIImage imageWithData:mediaData];
        }
        es2alImageView.center = CGPointMake((cell.contentView.bounds.size.width / 2), es2alImageView.center.y + 20);
        cell.textLabel.text = nil;
        es2alImageView.tag = MEDIA_TAG;
        [cell.contentView addSubview:es2alImageView];
    } else {
        // Body
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        cell.textLabel.text = [displayedMessage objectForKey:@"body"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    // Add LongPress Handling
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [cell addGestureRecognizer:longPress];
    return cell;
}

#pragma mark - Font Size Related Methods

- (IBAction)increaseFontSize {
    if(fontSize < 30)
    {
        fontSize = fontSize + 1;
        [self updateTable];
    }
}

- (IBAction)decreaseFontSize {
    if(fontSize > 6)
    {
        fontSize = fontSize - 1;
        [self updateTable];
    }
}

#pragma mark - CFW Related Methods

- (void)handleLongPress:(UIGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        es2alTableView.allowsSelection = YES;
        // Extract Selected Index
        CGPoint pressLocation = [longPress locationInView:es2alTableView];
        NSIndexPath *selectedIndex = [es2alTableView indexPathForRowAtPoint:pressLocation];
        [es2alTableView selectRowAtIndexPath:selectedIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self performSelector:@selector(deselectRow:) withObject:selectedIndex afterDelay:0.5f];
        // Show CFW Buttons
        btnCopy.hidden = NO;
        btnFb.hidden = NO;
        btnWhtsp.hidden = NO;
        btnShare.hidden = NO;
    }
}

- (void)deselectRow:(NSIndexPath *)selectedIndex {
    [es2alTableView deselectRowAtIndexPath:selectedIndex animated:YES];
    es2alTableView.allowsSelection = NO;
}

- (IBAction)copyFeature {
    [self hideCFWbButtons];
    NSString *copiedString = [NSString stringWithFormat:@"%@\n%@",[displayedMessage objectForKey:@"title"], [displayedMessage objectForKey:@"body"]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject copyContent:copiedString];
}

- (IBAction)facebookShare {
    [self hideCFWbButtons];
    NSString *facebookMsg = [NSString stringWithFormat:@"%@\n%@\n\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp",[displayedMessage objectForKey:@"title"], [displayedMessage objectForKey:@"body"]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    if ([displayedMessage objectForKey:@"photo"] && (![[displayedMessage objectForKey:@"photo"] isEqualToString:@""])) {
        // Image
        [cfwObject facebookShareContent:facebookMsg fromViewController:self withImage:mediaData];
    } else {
        // Body
        [cfwObject facebookShareContent:facebookMsg fromViewController:self];
    }
}

- (IBAction)whatsAppShare {
    [self hideCFWbButtons];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    if ([displayedMessage objectForKey:@"photo"] && (![[displayedMessage objectForKey:@"photo"] isEqualToString:@""])) {
        // Image
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://app"]]) {
            UIImage *iconImage = [UIImage imageWithData:mediaData];
            NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.wai"];
            [UIImageJPEGRepresentation(iconImage, 1.0) writeToFile:savePath atomically:YES];
            documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
            documentInteractionController.UTI = @"net.whatsapp.image";
            [documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [NSString stringWithFormat:@"%@\n%@\n\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp",[displayedMessage objectForKey:@"title"], [displayedMessage objectForKey:@"body"]];
            // Add text as caption
            [AppDelegate showAlertView:@"برجاء لصق المحتوى في المساحة المخصصة\nPlease click paste in the caption area"];
        } else {
        [AppDelegate showAlertView:[NSString stringWithFormat:@"برجاء تحميل برنامج الواتس اب"]];;
        }
    } else {
        // Body
        NSString *contentString = [[NSString stringWithFormat:@"whatsapp://send?text=%@\n%@\n",[displayedMessage objectForKey:@"title"], [displayedMessage objectForKey:@"body"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *oskofeyaUrlString = [[NSString stringWithFormat:@"\n\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",contentString,oskofeyaUrlString]];
        [cfwObject whatsAppShareURL:url];
    }
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

#pragma mark - History Button Method

- (IBAction)loadEs2alHistoryView:(id)sender {
    [self showViewController:es2alHistoryViewController];
    [self performSelector:@selector(pushViewController:) withObject:es2alHistoryViewController afterDelay:0.5f];
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

#pragma mark - Es2alHistoryDelegate Method

- (void)es2alHistoryViewController:(Es2alHistoryViewController *)es2alHistoryViewController setMessage:(NSMutableDictionary *)historyMessage {
    displayedMessage = historyMessage;
    [self updateView];
}

#pragma mark - Keyboard Methods

- (void)keyboardWillShowMethod:(NSNotification *)notif {
  /*  infoDictionary = [notif userInfo];
    NSValue *keyboardValue = [infoDictionary objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSizeVariable = [keyboardValue CGRectValue].size;
    float bottomPoint;
    bottomPoint = (es2alTextView.frame.origin.y + es2alTextView.frame.size.height + 75);
    viewScrollAmount = keyboardSizeVariable.height - (self.view.frame.size.height - bottomPoint);
    if (viewScrollAmount > 0) {
        moveViewUp = YES;
        [self scrollViewMethod:YES];
    } else {
        moveViewUp = NO;
    }
    // Disable Send button
    es2alSendButton.enabled = NO;
    es2alSendButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    // Disable Table View
    es2alTableView.userInteractionEnabled = NO;
    // Clear placerholder text
    if ([es2alTextView.text isEqualToString:@"اكتب سؤالك هنا"]) {
        es2alTextView.text = @"";
    }
    // Change writing direction before showing the keyboard
    es2alTextView.textAlignment = NSTextAlignmentRight; // NSTextAlignmentLeft
    [self showKeyboardMethod];*/
}

- (void)scrollViewMethod:(BOOL)movedUpValue {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[infoDictionary objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]]; // 0.3 - 0.52
    [UIView setAnimationCurve:[[infoDictionary objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
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

   /* float frameHeight;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        frameHeight = 806; // added +266
    } else {
        frameHeight = 720; // was 473 (if bottomPoint increases frameHeight should increase)
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
    }];*/
}

- (void)dismissKeyboardViewController {
    // find our tagged view
   /* for (UIView *tempView in self.view.subviews) {
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
    [es2alTextView resignFirstResponder];
    if (moveViewUp) {
        [self scrollViewMethod:NO];
        infoDictionary = nil;
    }
    // Return es2alQuestionStr
    es2alQuestionStr = es2alTextView.text;
    // Enable Send button
   // es2alSendButton.enabled = YES;
 //   es2alSendButton.backgroundColor = [UIColor clearColor];
    // Enable Table View
    es2alTableView.userInteractionEnabled = YES;*/
}

- (void)removeKeyboardViewFromSuperviewMethod {
   // [keyboardViewController.view removeFromSuperview];
}

#pragma mark - Send Button Method

- (IBAction)es2alSendButton:(id)sender {
    if ([es2alTextView.text isEqualToString:@""] ||  [es2alTextView.text isEqualToString:@"اكتب سؤالك هنا"]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"لا يمكن إرسال رسالة فارغة" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
        [es2alTextView becomeFirstResponder];
    } else {
        [self es2alQuestionWebServiceHandling];
    }
}

#pragma mark - es2alQuestionWebService Handling Methods

- (void)es2alQuestionWebServiceHandling {
    [aiMsg setText:@"جاري الإرسال"];
    aiView.hidden = NO;
    // Initialize es2alQuestionWebService
    es2alQuestionWebService = [[Es2alQuestionWebService alloc] init];
    [es2alQuestionWebService setEs2alQuestionWsDelegate:self];
    [es2alQuestionWebService postQuestion:es2alQuestionStr];
    es2alTextView.text = @"اكتب سؤالك هنا";
    es2alTextView.textAlignment = NSTextAlignmentRight;
    es2alTextView.textColor = [UIColor lightGrayColor];
}

- (void)es2alQuestionWebService:(Es2alQuestionWebService *)es2alQuestionWebService errorMessage:(NSString *)errorMsg {
    // Display Error Message
    [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
    [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الاتصال بالانترنت",errorMsg]];
    aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    aiMsg.numberOfLines = 4;
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
}

- (void)es2alQuestionWebService:(Es2alQuestionWebService *)es2alQuestionWebService returnMessage:(NSDictionary *)returnMsg {
    // NSLog(@"returnMsg: %@",returnMsg);
    if ([returnMsg objectForKey:@"success"] == [NSNumber numberWithBool:YES]) {
        // Message Sent
        [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
        [aiMsg setText:@"تم استلام رسالتك. سيتم مراجعة الرسائل و الرد عليها في أقرب وقت"];
        aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
        aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
        aiMsg.numberOfLines = 4;
        [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
    } else {
        // Message Failed
        [aiMsg setText:@"برجاء المحاولة مرة اخرى"];
        [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
    }
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissEs2alView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


