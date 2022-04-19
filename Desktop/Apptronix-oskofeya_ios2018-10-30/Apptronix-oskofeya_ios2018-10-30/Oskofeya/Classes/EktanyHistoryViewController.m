#import "EktanyHistoryViewController.h"

#define ROW_HEIGHT 50 // 40

@implementation EktanyHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"", @" ");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize ektanyWebService
    ektanyWebService = [[EktanyWebService alloc] init];
    [ektanyWebService setEktanyWsDelegate:self];
    // Initialize ektanyHistoryList
    ektanyHistoryList = [[NSMutableArray alloc] initWithObjects:nil];
    // Get ektanyHistoryMessages
    [ektanyWebService getEktanyMessagesForPresentAndFuture:NO];
    [self setupView];
}

- (void)setupView {
    // Set the ektanyHistoryTable
    ektanyHistoryTable.backgroundColor = [UIColor clearColor];
}

#pragma mark - ektanyMessages Handling Methods

- (void)ektanyWebService:(EktanyWebService *)ektanyWebService errorMessage:(NSString *)errorMsg {
    // Load ektanyHistoryMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ektanyHistoryMessages"] != NULL) {
        [self hideActivityIndicator];
        ektanyHistoryMessages = [defaults objectForKey:@"ektanyHistoryMessages"];
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

- (void)ektanyWebService:(EktanyWebService *)ektanyWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    ektanyHistoryMessages = returnMsgs;
    // Save ektanyHistoryMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[ektanyHistoryMessages mutableCopy] forKey:@"ektanyHistoryMessages"];
    [defaults synchronize];
    [self sortAndLoadHistoryList];
}

- (void)sortAndLoadHistoryList {
    // Sort ektanyHistoryMessages accordign to date (descendingly)
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"publish_date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateSort];
    ektanyHistoryMessages = [NSMutableArray arrayWithArray:[ektanyHistoryMessages sortedArrayUsingDescriptors:sortDescriptors]];
    // Load ektanyHistoryList
    int index = 0;
    for (__unused NSDictionary *tempDict in ektanyHistoryMessages) {
        NSMutableDictionary *tempMutableDict = [[NSMutableDictionary alloc] init];
        [tempMutableDict setObject:[[ektanyHistoryMessages objectAtIndex:index] objectForKey:@"title"] forKey:@"title"];
        [tempMutableDict setObject:[[ektanyHistoryMessages objectAtIndex:index] objectForKey:@"publish_date"] forKey:@"publish_date"];
        [ektanyHistoryList addObject:tempMutableDict];
        index ++;
    }
    // Update View
    [ektanyHistoryTable reloadData];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [ektanyHistoryList count];
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
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@\n%@\t\t\t\t\t\t\t\t",[[ektanyHistoryList objectAtIndex:indexPath.section] objectForKey:@"title"],[[ektanyHistoryList objectAtIndex:indexPath.section] objectForKey:@"publish_date"]]];
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
    selectedTitle = [[ektanyHistoryList objectAtIndex:indexPath.section] objectForKey:@"title"];
    // Extract MsgIndex from Title
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    int todayMsgIndex = [dateIndexObject extractTitleIndexFromMessages:ektanyHistoryMessages andTitle:selectedTitle];
    [self.ektanyHistoryDelegate ektanyHistoryViewController:self setMessage:[[ektanyHistoryMessages objectAtIndex:todayMsgIndex] mutableCopy]];
    [self dismissEktanyHistoryView:nil];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissEktanyHistoryView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


