#import "Belma3refaViewController.h"

#define MEDIA_TAG 777

@implementation Belma3refaViewController

@synthesize todayMsgIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"إشبع بالمعرفة",@"إشبع بالمعرفة");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize belmaHistoryViewController
    belmaHistoryViewController = [[BelmaHistoryViewController alloc] initWithNibName:@"BelmaHistoryView_i5" bundle:nil];
    [belmaHistoryViewController setBelmaHistoryDelegate:self];
    // Initialize ma3refaWebService
    ma3refaWebService = [[Ma3refaWebService alloc] init];
    [ma3refaWebService setMa3refaWsDelegate:self];
    // Get Present & Future ma3refaMessages
    [ma3refaWebService getMa3refaMessagesForPresentAndFuture:YES];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (todayMsgIndex == 1000) {
        // Navigating from Eshba3View
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:ma3refaMessages andDate:[NSDate date]];
        displayedMessage = [[ma3refaMessages objectAtIndex:todayMsgIndex] mutableCopy];
        [self updateView];
    }
    [self hideCFWbButtons];
}
- (void)setupView {
    // Set belma3refaTitle
    belma3refaTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:(17)];
    belma3refaTitle.adjustsFontSizeToFitWidth = YES;
    belma3refaTitle.text = [displayedMessage objectForKey:@"title"];
    // Set belma3refaTableView
    belma3refaTableView.backgroundColor = [UIColor clearColor];
    belma3refaTableView.separatorColor = [UIColor clearColor];
    belma3refaTableView.allowsSelection = NO;
}

- (void)updateView {
    // Set fontSize
    fontSize = 17.0;
    [self updateTitleAndTable];
}

- (void)updateTitleAndTable {
    // Update belma3refaTitle
    belma3refaTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:(17)];
    belma3refaTitle.text = [displayedMessage objectForKey:@"title"];
    // Update belma3refaTableView
    [belma3refaTableView reloadData];
}

#pragma mark - ma3refaMessages Handling Methods

- (void)ma3refaWebService:(Ma3refaWebService *)ma3refaWebService errorMessage:(NSString *)errorMsg {
    // Load ma3refaMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ma3refaMessages"] != NULL && [defaults objectForKey:@"ma3refaMessages"] != nil)  {
        [self hideActivityIndicator];
        ma3refaMessages = [defaults objectForKey:@"ma3refaMessages"];
        // Extract today MsgIndex

            DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
            todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:ma3refaMessages andDate:[NSDate date]];
            displayedMessage = [[ma3refaMessages objectAtIndex:todayMsgIndex] mutableCopy];
        
        [self updateView];
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

- (void)ma3refaWebService:(Ma3refaWebService *)ma3refaWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    // Retrieve ma3refaMessages
    ma3refaMessages = returnMsgs;
    // Save ma3refaMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[ma3refaMessages mutableCopy] forKey:@"ma3refaMessages"];
    [defaults synchronize];
    
    @try
    {
        // Extract today MsgIndex
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:ma3refaMessages andDate:[NSDate date]];
        displayedMessage = [[ma3refaMessages objectAtIndex:todayMsgIndex] mutableCopy];
    }
    @catch (NSException *exception)
    {
        
        NSLog(@"%@ ",exception.name);
        NSLog(@"Reason: %@ ",exception.reason);
    }
    @finally
    {
        NSLog(@"@@finaly Always Executes");
    }
    
    [self updateView];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowsCount = 1;
    if ((todayMsgIndex != 1000) && (displayedMessage != nil)) {
        if (![[displayedMessage objectForKey:@"quote"] isEqualToString:@""]) {
            rowsCount += 1;
        }
        if ((![[displayedMessage objectForKey:@"photo"] isEqualToString:@""]) && (![[displayedMessage objectForKey:@"photo"] isEqualToString:@"/images/medium/missing.png"])) {
            rowsCount += 1;
        }
    }
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((todayMsgIndex != 1000) && (displayedMessage != nil)) {
        if (indexPath.row == 0) {
            // Body
            NSAttributedString *bodyText = [[NSAttributedString alloc] initWithString:[displayedMessage objectForKey:@"body"] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)]}];
            CGRect bodyTextRect = [bodyText boundingRectWithSize:(CGSize){belma3refaTableView.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            CGSize bodyTextSize = bodyTextRect.size;
            CGFloat rowHeight = bodyTextSize.height;
            if (rowHeight <= 45.0) { // One line
                rowHeight = 45.0;
            }
            return rowHeight;
        } else if ((indexPath.row == 1) && (![[displayedMessage objectForKey:@"quote"] isEqualToString:@""])) {
            return 45.0; // Quote
        } else {
            // Image
            NSData *mediaData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/%@",[displayedMessage objectForKey:@"photo"]]]];
            float mediaHeight = 177.0f * (([[UIImage imageWithData:mediaData] size].height * 2) / ([[UIImage imageWithData:mediaData] size].width * 2));
            if (mediaData) {
                return (mediaHeight + 20.0);
            } else {
                return 0;
            }
        }
    } else {
        // (todayMsgIndex = 1000)
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell.contentView viewWithTag:MEDIA_TAG] removeFromSuperview];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        cell.textLabel.text = [displayedMessage objectForKey:@"body"];
    } else if ((indexPath.row == 1) && (![[displayedMessage objectForKey:@"quote"] isEqualToString:@""])) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = [displayedMessage objectForKey:@"quote"];
    } else {
        NSData *mediaData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/%@",[displayedMessage objectForKey:@"photo"]]]];
        float mediaHeight = 177.0f * (([[UIImage imageWithData:mediaData] size].height * 2) / ([[UIImage imageWithData:mediaData] size].width * 2));
        UIImageView *belma3refaMedia;
        if (mediaData) {
            belma3refaMedia = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 177.0f, mediaHeight)];
            belma3refaMedia.image = [UIImage imageWithData:mediaData];
        }
        belma3refaMedia.center = CGPointMake((cell.contentView.bounds.size.width / 2), belma3refaMedia.center.y + 20);
        cell.textLabel.text = nil;
        belma3refaMedia.tag = MEDIA_TAG;
        [cell.contentView addSubview:belma3refaMedia];
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
        [self updateTitleAndTable];
    }
}

