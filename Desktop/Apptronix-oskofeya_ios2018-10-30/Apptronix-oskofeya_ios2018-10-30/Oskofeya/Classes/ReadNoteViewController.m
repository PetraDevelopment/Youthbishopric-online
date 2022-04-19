#import "ReadNoteViewController.h"

#define MEDIA_TAG 777

@implementation ReadNoteViewController

@synthesize noteTitleStr;
@synthesize noteBodyStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
        self.title = NSLocalizedString(@"قراءة تأمل", @"قراءة تأمل");
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
    // Set the noteTableView
    noteTableView.backgroundColor = [UIColor clearColor];
    noteTableView.separatorColor = [UIColor whiteColor];
    noteTableView.allowsSelection = NO;
}

- (void)updateView {
    // Set fontSize
    fontSize = 17.0;
    [self updateTitleAndTable];
}

- (void)updateTitleAndTable {
    // Update the noteTableView
    [noteTableView reloadData];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        NSAttributedString *bodyText = [[NSAttributedString alloc] initWithString:noteBodyStr attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:(fontSize + 2)]}];
        CGRect bodyTextRect = [bodyText boundingRectWithSize:(CGSize){noteTableView.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize bodyTextSize = bodyTextRect.size;
        CGFloat rowHeight = bodyTextSize.height;
        if (rowHeight <= 45.0) { // One line
            rowHeight = 45.0;
        }
        return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    cell.textLabel.text = noteBodyStr;
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

#pragma mark - Dismiss Method

- (IBAction)dismissReadNoteView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


