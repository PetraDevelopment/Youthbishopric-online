#import "E3rafViewController.h"

#define MEDIA_TAG 777

@implementation E3rafViewController

@synthesize e3rafMessages;
@synthesize e3rafDisplayedMessages;
@synthesize navigatingFromMain;
@synthesize shouldHideActivityIndicator;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"إعرف", @"إعرف");
    }
    return self;
}


#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize e3rafHistoryViewController
    e3rafHistoryViewController = [[E3rafHistoryViewController alloc] initWithNibName:@"E3rafHistoryView_i5" bundle:nil];
    [e3rafHistoryViewController setE3rafHistoryDelegate:self];
    // Update lastDateE3rafWasChecked
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentDateStr forKey:@"lastDateE3rafWasChecked"];
    [defaults synchronize];

    e3rafWebService = [[E3rafWebService alloc] init];
    [e3rafWebService setE3rafWsDelegate:self];
    // Initialize e3rafHistoryList & e3rafHistorySetOfMessages
    e3rafHistorySet = [[NSMutableOrderedSet alloc] initWithObjects:nil];
    e3rafHistorySetOfMessages = [[NSMutableArray alloc] initWithObjects:nil];
    // Get e3rafHistoryMessages
    [e3rafWebService getE3rafMessagesForPresentAndFuture:NO];
    [self setupView];
}


- (void)e3rafWebService:(E3rafWebService *)e3rafWebService returnMessages:(NSMutableArray *)returnMsgs
{
    [self hideActivityIndicator];
    e3rafHistoryMessages = returnMsgs;
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"publish_date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateSort];
    e3rafHistoryMessages = [NSMutableArray arrayWithArray:[e3rafHistoryMessages sortedArrayUsingDescriptors:sortDescriptors]];
    // Load e3rafHistoryList
    int index = 0;
    for (__unused NSDictionary *tempDict in e3rafHistoryMessages) {
        [e3rafHistorySet addObject:[[e3rafHistoryMessages objectAtIndex:index] objectForKey:@"publish_date"]];
        index ++;
    }
    [self fillE3rafHistorySetOfMessagesWithData];
    if (navigatingFromMain == YES) {
        e3rafDisplayedMessages =[e3rafHistorySetOfMessages objectAtIndex:0];
        [self updateView];
    }
}

- (void)fillE3rafHistorySetOfMessagesWithData {
    int index = 0;
    for (__unused NSDictionary *tempDict in e3rafHistorySet) {
        int subIndex = 0;
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:nil];
        for (__unused NSDictionary *tempDict in e3rafHistoryMessages) {
            if ([[[e3rafHistoryMessages objectAtIndex:subIndex]objectForKey:@"publish_date"] isEqualToString:[e3rafHistorySet objectAtIndex:index]]) {
                [tempArray addObject:[e3rafHistoryMessages objectAtIndex:subIndex]];
            }
            subIndex ++;
        }
        [e3rafHistorySetOfMessages addObject:tempArray];
        index ++;
    }
}


- (void)viewWillAppear:(BOOL)animated {
  /*  if (navigatingFromMain == YES) {
        /*NSString *dateString =  @"2018-06-12";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date1 = [dateFormatter dateFromString:dateString];
        // Display only current and past Publish Date messages
        DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
        NSLog(@"%@", dateIndexObject);
        e3rafDisplayedMessages = [dateIndexObject extractPresentAndPastPublishDateMessagesFromMessages:[e3rafMessages mutableCopy] andCurrentDate:date1];
        
        e3rafDisplayedMessages =[e3rafHistorySetOfMessages objectAtIndex:0];
        [self updateView];   
    }*/
    // [self updateView];   
    [self hideCFWbButtons];
    
    /*
         [self.e3rafHistoryDelegate e3rafHistoryViewController:self setE3rafMessages:[e3rafHistorySetOfMessages objectAtIndex:indexPath.section]];
     */
}

- (void)setupView {
    // Set fontSize
    fontSize = 17.0;
    // Set the e3rafTableView
    e3rafTableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    e3rafTableView.separatorColor = [UIColor clearColor];
    e3rafTableView.allowsSelection = NO;
}

- (void)updateView {
    // Set fontSize
    fontSize = 17.0;
    if (shouldHideActivityIndicator) {
        [self hideActivityIndicator];
    }
    else {
       
        [self showActivityIndicatorWithMessage:@"جاري التحـمـيل"];
        if ([e3rafDisplayedMessages count] == 0  || e3rafDisplayedMessages == NULL) {
            [self showActivityIndicatorWithMessage:@"برجاء التأكد من الاتصال بالانترنت"];
            [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:10.0f];
        }
    }
    [self updateTable];
}

