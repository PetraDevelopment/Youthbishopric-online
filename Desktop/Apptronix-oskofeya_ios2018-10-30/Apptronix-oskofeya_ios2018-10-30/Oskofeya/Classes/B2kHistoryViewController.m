#import "B2kHistoryViewController.h"

#define ROW_HEIGHT 40

@implementation B2kHistoryViewController

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
    // Initialize engylakWebService
    engylakWebService = [[EngylakWebService alloc] init];
    [engylakWebService setEngylakWsDelegate:self];
    // Initialize b2kHistoryList
    b2kHistoryList = [[NSMutableArray alloc] initWithObjects:nil];
    // Get engylakHistoryMessages
    [engylakWebService getEngylakMessagesForPresentAndFuture:NO];
    [self setupView];
}

- (void)setupView {
    // Set the b2kHistoryTable
    b2kHistoryTable.backgroundColor = [UIColor clearColor];
}



#pragma mark - engylakMessages Handling Methods

- (void)engylakWebService:(EngylakWebService *)engylakWebService errorMessage:(NSString *)errorMsg {
    // Load engylakHistoryMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"engylakHistoryMessages"] != NULL) {
        [self hideActivityIndicator];
        engylakHistoryMessages = [defaults objectForKey:@"engylakHistoryMessages"];
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

- (void)engylakWebService:(EngylakWebService *)engylakWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    engylakHistoryMessages = returnMsgs;
    // Save engylakHistoryMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[engylakHistoryMessages mutableCopy] forKey:@"engylakHistoryMessages"];
    [defaults synchronize];
    [self sortAndLoadHistoryList];
}

- (void)sortAndLoadHistoryList {
    // Sort engylakHistoryMessages accordign to date (descendingly)
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"publish_date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateSort];
    engylakHistoryMessages = [NSMutableArray arrayWithArray:[engylakHistoryMessages sortedArrayUsingDescriptors:sortDescriptors]];
    // Load b2kHistoryList
    int index = 0;
    for (__unused NSDictionary *tempDict in engylakHistoryMessages) {
        [b2kHistoryList addObject:[[engylakHistoryMessages objectAtIndex:index] objectForKey:@"publish_date"]];
        index ++;
    }
    // Update View
    [b2kHistoryTable reloadData];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return [b2kHistoryList count];// return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//[b2kHistoryList count];
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
    [[cell textLabel] setText:[b2kHistoryList objectAtIndex:indexPath.section]];
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
    NSString *selectedDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    selectedDate = [b2kHistoryList objectAtIndex:indexPath.section];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    // Extract todayMsgIndex
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    int todayMsgIndex = [dateIndexObject extractDateIndexFromMessages:engylakHistoryMessages andDate:[dateFormat dateFromString:selectedDate]];
    [self.b2kHistoryDelegate b2kHistoryViewController:self setMessage:[[engylakHistoryMessages objectAtIndex:todayMsgIndex] mutableCopy]];
    [self dismissB2kHistoryView:nil];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissB2kHistoryView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


