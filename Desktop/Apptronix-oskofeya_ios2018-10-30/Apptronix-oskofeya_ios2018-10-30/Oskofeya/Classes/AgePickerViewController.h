#import <UIKit/UIKit.h>

@interface AgePickerViewController : UIViewController <UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *ageGroupsList;
@property (nonatomic, strong) UIPickerView *agePicker;
@property (nonatomic, strong) NSString *selectedAge;

@end