- (void)updateTable {
    [e3rafTableView reloadData];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [e3rafDisplayedMessages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect sectionHeaderRect = CGRectMake(0, 0, 0, 0);
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:sectionHeaderRect];
    sectionHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    sectionHeader.adjustsFontSizeToFitWidth = YES;
    sectionHeader.text = [[e3rafDisplayedMessages objectAtIndex:section] objectForKey:@"title"];
    sectionHeader.textColor = [UIColor darkTextColor];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    sectionHeader.textAlignment = NSTextAlignmentRight;
    sectionHeader.numberOfLines = 0;
    sectionHeader.lineBreakMode = NSLineBreakByTruncatingTail;
    return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowsCount = 1;
    if ((![[[e3rafDisplayedMessages objectAtIndex:section] objectForKey:@"photo"] isEqualToString:@""]) && (![[[e3rafDisplayedMessages objectAtIndex:section] objectForKey:@"photo"] isEqualToString:@"/images/medium/missing.png"])) {
        rowsCount += 1;
    }
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // Body
        CGFloat rowHeight = [[[e3rafDisplayedMessages objectAtIndex:indexPath.section] objectForKey:@"body"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)] constrainedToSize:CGSizeMake(e3rafTableView.frame.size.width,1920.0) lineBreakMode:NSLineBreakByWordWrapping].height;
        if (rowHeight <= 60.0) { // One line
            rowHeight = 60.0;
        }
        return rowHeight;
    } else {
        // Image
        NSData *mediaData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/%@",[[e3rafDisplayedMessages objectAtIndex:indexPath.section] objectForKey:@"photo"]]]];
        float mediaHeight = 177.0f * (([[UIImage imageWithData:mediaData] size].height * 2) / ([[UIImage imageWithData:mediaData] size].width * 2));
        if (mediaData) {
            return (mediaHeight + 20.0);
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
    if (indexPath.row == 0) {
        cell.textLabel.text = [[e3rafDisplayedMessages objectAtIndex:indexPath.section] objectForKey:@"body"];
    } else {

        NSData *mediaData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/%@",[[e3rafDisplayedMessages objectAtIndex:indexPath.section] objectForKey:@"photo"]]]];
        float mediaHeight = 177.0f * (([[UIImage imageWithData:mediaData] size].height * 2) / ([[UIImage imageWithData:mediaData] size].width * 2));
        UIImageView *e3rafMedia;
        if (mediaData) {
            e3rafMedia = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 177.0f, mediaHeight)];
            e3rafMedia.image = [UIImage imageWithData:mediaData];
        }
        e3rafMedia.center = CGPointMake((cell.contentView.bounds.size.width / 2), e3rafMedia.center.y + 20);
        cell.textLabel.text = nil;
        e3rafMedia.tag = MEDIA_TAG;
        [cell.contentView addSubview:e3rafMedia];
        
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
        
      /*  NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        //You can add one or more indexPath in this array...
        
        [e3rafTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];*/
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
        e3rafTableView.allowsSelection = YES;
        // Extract Selected Index
        CGPoint pressLocation = [longPress locationInView:e3rafTableView];
        NSIndexPath *selectedIndex = [e3rafTableView indexPathForRowAtPoint:pressLocation];
        [e3rafTableView selectRowAtIndexPath:selectedIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
        selectedE3rafItemNum = selectedIndex.section;
        [self performSelector:@selector(deselectRow:) withObject:selectedIndex afterDelay:0.5f];
        // Show CFW Buttons
        btnCopy.hidden = NO;
        btnFb.hidden = NO;
        btnWhtsp.hidden = NO;
        btnShare.hidden = NO;
    }
}

- (void)deselectRow:(NSIndexPath *)selectedIndex {
    [e3rafTableView deselectRowAtIndexPath:selectedIndex animated:YES];
    e3rafTableView.allowsSelection = NO;
}

- (IBAction)copyFeature {
    [self hideCFWbButtons];
    NSString *copiedString = [NSString stringWithFormat:@"%@\n%@", [[e3rafDisplayedMessages objectAtIndex:selectedE3rafItemNum] objectForKey:@"title"], [[e3rafDisplayedMessages objectAtIndex:selectedE3rafItemNum] objectForKey:@"body"]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject copyContent:copiedString];
}

- (IBAction)facebookShare {
    [self hideCFWbButtons];
    NSString *facebookMsg = [NSString stringWithFormat:@"%@\n%@",[[e3rafDisplayedMessages objectAtIndex:selectedE3rafItemNum] objectForKey:@"title"], [[e3rafDisplayedMessages objectAtIndex:selectedE3rafItemNum] objectForKey:@"body"]];
    facebookMsg = [facebookMsg stringByAppendingString:[NSString stringWithFormat:@"\n\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp"]];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject facebookShareContent:facebookMsg fromViewController:self];
}

- (IBAction)whatsAppShare {
    [self hideCFWbButtons];
    NSString *contentString = [[NSString stringWithFormat:@"whatsapp://send?text=%@\n%@\n",[[e3rafDisplayedMessages objectAtIndex:selectedE3rafItemNum] objectForKey:@"title"], [[e3rafDisplayedMessages objectAtIndex:selectedE3rafItemNum] objectForKey:@"body"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *oskofeyaUrlString = [[NSString stringWithFormat:@"\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

- (IBAction)loadE3rafHistoryView:(id)sender {
    navigatingFromMain = NO;
    [self showViewController:e3rafHistoryViewController];
    [self performSelector:@selector(pushViewController:) withObject:e3rafHistoryViewController afterDelay:0.5f];
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

#pragma mark - E3rafHistoryDelegate Method

- (void)e3rafHistoryViewController:(E3rafHistoryViewController *)e3rafHistoryViewController setE3rafMessages:(NSMutableArray *)e3rafMessagesInDay {
    [aiMsg setText:@""];
    aiView.hidden = YES;
    e3rafDisplayedMessages = [e3rafMessagesInDay mutableCopy];
    [self updateView];
}

#pragma mark - Activity Indicator Methods

- (void)showActivityIndicatorWithMessage:(NSString *)message {
    // Display Message
    [aiMsg setText:@""];
    aiView.hidden = YES;
    
}

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

#pragma mark - Dismiss Method

- (IBAction)dismissE3rafView:(id)sender {
    navigatingFromMain = YES;
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end



