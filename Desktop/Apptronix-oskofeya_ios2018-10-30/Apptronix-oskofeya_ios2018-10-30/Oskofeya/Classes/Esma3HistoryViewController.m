
#import "Esma3HistoryViewController.h"


@implementation Esma3HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"", @"");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize esma3WebService
    esma3WebService = [[Esma3WebService alloc] init];
    [esma3WebService setEsma3WsDelegate:self];
    // Initialize esma3HistoryList
    esma3HistoryList = [[NSMutableArray alloc] initWithObjects:nil];
    // Get esma3HistoryMessages
    [esma3WebService getEsma3MessagesForPresentAndFuture:NO];
    [self setupView];
}

- (void)setupView {
    // Set the esma3HistoryTable
    esma3HistoryTable.backgroundColor = [UIColor clearColor];
}

#pragma mark - esma3Messages Handling Methods

- (void)esma3WebService:(Esma3WebService *)esma3WebService errorMessage:(NSString *)errorMsg {
    // Load esma3HistoryMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"esma3HistoryMessages"] != NULL) {
        [self hideActivityIndicator];
        esma3HistoryMessages = [defaults objectForKey:@"esma3HistoryMessages"];
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

- (void)esma3WebService:(Esma3WebService *)esma3WebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    esma3HistoryMessages = returnMsgs;
    // Save esma3HistoryMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[esma3HistoryMessages mutableCopy] forKey:@"esma3HistoryMessages"];
    [defaults synchronize];
    [self sortAndLoadHistoryList];
}

- (void)sortAndLoadHistoryList {
    // Sort esma3HistoryMessages accordign to date (descendingly)
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"remove_date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateSort];
    esma3HistoryMessages = [NSMutableArray arrayWithArray:[esma3HistoryMessages sortedArrayUsingDescriptors:sortDescriptors]];
    // Load esma3HistoryList
    int index = 0;
    for (__unused NSDictionary *tempDict in esma3HistoryMessages) {
        [esma3HistoryList addObject:[[esma3HistoryMessages objectAtIndex:index] objectForKey:@"title"]];
        index ++;
    }
    // Update View
    [esma3HistoryTable reloadData];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [esma3HistoryList count];
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
    [[cell textLabel] setText:[esma3HistoryList objectAtIndex:indexPath.section]];
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
    selectedTitle = [esma3HistoryList objectAtIndex:indexPath.section];
    // Extract MsgIndex from Title
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    int todayMsgIndex = [dateIndexObject extractTitleIndexFromMessages:esma3HistoryMessages andTitle:selectedTitle];
    [self.esma3HistoryDelegate esma3HistoryViewController:self setMessage:[[esma3HistoryMessages objectAtIndex:todayMsgIndex] mutableCopy]];
    [self dismissEsma3HistoryView:nil];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissEsma3HistoryView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


