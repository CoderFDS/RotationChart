

#import "RHPageControlView.h"
#import "UIView+Layout.h"

@interface CustomPageItem : UIView

@end

@implementation CustomPageItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end

@interface RHPageControlView()

@property (nonatomic, strong) NSMutableArray <CustomPageItem *> *pageItems;

@end

@implementation RHPageControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    // 根据numberOfPage算出pageControl的size ..
    return CGSizeMake((self.frame.size.width-self.numberOfPage*10-5)/2, 20.f);
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (_currentPage != currentPage)
    {
        _currentPage = currentPage;
        
        [self.pageItems makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:self.pageIndicatorTintColor];
        [self.pageItems objectAtIndex:currentPage].backgroundColor = self.currentPageIndicatorTintColor;
        
        // Scroll animation ..
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)setNumberOfPage:(NSInteger)numberOfPage
{
    _numberOfPage = numberOfPage;
    
    //这里可以优化, 考虑用复用.
    [self.pageItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.pageItems removeAllObjects];
    
    for (NSInteger i = 0; i < numberOfPage; i++)
    {
        CustomPageItem * item = [[CustomPageItem alloc] init];
        item.backgroundColor = self.pageIndicatorTintColor;
        [self addSubview:item];
        [self.pageItems addObject:item];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    [self.pageItems makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:pageIndicatorTintColor];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;

    if (self.pageItems.count>0) {
        [self.pageItems objectAtIndex:self.currentPage].backgroundColor = currentPageIndicatorTintColor;
    }
}

- (NSMutableArray<CustomPageItem *> *)pageItems
{
    if (!_pageItems)
    {
        _pageItems = [NSMutableArray array];
    }
    return _pageItems;
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 写一下布局 ..
    CGFloat space = 10.f; // 每个点之间的间隔.
    CGSize itemSize = CGSizeMake(10.f, 3.f);
    
    CGFloat selectedMoreLen = 5.f; // 选中的比默认长
    CGFloat allLen = (self.pageItems.count * itemSize.width + (self.pageItems.count - 1) * space + selectedMoreLen);
    CGFloat startX = (self.frame.size.width - allLen) / 2.f;
    CGFloat centerY = self.frame.size.height * 0.5;
    
    for (NSInteger i = 0; i < self.pageItems.count; i++)
    {
        CustomPageItem * item = [self.pageItems objectAtIndex:i];
        item.size = itemSize;
        if (i == self.currentPage)
        {
            item.width += selectedMoreLen;
        }
        item.left = startX;
        item.centerY = centerY;
        startX = item.right + space;
    }
}

@end
