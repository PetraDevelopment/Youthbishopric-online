#import "BelmaHistoryViewController.h"


@implementation BelmaHistoryViewController

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
    // Initialize ma3refaWebService
    ma3refaWebService = [[Ma3refaWebService alloc] init];
    [ma3refaWebService setMa3refaWsDelegate:self];
    // Initialize belmaHistoryList
    belmaHistoryList = [[NSMutableArray alloc] initWithObjects:nil];
    // Get ma3refaHistoryMessages
    [ma3refaWebService getMa3refaMessagesForPresentAndFuture:NO];
    [self setupView];
}

- (void)setupView {
    // Set the belmaHistoryTable
    belmaHistoryTable.backgroundColor = [UIColor clearColor];
}

#pragma mark - ma3refaMessages Handling Methods

- (void)ma3refaWebService:(Ma3refaWebService *)ma3refaWebService errorMessage:(NSString *)errorMsg {
    // Load ma3refaHistoryMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ma3refaHistoryMessages"] != NULL) {
        [self hideActivityIndicator];
        ma3refaHistoryMessages = [defaults objectForKey:@"ma3refaHistoryMessages"];
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

- (void)ma3refaWebService:(Ma3refaWebService *)ma3refaWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    ma3refaHistoryMessages = returnMsgs;
    // Save ma3refaHistoryMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[ma3refaHistoryMessages mutableCopy] forKey:@"ma3refaHistoryMessages"];
    [defaults synchronize];
    [self sortAndLoadHistoryList];
}

- (void)sortAndLoadHistoryList {
    // Sort ma3refaHistoryMessages accordign to date (descendingly)
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"publish_date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateSort];
    ma3refaHistoryMessages = [NSMutableArray arrayWithArray:[ma3refaHistoryMessages sortedArrayUsingDescriptors:sortDescriptors]];
    // Load belmaHistoryList
    int index = 0;
    for (__unused NSDictionary *tempDict in ma3refaHistoryMessages) {
        NSMutableDictionary *tempMutableDict = [[NSMutableDictionary alloc] init];
        [tempMutableDict setObject:[[ma3refaHistoryMessages objectAtIndex:index] objectForKey:@"title"] forKey:@"title"];
        [tempMutableDict setObject:[[ma3refaHistoryMessages objectAtIndex:index] objectForKey:@"publish_date"] forKey:@"publish_date"];
        [belmaHistoryList addObject:tempMutableDict];
        index ++;
    }
    // Update View
    [belmaHistoryTable reloadData];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return [belmaHistoryList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;// [belmaHistoryList count];
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
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@\n%@\t\t\t\t\t\t\t\t",[[belmaHistoryList objectAtIndex:indexPath.section] objectForKey:@"title"],[[belmaHistoryList objectAtIndex:indexPath.section] objectForKey:@"publish_date"]]];
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
    selectedTitle = [[belmaHistoryList objectAtIndex:indexPath.section] objectForKey:@"title"];
    // Extract MsgIndex from Title
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    int todayMsgIndex = [dateIndexObject extractTitleIndexFromMessages:ma3refaHistoryMessages andTitle:selectedTitle];
    [self.belmaHistoryDelegate belmaHistoryViewController:self setMessage:[[ma3refaHistoryMessages objectAtIndex:todayMsgIndex] mutableCopy]];
    [self dismissBelmaHistoryView:nil];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissBelmaHistoryView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


