#import "E3rafHistoryViewController.h"


@implementation E3rafHistoryViewController

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
    // Initialize e3rafWebService
    e3rafWebService = [[E3rafWebService alloc] init];
    [e3rafWebService setE3rafWsDelegate:self];
    // Initialize e3rafHistoryList & e3rafHistorySetOfMessages
    e3rafHistorySet = [[NSMutableOrderedSet alloc] initWithObjects:nil];
    e3rafHistorySetOfMessages = [[NSMutableArray alloc] initWithObjects:nil];
    // Get e3rafHistoryMessages
    [e3rafWebService getE3rafMessagesForPresentAndFuture:NO];
    [self setupView];
}

- (void)setupView {
    // Set the e3rafHistoryTable
    e3rafHistoryTable.backgroundColor = [UIColor clearColor];
}

#pragma mark - esma3Messages Handling Methods

- (void)e3rafWebService:(E3rafWebService *)e3rafWebService errorMessage:(NSString *)errorMsg {
    // Display Error Message
    [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
    [aiMsg setText:[NSString stringWithFormat:@"%@\nبرجاء التأكد من الاتصال بالانترنت",errorMsg]];
    aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    aiMsg.numberOfLines = 4;
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:5.0f];
}

- (void)e3rafWebService:(E3rafWebService *)e3rafWebService returnMessages:(NSMutableArray *)returnMsgs {
    [self hideActivityIndicator];
    // Sort e3rafHistoryMessages accordign to date (descendingly)
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
    // Update View
    [e3rafHistoryTable reloadData];
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

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [e3rafHistorySet count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layoutMargins =  UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = false;
    [[cell textLabel] setText:[e3rafHistorySet objectAtIndex:indexPath.section]];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.backgroundColor = [UIColor clearColor];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.e3rafHistoryDelegate e3rafHistoryViewController:self setE3rafMessages:[e3rafHistorySetOfMessages objectAtIndex:indexPath.section]];
    [self dismissE3rafHistoryView:nil];
}

#pragma mark - Dismiss Methods

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

- (IBAction)dismissE3rafHistoryView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


