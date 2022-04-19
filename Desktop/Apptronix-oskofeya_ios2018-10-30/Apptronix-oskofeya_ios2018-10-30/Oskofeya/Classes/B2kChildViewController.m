#import "B2kChildViewController.h"

#define MEDIA_TAG 777

@implementation B2kChildViewController

@synthesize pageIndex;
@synthesize displayedMessage;
@synthesize todayMsgIndex;
@synthesize showTableView;
@synthesize fontSize;
@synthesize e7fazMedia;

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
    [self setupView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // Scroll to top of view
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 0];
    [be2engylakTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [be2engylakTableView reloadData];
}

- (void)setupView {
    // Set the be2engylakTableView
    be2engylakTableView.backgroundColor = [UIColor clearColor];
    be2engylakTableView.separatorColor = [UIColor whiteColor];
    be2engylakTableView.allowsSelection = NO;
    if (showTableView) {
        be2engylakTableView.hidden = NO;
    } else {
        be2engylakTableView.hidden = YES;
    }
    // Load mediaData
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        mediaData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/%@",[displayedMessage objectForKey:@"ehfaz_image"]]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [be2engylakTableView reloadData];
        });
    });
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-1, -1, self.view.bounds.size.width, 25.0f)];
    [view setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:240.0/255.0f blue:241.0/255.0f alpha:1.0]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 70, 5, 70, 70)];
    
    imageView.image = [UIImage imageNamed:@"beengylak.png"];
    [view addSubview:imageView];
    
    UILabel *Headertxt = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 20)];
    Headertxt.text = @"إشبع بإنجيلك";
    Headertxt.font = [UIFont fontWithName:@"Helvetica-Bold" size:(17)];
    Headertxt.adjustsFontSizeToFitWidth = YES;
    Headertxt.textColor = [UIColor redColor];
    Headertxt.textAlignment = NSTextAlignmentRight;
    [view addSubview:Headertxt];
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 150,50)];
    sectionHeader.text = [displayedMessage objectForKey:@"title"];
    sectionHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:(15)];
    sectionHeader.adjustsFontSizeToFitWidth = YES;
    sectionHeader.textAlignment = NSTextAlignmentRight;
    sectionHeader.textColor = [UIColor colorWithRed:47.0/255.0f green:83.0/255.0f blue:90.0/255.0f alpha:1.0];
    switch (pageIndex) {
        case 0:
            sectionHeader.text = [displayedMessage objectForKey:@"header_subject"];
            break;
        case 1:
            sectionHeader.text = [displayedMessage objectForKey:@"content_subject"];
            break;
        case 2:
            sectionHeader.text = [displayedMessage objectForKey:@"footer_subject"];
            break;
        case 3:
            //sectionHeader.text = [displayedMessage objectForKey:@"ehfaz_title"];
            sectionHeader.text =  @"هاتحفظ اية";
            sectionHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size : 15];
            sectionHeader.adjustsFontSizeToFitWidth = YES;
            sectionHeader.numberOfLines = 0;
            sectionHeader.lineBreakMode = NSLineBreakByTruncatingTail;
            break;
        default:
            NSLog(@"Error !");
            break;
    }

    
    [view addSubview:sectionHeader];
    
    
    return view;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowsCount = 1;
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight;
    switch (pageIndex) {
        case 0:
            rowHeight = [[displayedMessage objectForKey:@"header_body"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)] constrainedToSize:CGSizeMake(be2engylakTableView.frame.size.width,1920.0) lineBreakMode:NSLineBreakByWordWrapping].height;
            break;
        case 1:
            rowHeight = [[displayedMessage objectForKey:@"content_body"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)] constrainedToSize:CGSizeMake(be2engylakTableView.frame.size.width,1920.0) lineBreakMode:NSLineBreakByWordWrapping].height;
            break;
        case 2:
            rowHeight = [[displayedMessage objectForKey:@"footer_body"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)] constrainedToSize:CGSizeMake(be2engylakTableView.frame.size.width,1920.0) lineBreakMode:NSLineBreakByWordWrapping].height;
            break;
        case 3:
            // Image
            if (mediaData) {
                float mediaHeight = 270.0f * (([[UIImage imageWithData:mediaData] size].height * 2) / ([[UIImage imageWithData:mediaData] size].width * 2));
                rowHeight =  mediaHeight + 20.0;
            } else {
                rowHeight = 0;
            }
            break;
        default:
            NSLog(@"Error !");
            break;
    }
    if (rowHeight <= 30.0) { // One line
        rowHeight = 30.0;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell.contentView viewWithTag:MEDIA_TAG] removeFromSuperview];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor blackColor];
    switch (pageIndex) {
        case 0:
            cell.textLabel.text = [displayedMessage objectForKey:@"header_body"];
            break;
        case 1:
            cell.textLabel.text = [displayedMessage objectForKey:@"content_body"];
            break;
        case 2:
            cell.textLabel.text = [displayedMessage objectForKey:@"footer_body"];
            break;
        case 3:
             cell.textLabel.text = nil;
            if (mediaData) {
                float mediaHeight = 270.0f * (([[UIImage imageWithData:mediaData] size].height * 2) / ([[UIImage imageWithData:mediaData] size].width * 2));
                e7fazMedia = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 50, 270.0f, mediaHeight + 50)];
                e7fazMedia.image = [UIImage imageWithData:mediaData];
            }
            /*e7fazMedia.center = CGPointMake(((cell.contentView.bounds.size.width / 2)), e7fazMedia.center.y + 30);*/
           
            e7fazMedia.tag = MEDIA_TAG;
            
            UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,260.0f,50)];
            sectionHeader.text = [displayedMessage objectForKey:@"ehfaz_title"];
            sectionHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:(15)];
            sectionHeader.adjustsFontSizeToFitWidth = YES;
            sectionHeader.numberOfLines = 0;
            sectionHeader.lineBreakMode = NSLineBreakByTruncatingTail;
            sectionHeader.textAlignment = NSTextAlignmentRight;
             [cell.contentView addSubview:sectionHeader];
            [cell.contentView addSubview:e7fazMedia];
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    // Add LongPress Handling
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [cell addGestureRecognizer:longPress];
    return cell;
}

#pragma mark - CFW Related Methods

- (void)handleLongPress:(UIGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        be2engylakTableView.allowsSelection = YES;
        // Extract Selected Index
        CGPoint pressLocation = [longPress locationInView:be2engylakTableView];
        NSIndexPath *selectedIndex = [be2engylakTableView indexPathForRowAtPoint:pressLocation];
        [be2engylakTableView selectRowAtIndexPath:selectedIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self performSelector:@selector(deselectRow:) withObject:selectedIndex afterDelay:0.5f];
        // Show CFW Buttons
        [self.b2kChildDelegate b2kChildViewController:self hideCFW_Buttons:NO withPageIndex:pageIndex];
    }
}

- (void)deselectRow:(NSIndexPath *)selectedIndex {
    [be2engylakTableView deselectRowAtIndexPath:selectedIndex animated:YES];
    be2engylakTableView.allowsSelection = NO;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


