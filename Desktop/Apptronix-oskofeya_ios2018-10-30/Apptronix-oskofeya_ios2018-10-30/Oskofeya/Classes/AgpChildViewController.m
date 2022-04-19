#import "AgpChildViewController.h"

#define MEDIA_TAG 777

@implementation AgpChildViewController

@synthesize pageIndex;
@synthesize displayedPrayer;
@synthesize showTableView;
@synthesize fontSize;
@synthesize e7fazMedia;

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
    if (showTableView) {
        agpeyaTableView.hidden = NO;
    } else {
        agpeyaTableView.hidden = YES;
    }
    // Load mediaData
    if (displayedPrayer != nil) {
        if ([displayedPrayer objectForKey:@"image"] && (![[displayedPrayer objectForKey:@"image"] isEqualToString:@""])) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                mediaData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[displayedPrayer objectForKey:@"image"]]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [agpeyaTableView reloadData];
                });
            });
        }
    }
}

- (void)updateView {
    // Scroll to top of view
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 0];
    [agpeyaTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [agpeyaTableView reloadData];
    // Load new Audio Track
    [self.agpChildDelegate agpChildViewController:self loadAudioTrackWithURL:[displayedPrayer objectForKey:@"url"]];
    // Check if it's a Goto Page
    if ([displayedPrayer objectForKey:@"goto"]) {
        agpeyaTableView.hidden = YES;
        gotoButton.hidden = NO;
        [self.agpChildDelegate agpChildViewController:self gotoPageViewModification:[displayedPrayer objectForKey:@"goto"] andSetPageIndex:pageIndex];
    } else {
        gotoButton.hidden = YES;
        [self.agpChildDelegate agpChildViewControllerResetViewModification:self];
    }
}

#pragma mark - gotoView Related Methods

- (IBAction)gotoView {
    [self.agpChildDelegate agpChildViewController:self gotoView:[displayedPrayer objectForKey:@"goto"]];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect sectionHeaderRect = CGRectMake(0, 0, 0, 0);
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:sectionHeaderRect];
    sectionHeader.text = [displayedPrayer objectForKey:@"title"];
    sectionHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:(fontSize + 3)];
    sectionHeader.adjustsFontSizeToFitWidth = YES;
    sectionHeader.textColor = [UIColor darkTextColor];
    sectionHeader.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    if ([displayedPrayer objectForKey:@"image"]) {
        sectionHeader.textAlignment = NSTextAlignmentCenter;
    } else {
        sectionHeader.textAlignment = NSTextAlignmentRight;
    }
    return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowsCount = 1;
    if (displayedPrayer != nil) {
        if ([displayedPrayer objectForKey:@"image"] && (![[displayedPrayer objectForKey:@"image"] isEqualToString:@""])) {
            rowsCount += 1;
        }
    }
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (displayedPrayer != nil) {
        if (([displayedPrayer objectForKey:@"image"] && (![[displayedPrayer objectForKey:@"image"] isEqualToString:@""])) && (indexPath.row == 0)) {
            // Image
            float mediaHeight = 270.0f * (([[UIImage imageWithData:mediaData] size].height * 2) / ([[UIImage imageWithData:mediaData] size].width * 2));
            if (mediaData) {
                return (mediaHeight + 20.0);
            } else {
                return 0;
            }
        } else {
            if ([displayedPrayer objectForKey:@"body"] && (![[displayedPrayer objectForKey:@"body"] isEqualToString:@""])) {
                // Body
                NSAttributedString *bodyText = [[NSAttributedString alloc] initWithString:[displayedPrayer objectForKey:@"body"] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)]}];
                CGRect bodyTextRect = [bodyText boundingRectWithSize:(CGSize){agpeyaTableView.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                CGSize bodyTextSize = bodyTextRect.size;
                CGFloat rowHeight = bodyTextSize.height;
                if (rowHeight <= 45.0) { // One line
                    rowHeight = 45.0;
                }
                return rowHeight;
            } else {
                return 0;
            }
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell.contentView viewWithTag:MEDIA_TAG] removeFromSuperview];
    if ([displayedPrayer objectForKey:@"image"]) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor blackColor];
    if (([displayedPrayer objectForKey:@"image"] && (![[displayedPrayer objectForKey:@"image"] isEqualToString:@""])) && (indexPath.row == 0)) {
        // Image
        float mediaHeight = 270.0f * (([[UIImage imageWithData:mediaData] size].height * 2) / ([[UIImage imageWithData:mediaData] size].width * 2));
        UIImageView *hymnImageView;
        if (mediaData) {
            hymnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 270.0f, mediaHeight)];
            hymnImageView.image = [UIImage imageWithData:mediaData];
        }
        hymnImageView.center = CGPointMake((cell.contentView.bounds.size.width / 2), hymnImageView.center.y + 20);
        cell.textLabel.text = nil;
        hymnImageView.tag = MEDIA_TAG;
        [cell.contentView addSubview:hymnImageView];
    } else {
        // Body
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        cell.textLabel.text = [displayedPrayer objectForKey:@"body"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


