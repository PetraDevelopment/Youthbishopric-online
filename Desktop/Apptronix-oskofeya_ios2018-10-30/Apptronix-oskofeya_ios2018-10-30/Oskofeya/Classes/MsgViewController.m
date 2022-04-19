#import "MsgViewController.h"

#define MEDIA_TAG 777

@implementation MsgViewController

@synthesize msgIndexPathRow;
@synthesize msgTitleStr;
@synthesize msgSubjectStr;
@synthesize msgMedia;

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
}

- (void)setupView {
    // Set msgTitleLabel
    msgTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:(fontSize + 3)];
    msgTitleLabel.adjustsFontSizeToFitWidth = YES;
    msgTitleLabel.text = msgTitleStr;
    // Set the msgTableView
    msgTableView.backgroundColor = [UIColor clearColor];
    msgTableView.separatorColor = [UIColor whiteColor];
    msgTableView.allowsSelection = NO;
}

- (void)updateView {
    // Set fontSize
    fontSize = 17.0;
    [self updateTitleAndTable];
}

- (void)updateTitleAndTable {
    // Update msgTitleLabel
    msgTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:(fontSize + 3)];
    msgTitleLabel.text = msgTitleStr;
    // Update the msgTableView
    [msgTableView reloadData];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowsCount = 1;
    if (![msgMedia isEqual:[NSNull null]]) {
        rowsCount += 1;
    }
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row == 0) && msgSubjectStr) {
        NSAttributedString *bodyText = [[NSAttributedString alloc] initWithString:msgSubjectStr attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)]}];
        CGRect bodyTextRect = [bodyText boundingRectWithSize:(CGSize){msgTableView.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize bodyTextSize = bodyTextRect.size;
        CGFloat rowHeight = bodyTextSize.height;
        if (rowHeight <= 45.0) { // One line
            rowHeight = 45.0;
        }
        return rowHeight;
    } else {
        // Return the Image Height
        return ([[UIImage imageNamed:msgMedia] size].height * 2);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell.contentView viewWithTag:MEDIA_TAG] removeFromSuperview];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        cell.textLabel.text = msgSubjectStr;
    } else {
        UIImageView *msgViewMedia = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ([[UIImage imageNamed:msgMedia] size].width * 2), ([[UIImage imageNamed:msgMedia] size].height * 2))];
        msgViewMedia.image = [UIImage imageNamed:msgMedia];
        msgViewMedia.center = CGPointMake(cell.contentView.bounds.size.width/2,msgViewMedia.center.y);
        cell.textLabel.text = nil;
        msgViewMedia.tag = MEDIA_TAG;
        [cell.contentView addSubview:msgViewMedia];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - Font Size Related Methods

- (IBAction)increaseFontSize {
    if(fontSize < 30)
    {
        fontSize = fontSize + 1;
        [self updateTitleAndTable];
    }
}

- (IBAction)decreaseFontSize {
    if(fontSize > 6)
    {
    fontSize = fontSize - 1;
    [self updateTitleAndTable];
    }
}

#pragma mark - Delete Method

- (IBAction)deleteMsg:(id)sender {
    [self.msgViewDelegate msgViewController:self deleteMsgWithIndexPathRow:msgIndexPathRow];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Dismiss Method

- (IBAction)dismissMsgView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


