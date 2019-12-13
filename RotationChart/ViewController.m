
#import "ViewController.h"
#import "RHPageControlView.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    NSTimer *_timer;
    NSArray *_photoArray;
}
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) RHPageControlView *pageControl;
@end

@implementation ViewController

- (void)dealloc
{
    if (_timer != nil && [_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _photoArray = @[@"timg-1",@"timg-2",@"timg-3",@"timg-4",@"timg-5"];
    [self creatMainView];
}

- (void)creatMainView{
    //轮播图
    CGFloat W = ScreentW;
    CGFloat H = 156*ScreentW/345;
    NSInteger nums = _photoArray.count;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, W, H)];
    scrollView.contentSize = CGSizeMake(ScreentW*(nums+2), H);
    //scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.tag = 1221;
    for (NSInteger i = 0; i < nums+2; i ++){
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i *ScreentW, 0, W, H)];
        if (i == 0 || i == nums){
            imageV.image = [UIImage imageNamed:_photoArray[nums-1]];
        }else if (i == 1 || i == nums+1){
            imageV.image = [UIImage imageNamed:_photoArray[0]];
        }else{
            imageV.image = [UIImage imageNamed:_photoArray[i-1]];
        }
        [scrollView addSubview:imageV];
    }
    
    
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentOffset = CGPointMake(ScreentW, 0);
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewClick)];
    [scrollView addGestureRecognizer:tap];
    
    if (nums>1) {
        scrollView.scrollEnabled = YES;
        RHPageControlView *pageControl = [[RHPageControlView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame) - 20, W, 20)];
        pageControl.numberOfPage = nums;
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageControl.backgroundColor = [UIColor clearColor];
        pageControl.currentPage = 0;
        _pageControl = pageControl;
        [self.view addSubview:pageControl];
        
        //开启定时器
        if (_timer != nil && [_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
        _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }else{
        scrollView.scrollEnabled = NO;
    }
}

//轮播图点击事件
- (void)scrollViewClick{
    NSLog(@"点击了第%ld张图",_pageControl.currentPage);
}

//定时器方法
- (void)timerGo{
    
    CGFloat W = ScreentW;
    CGFloat offX = _scrollView.contentOffset.x;
    NSInteger nums = _photoArray.count;
    if (nums<1){
        return;
    }
    if (offX >= W*(nums-1) && offX < W*nums){
        _pageControl.currentPage = nums-1;
        [_scrollView setContentOffset:CGPointMake(W *nums, 0) animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        });
    }else if (offX >= W * nums && offX < W * nums+1){
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self timerGo];
    }else if (offX >= W * nums+1){
        [_scrollView setContentOffset:CGPointMake(W, 0) animated:NO];
        [self timerGo];
    }else{
        _pageControl.currentPage = offX/W;
        [_scrollView setContentOffset:CGPointMake(W * (_pageControl.currentPage + 1), 0) animated:YES];
    }
    
}
#pragma mark - ScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.tag == 1221){
        NSInteger nums = _photoArray.count;
        CGFloat W = ScreentW;
        if (scrollView.contentOffset.x < W){
            [scrollView setContentOffset:CGPointMake(W *nums, 0) animated:NO];
        }else if (scrollView.contentOffset.x >= W *(nums+1)){
            [scrollView setContentOffset:CGPointMake(W, 0) animated:NO];
        }
        _pageControl.currentPage = scrollView.contentOffset.x/W-1;
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 1221){
        
        NSInteger nums = _photoArray.count;
        CGFloat W = ScreentW;
        if (scrollView.contentOffset.x < W){
            [scrollView setContentOffset:CGPointMake(W *nums, 0) animated:NO];
        }else if (scrollView.contentOffset.x >= W*(nums+1)){
            [scrollView setContentOffset:CGPointMake(W, 0) animated:NO];
        }
        _pageControl.currentPage = scrollView.contentOffset.x/W-1;
        _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
@end
