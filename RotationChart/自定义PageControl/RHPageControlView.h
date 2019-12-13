
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ScreentW [UIScreen mainScreen].bounds.size.width
#define ScreentH [UIScreen mainScreen].bounds.size.height

@interface RHPageControlView : UIView

@property (nonatomic,assign) NSInteger numberOfPage;
@property (nonatomic,assign) NSInteger currentPage;
//@property (nonatomic,strong) UIPageControl * pageControl;
// 可以扩展两个color 一个是normal的颜色, 一个是selected的颜色. 参考系统的UIPageControl.
@property(nullable,nonatomic,strong) UIColor * pageIndicatorTintColor;
@property(nullable,nonatomic,strong) UIColor * currentPageIndicatorTintColor;

@end

NS_ASSUME_NONNULL_END
