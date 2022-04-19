#import "Es2alHistoryViewController.h"

#define ROW_HEIGHT 80 // 40

@implementation Es2alHistoryViewController

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
    // Initialize es2alWebService
    es2alWebService = [[Es2alWebService alloc] init];
    [es2alWebService setEs2alWsDelegate:self];
    // Initialize es2alHistoryList
    es2alHistoryList = [[NSMutableArray alloc] initWithObjects:nil];
    // Get es2alHistoryMessages
    [es2alWebService getEs2alMessagesForPresentAndFuture:NO];
    [self setupView];
}

- (void)setupView {
    // Set the es2alHistoryTable
    es2alHistoryTable.backgroundColor = [UIColor clearColor];
}

#pragma mark - es2alMessages Handling Methods

- (void)es2alWebService:(Es2alWebService *)es2alWebService errorMessage:(NSString *)errorMsg {
    // Load es2alHistoryMessages from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"es2alHistoryMessages"] != NULL) {
        [self hideActivityIndicator];
        es2alHistoryMessages = [defaults objectForKey:@"es2alHistoryMessages"];
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

- (void)es2alWebService:(Es2alWebService *)es2alWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    es2alHistoryMessages = returnMsgs;
    // Save es2alHistoryMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[es2alHistoryMessages mutableCopy] forKey:@"es2alHistoryMessages"];
    [defaults synchronize];
    [self sortAndLoadHistoryList];
}

- (void)sortAndLoadHistoryList {
    // Sort es2alHistoryMessages accordign to date (descendingly)
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"publish_date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateSort];
    es2alHistoryMessages = [NSMutableArray arrayWithArray:[es2alHistoryMessages sortedArrayUsingDescriptors:sortDescriptors]];
    // Load es2alHistoryList
    int index = 0;
    for (__unused NSDictionary *tempDict in es2alHistoryMessages) {
        NSMutableDictionary *tempMutableDict = [[NSMutableDictionary alloc] init];
        [tempMutableDict setObject:[[es2alHistoryMessages objectAtIndex:index] objectForKey:@"title"] forKey:@"title"];
        [tempMutableDict setObject:[[es2alHistoryMessages objectAtIndex:index] objectForKey:@"publish_date"] forKey:@"publish_date"];
        [es2alHistoryList addObject:tempMutableDict];
        index ++;
    }
    // Update View
    [es2alHistoryTable reloadData];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return [es2alHistoryList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//[es2alHistoryList count];
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
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@\n%@\t\t\t\t\t\t\t\t",[[es2alHistoryList objectAtIndex:indexPath.section] objectForKey:@"title"],[[es2alHistoryList objectAtIndex:indexPath.section] objectForKey:@"publish_date"]]];
    
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
    selectedTitle = [[es2alHistoryList objectAtIndex:indexPath.section] objectForKey:@"title"];
    
    // Extract MsgIndex from Title
    DateIndexObject *dateIndexObject = [[DateIndexObject alloc] init];
    int todayMsgIndex = [dateIndexObject extractTitleIndexFromMessages:es2alHistoryMessages andTitle:selectedTitle];
    [self.es2alHistoryDelegate es2alHistoryViewController:self setMessage:[[es2alHistoryMessages objectAtIndex:todayMsgIndex] mutableCopy]];
    [self dismissEs2alHistoryView:nil];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissEs2alHistoryView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


