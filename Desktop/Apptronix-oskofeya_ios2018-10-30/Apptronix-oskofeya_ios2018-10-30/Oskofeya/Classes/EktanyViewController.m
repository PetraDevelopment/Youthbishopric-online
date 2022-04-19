#import "EktanyViewController.h"
#import "AppDelegate.h"
#import "FMDB.h" 

#define MEDIA_TAG 777

@implementation EktanyViewController

@synthesize todayMsgIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"إقتنى", @"إقتنى");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize ektanyHistoryViewController
    ektanyHistoryViewController = [[EktanyHistoryViewController alloc] initWithNibName:@"EktanyHistoryView_i5" bundle:nil];
    [ektanyHistoryViewController setEktanyHistoryDelegate:self];
    // Initialize ektanyWebService
    ektanyWebService = [[EktanyWebService alloc] init];
    [ektanyWebService setEktanyWsDelegate:self];
    // Get Present & Future ektanyMessages
    [ektanyWebService getEktanyMessagesForPresentAndFuture:YES];
    [self setupView];
}

- (void)setupView {
    // Set the ektanyTableView
    ektanyTableView.backgroundColor = [UIColor clearColor];
    ektanyTableView.separatorColor = [UIColor whiteColor];
    ektanyTableView.allowsSelection = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    if (todayMsgIndex == 1000) {
        // Navigating from MainView
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:ektanyMessages andDate:[NSDate date]];
        displayedMessage = [[ektanyMessages objectAtIndex:todayMsgIndex] mutableCopy];
        [self updateView];
    }
    [self hideCFWbButtons];
}

- (void)updateView {
    // Set fontSize
    fontSize = 17.0;
    // Scroll to top of view
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 0];
    [ektanyTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    // Load mediaData
    if ([displayedMessage objectForKey:@"photo"] && (![[displayedMessage objectForKey:@"photo"] isEqualToString:@""])) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            mediaData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/%@",[displayedMessage objectForKey:@"photo"]]]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [ektanyTableView reloadData];
            });
        });
    }
    [self updateTable];
}

- (void)updateTable {
    [ektanyTableView reloadData];
}

#pragma mark - ektanyMessages Handling Methods

- (void)ektanyWebService:(EktanyWebService *)ektanyWebService errorMessage:(NSString *)errorMsg {
    // Load ektanyMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ektanyMessages"] != NULL) {
        [self hideActivityIndicator];
        ektanyMessages = [defaults objectForKey:@"ektanyMessages"];
        // Extract today MsgIndex
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:ektanyMessages andDate:[NSDate date]];
        displayedMessage = [[ektanyMessages objectAtIndex:todayMsgIndex] mutableCopy];
        [ektanyTableView reloadData];
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

- (void)ektanyWebService:(EktanyWebService *)ektanyWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    // Retrieve ektanyMessages
    ektanyMessages = returnMsgs;
    // Save ektanyMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[ektanyMessages mutableCopy] forKey:@"ektanyMessages"];
    [defaults synchronize];
    // Extract today MsgIndex
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:ektanyMessages andDate:[NSDate date]];
    displayedMessage = [[ektanyMessages objectAtIndex:todayMsgIndex] mutableCopy];
    [self updateView];
    // NSLog(@"defaults_ektanyMessages = %d",[[defaults objectForKey:@"ektanyMessages"] count]);
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 25.0f)];
    //[view setBackgroundColor:[UIColor lightGrayColor]];
    [view setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:240.0/255.0f blue:241.0/255.0f alpha:1.0]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, 5, 70, 70)];
    imageView.image = [UIImage imageNamed:@"ektene.png"];
    [view addSubview:imageView];
    
    UILabel *ektany = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 150, 20)];
    ektany.text = @"إقتنى";
    ektany.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    ektany.adjustsFontSizeToFitWidth = YES;
    ektany.textColor = [UIColor redColor];
    ektany.textAlignment = NSTextAlignmentRight;
    [view addSubview:ektany];
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 150, 20)];
    sectionHeader.text = [displayedMessage objectForKey:@"title"];
    sectionHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    sectionHeader.adjustsFontSizeToFitWidth = YES;
    sectionHeader.textColor = [UIColor colorWithRed:47.0/255.0f green:83.0/255.0f blue:90.0/255.0f alpha:1.0];
    sectionHeader.textAlignment = NSTextAlignmentRight;
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
           // printf("%s", [displayedMessage objectForKey:@"body"]);
            NSAttributedString *bodyText = [[NSAttributedString alloc] initWithString:[displayedMessage objectForKey:@"body"] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)]}];
            CGRect bodyTextRect = [bodyText boundingRectWithSize:(CGSize){ektanyTableView.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
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
        UIImageView *ektanyImageView;
        if (mediaData) {
            ektanyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 270.0f, mediaHeight)];
            ektanyImageView.image = [UIImage imageWithData:mediaData];
        }
        ektanyImageView.center = CGPointMake((cell.contentView.bounds.size.width / 2), ektanyImageView.center.y + 20);
        cell.textLabel.text = nil;
        ektanyImageView.tag = MEDIA_TAG;
        [cell.contentView addSubview:ektanyImageView];
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
        ektanyTableView.allowsSelection = YES;
        // Extract Selected Index
        CGPoint pressLocation = [longPress locationInView:ektanyTableView];
        NSIndexPath *selectedIndex = [ektanyTableView indexPathForRowAtPoint:pressLocation];
        [ektanyTableView selectRowAtIndexPath:selectedIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self performSelector:@selector(deselectRow:) withObject:selectedIndex afterDelay:0.5f];
        // Show CFW Buttons
        btnCopy.hidden = NO;
        btnFb.hidden = NO;
        btnWhtsp.hidden = NO;
        btnShare.hidden = NO;
  
    }
}

- (void)deselectRow:(NSIndexPath *)selectedIndex {
    [ektanyTableView deselectRowAtIndexPath:selectedIndex animated:YES];
    ektanyTableView.allowsSelection = NO;
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
            [AppDelegate showAlertView:[NSString stringWithFormat:@"برجاء تحميل برنامج الواتس اب   "]];
        }
    } else {
        // Body
        NSString *contentString = [[NSString stringWithFormat:@"whatsapp://send?text=%@\n%@\n",[displayedMessage objectForKey:@"title"], [displayedMessage objectForKey:@"body"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *oskofeyaUrlString = [[NSString stringWithFormat:@"\n\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",contentString,oskofeyaUrlString]];
        [cfwObject whatsAppShareURL:url];
    }
}

- (void)hideCFWbButtons {
    btnCopy.hidden = YES;
    btnFb.hidden = YES;
    btnWhtsp.hidden = YES;
    btnShare.hidden = YES;

}

#pragma mark - History Button Method

- (IBAction)loadEktanyHistoryView:(id)sender {
    [self showViewController:ektanyHistoryViewController];
    [self performSelector:@selector(pushViewController:) withObject:ektanyHistoryViewController afterDelay:0.5f];
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

#pragma mark - EktanyHistoryDelegate Method

- (void)ektanyHistoryViewController:(EktanyHistoryViewController *)ektanyHistoryViewController setMessage:(NSMutableDictionary *)historyMessage {
    displayedMessage = historyMessage;
    [self updateView];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissEktanyView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