- (IBAction)decreaseFontSize {
    if(fontSize > 6)
    {
        fontSize = fontSize - 1;
        [self updateTitleAndTable];
    }
}

#pragma mark - CFW Related Methods

- (void)handleLongPress:(UIGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        belma3refaTableView.allowsSelection = YES;
        // Extract Selected Index
        CGPoint pressLocation = [longPress locationInView:belma3refaTableView];
        NSIndexPath *selectedIndex = [belma3refaTableView indexPathForRowAtPoint:pressLocation];
        [belma3refaTableView selectRowAtIndexPath:selectedIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self performSelector:@selector(deselectRow:) withObject:selectedIndex afterDelay:0.5f];
        // Show CFW Buttons
        btnCopy.hidden = NO;
        btnFb.hidden = NO;
        btnWhtsp.hidden = NO;
        btnShare.hidden = NO;
    }
}

- (void)deselectRow:(NSIndexPath *)selectedIndex {
    [belma3refaTableView deselectRowAtIndexPath:selectedIndex animated:YES];
    belma3refaTableView.allowsSelection = NO;
}

- (IBAction)copyFeature {
    [self hideCFWbButtons];
    NSString *copiedString = [NSString stringWithFormat:@"%@\n%@",[displayedMessage objectForKey:@"title"], [displayedMessage objectForKey:@"body"]];
    if (![[displayedMessage objectForKey:@"quote"] isEqualToString:@""]) {
        copiedString = [copiedString stringByAppendingString:[NSString stringWithFormat:@"\n%@",[displayedMessage objectForKey:@"quote"]]];
    }
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject copyContent:copiedString];
}

- (IBAction)facebookShare {
    [self hideCFWbButtons];
    NSString *facebookMsg = [NSString stringWithFormat:@"%@\n%@",[displayedMessage objectForKey:@"title"], [displayedMessage objectForKey:@"body"]];
    if (![[displayedMessage objectForKey:@"quote"] isEqualToString:@""]) {
        facebookMsg = [facebookMsg stringByAppendingString:[NSString stringWithFormat:@"\n%@",[displayedMessage objectForKey:@"quote"]]];
    }
    facebookMsg = [facebookMsg stringByAppendingString:[NSString stringWithFormat:@"\n\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp"]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject facebookShareContent:facebookMsg fromViewController:self];
}

- (IBAction)whatsAppShare {
    [self hideCFWbButtons];
    NSString *contentString = [[NSString stringWithFormat:@"whatsapp://send?text=%@\n%@",[displayedMessage objectForKey:@"title"], [displayedMessage objectForKey:@"body"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (![[displayedMessage objectForKey:@"quote"] isEqualToString:@""]) {
        contentString = [contentString stringByAppendingString:[[NSString stringWithFormat:@"\n%@",[displayedMessage objectForKey:@"quote"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    contentString = [contentString stringByAppendingString:[@"\n" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *oskofeyaUrlString = [[NSString stringWithFormat:@"\n\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",contentString,oskofeyaUrlString]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject whatsAppShareURL:url];
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

- (IBAction)loadBelmaHistoryView:(id)sender {
    [self showViewController:belmaHistoryViewController];
    [self performSelector:@selector(pushViewController:) withObject:belmaHistoryViewController afterDelay:0.5f];
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

#pragma mark - BelmaHistoryDelegate Method

- (void)belmaHistoryViewController:(BelmaHistoryViewController *)belmaHistoryViewController setMessage:(NSMutableDictionary *)historyMessage {
    displayedMessage = historyMessage;
    [self updateView];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissBelma3refaView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end



