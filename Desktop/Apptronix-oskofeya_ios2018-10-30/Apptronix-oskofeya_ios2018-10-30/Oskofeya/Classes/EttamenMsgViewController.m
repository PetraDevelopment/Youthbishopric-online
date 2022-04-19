
#import "EttamenMsgViewController.h"

#define MEDIA_TAG 777

@implementation EttamenMsgViewController

@synthesize feelingNameStr;
@synthesize feelingMsgBody;
@synthesize feelingMsgQuote;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@" ", @" ");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateView];
    [self hideCFWbButtons];
}

- (void)setupView {
    // Set the ettamenMsgTableView
    ettamenMsgTableView.backgroundColor = [UIColor clearColor];
    ettamenMsgTableView.separatorColor = [UIColor clearColor];
    ettamenMsgTableView.allowsSelection = NO;
}

- (void)updateView {
    // Set fontSize
    fontSize = 17.0;
    [self updateTable];
}

- (void)updateTable {
    [ettamenMsgTableView reloadData];
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
    [view setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:240.0/255.0f blue:241.0/255.0f alpha:1.0]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, 5, 70, 70)];
    
    imageView.image = [UIImage imageNamed:@"etamen.png"];
    [view addSubview:imageView];
    
    UILabel *ektany = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 150, 20)];
    ektany.text = @"حاسس بـ...";
    ektany.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    ektany.adjustsFontSizeToFitWidth = YES;
    ektany.textColor = [UIColor redColor];
    ektany.textAlignment = NSTextAlignmentRight;
    [view addSubview:ektany];
    
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 150, 20)];
    sectionHeader.text = feelingNameStr;
    sectionHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    sectionHeader.adjustsFontSizeToFitWidth = YES;
    sectionHeader.textColor = [UIColor colorWithRed:47.0/255.0f green:83.0/255.0f blue:90.0/255.0f alpha:1.0];
    sectionHeader.textAlignment = NSTextAlignmentRight;
    [view addSubview:sectionHeader];
    return view;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowsCount = 0;
    if (![feelingMsgBody isEqual:[NSNull null]]) {
        rowsCount += 1;
    }
    if (![feelingMsgQuote isEqual:[NSNull null]]) {
        rowsCount += 1;
    }
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSAttributedString *bodyText = [[NSAttributedString alloc] initWithString:feelingMsgBody attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)]}];
        CGRect bodyTextRect = [bodyText boundingRectWithSize:(CGSize){ettamenMsgTableView.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize bodyTextSize = bodyTextRect.size;
        CGFloat rowHeight = bodyTextSize.height;
        if (rowHeight <= 75.0) { // One line
            rowHeight = 75.0;
        }
        return rowHeight;
    } else {
        return 45.0;
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
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        cell.textLabel.text = feelingMsgBody;
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = feelingMsgQuote;
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
        ettamenMsgTableView.allowsSelection = YES;
        // Extract Selected Index
        CGPoint pressLocation = [longPress locationInView:ettamenMsgTableView];
        NSIndexPath *selectedIndex = [ettamenMsgTableView indexPathForRowAtPoint:pressLocation];
        [ettamenMsgTableView selectRowAtIndexPath:selectedIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self performSelector:@selector(deselectRow:) withObject:selectedIndex afterDelay:0.5f];
        // Show CFW Buttons
        btnCopy.hidden = NO;
        btnFb.hidden = NO;
        btnWhtsp.hidden = NO;
        btnShare.hidden = NO;
    }
}

- (void)deselectRow:(NSIndexPath *)selectedIndex {
    [ettamenMsgTableView deselectRowAtIndexPath:selectedIndex animated:YES];
    ettamenMsgTableView.allowsSelection = NO;
}

- (IBAction)copyFeature {
    [self hideCFWbButtons];
    NSString *copiedString = [NSString stringWithFormat:@"انا النهارده %@\n%@\n%@", feelingNameStr, feelingMsgBody, feelingMsgQuote];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject copyContent:copiedString];
}

- (IBAction)facebookShare {
    [self hideCFWbButtons];
    NSString *facebookMsg = [NSString stringWithFormat:@"انا النهارده %@\n%@\n%@\n\nتطبيق أسقفية الشباب أونلاين\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", feelingNameStr, feelingMsgBody, feelingMsgQuote];
    CFWObject *cfwObject = [[CFWObject alloc] init];
    [cfwObject facebookShareContent:facebookMsg fromViewController:self];
}

- (IBAction)whatsAppShare {
    [self hideCFWbButtons];
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"whatsapp://send?text=انا النهارده %@\n%@\n%@\n\nتطبيق أسقفية الشباب أونلاين\nhttps://www.facebook.com/youthbishopriconline?\nللأندرويد: https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp", feelingNameStr, feelingMsgBody, feelingMsgQuote] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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

#pragma mark - Dismiss Method

- (IBAction)dismissEttamenMsgView:(id)sender {
    feelingNameStr = nil;
    feelingMsgBody = nil;
    feelingMsgQuote = nil;
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


