#import "AgpPrayerChildViewControlle.h"

@implementation AgpPrayerChildViewControlle

@synthesize pageIndex;
@synthesize displayedPrayer;
@synthesize fontSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"AgpChild View", @"AgpChild View");
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
}

- (void)setupView {
    // Set the agpeyaTableView
    agpeyaTableView.backgroundColor = [UIColor clearColor];
    agpeyaTableView.separatorColor = [UIColor whiteColor];
    agpeyaTableView.allowsSelection = NO;
}

- (void)updateView {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 0];
    [agpeyaTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [agpeyaTableView reloadData];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect sectionHeaderRect = CGRectMake(20, 0, 100, 0);
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:sectionHeaderRect];
    sectionHeader.text = [displayedPrayer objectForKey:@"title"];
    sectionHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:(fontSize + 3)];
    sectionHeader.adjustsFontSizeToFitWidth = YES;
    sectionHeader.textColor = [UIColor darkTextColor];
    sectionHeader.textAlignment = NSTextAlignmentRight;
    sectionHeader.numberOfLines = 0;
    [sectionHeader setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:240.0/255.0f blue:241.0/255.0f alpha:1.0]];
    return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    cell.textLabel.text = [displayedPrayer objectForKey:@"body"];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


@end


