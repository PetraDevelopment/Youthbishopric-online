#import "AgePickerViewController.h"

@implementation AgePickerViewController

@synthesize ageGroupsList;
@synthesize agePicker;
@synthesize selectedAge;

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Age Picker Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [ageGroupsList count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 65.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 220.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *ageGroupsLabel;
    ageGroupsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,180,45) ];
    ageGroupsLabel.backgroundColor = [UIColor whiteColor]; // clearColor
    ageGroupsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    ageGroupsLabel.textColor = [UIColor blackColor]; 

    [ageGroupsLabel setTextAlignment:NSTextAlignmentCenter];
    ageGroupsLabel.text = [ageGroupsList objectAtIndex:row];
    return ageGroupsLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedAge = [ageGroupsList objectAtIndex:row];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


