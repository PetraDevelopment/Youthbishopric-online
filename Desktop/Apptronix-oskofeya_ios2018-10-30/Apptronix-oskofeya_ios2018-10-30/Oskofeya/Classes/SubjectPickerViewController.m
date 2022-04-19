#import "SubjectPickerViewController.h"

@implementation SubjectPickerViewController

@synthesize subjectsList;
@synthesize subjectsPicker;
@synthesize chosenSubject;

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Subjects Picker Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [subjectsList count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 65.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 220.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *subjectsLabel;
    subjectsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,180,45)];
    subjectsLabel.backgroundColor = [UIColor whiteColor]; 
    subjectsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    subjectsLabel.textColor = [UIColor blackColor];
    [subjectsLabel setTextAlignment:NSTextAlignmentCenter];
    subjectsLabel.text = [subjectsList objectAtIndex:row];
    return subjectsLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    chosenSubject = [subjectsList objectAtIndex:row];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


