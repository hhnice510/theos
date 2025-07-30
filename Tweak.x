#import <UIKit/UIKit.h>

%hook UIViewController

- (void)viewDidLoad {
    %orig;
    NSLog(@"[ego] UIViewController viewDidLoad: %@", self);
}

%end
