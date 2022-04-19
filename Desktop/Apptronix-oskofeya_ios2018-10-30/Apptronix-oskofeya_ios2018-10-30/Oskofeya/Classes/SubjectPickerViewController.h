#import <UIKit/UIKit.h>

@interface SubjectPickerViewController : UIViewController <UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *subjectsList;
@property (nonatomic, strong) UIPickerView *subjectsPicker;
@property (nonatomic, strong) NSString *chosenSubject;

@end


