#import "ShoufHistoryViewController.h"

@implementation ShoufHistoryViewController

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
    // Initialize shoufWebService
    shoufWebService = [[ShoufWebService alloc] init];
    [shoufWebService setShoufWsDelegate:self];
    // Initialize shoufHistoryList
    shoufHistoryList = [[NSMutableArray alloc] initWithObjects:nil];
    // Get shoufHistoryMessages
    [shoufWebService getShoufMessagesForPresentAndFuture:NO];
    [self setupView];
}

- (void)setupView {
    // Set the shoufHistoryTable
    shoufHistoryTable.backgroundColor = [UIColor clearColor];
}

#pragma mark - shoufMessages Handling Methods

- (void)shoufWebService:(ShoufWebService *)shoufWebService errorMessage:(NSString *)errorMsg {
    // Load shoufHistoryMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"shoufHistoryMessages"] != NULL) {
        [self hideActivityIndicator];
        shoufHistoryMessages = [defaults objectForKey:@"shoufHistoryMessages"];
        [self sortAndLoadHistoryList];
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

- (void)shoufWebService:(ShoufWebService *)shoufWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    shoufHistoryMessages = returnMsgs;
    // Save shoufHistoryMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[shoufHistoryMessages mutableCopy] forKey:@"shoufHistoryMessages"];
    [defaults synchronize];
    [self sortAndLoadHistoryList];
}

- (void)sortAndLoadHistoryList {
    // Sort shoufHistoryMessages accordign to date (descendingly)
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"remove_date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateSort];
    shoufHistoryMessages = [NSMutableArray arrayWithArray:[shoufHistoryMessages sortedArrayUsingDescriptors:sortDescriptors]];
    // Load shoufHistoryList
    int index = 0;
    for (__unused NSDictionary *tempDict in shoufHistoryMessages) {
        [shoufHistoryList addObject:[[shoufHistoryMessages objectAtIndex:index] objectForKey:@"title"]];
        index ++;
    }
    // Update View
    [shoufHistoryTable reloadData];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [shoufHistoryList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell textLabel] setText:[shoufHistoryList objectAtIndex:indexPath.section]];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.borderWidth = 1.2;
    cell.layer.cornerRadius = 10;
    cell.clipsToBounds = true;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectedTitle;
    selectedTitle = [shoufHistoryList objectAtIndex:indexPath.section];
    // Extract MsgIndex from Title
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    int todayMsgIndex = [dateIndexObject extractTitleIndexFromMessages:shoufHistoryMessages andTitle:selectedTitle];
    [self.shoufHistoryDelegate shoufHistoryViewController:self setMessage:[[shoufHistoryMessages objectAtIndex:todayMsgIndex] mutableCopy]];
    [self dismissShoufHistoryView:nil];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissShoufHistoryView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


