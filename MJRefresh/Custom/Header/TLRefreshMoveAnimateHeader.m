#import "TLRefreshMoveAnimateHeader.h"

#define GifviewX -100

@interface TLRefreshMoveAnimateHeader ()
{
    __unsafe_unretained UIImageView *_gifView;
    BOOL _isFirstLoad;
}
@end

@implementation TLRefreshMoveAnimateHeader

#pragma mark - 懒加载

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isFirstLoad = YES;
    }
    return self;
}

- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [gifView setFrame:CGRectMake(GifviewX, 0, self.mj_w, self.mj_h)];
        [self addSubview:_gifView = gifView];
        _gifView.animationImages = self.gifImages;
    }
    return _gifView;
}

#pragma mark - 动画相关
/** 不加此方法 下拉至刷新临界点 这个过程没有动画 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    //拉动就执行动画
    CGFloat offsetY = self.scrollView.mj_offsetY;
    CGFloat happenOffsetY = -self.scrollViewOriginalInset.top;
    
    if (offsetY < happenOffsetY)
    {
        //设置动画播放时间
        if (_isFirstLoad)//第一次加载动画
        {
            [self.gifView setHidden:NO];
            [self.gifView setAnimationImages:self.gifView.animationImages];
            //设置动画播放次数
            [self.gifView setAnimationRepeatCount:HUGE_VALF];
            //设置动画播放时间
            [self.gifView setAnimationDuration:self.gifView.animationImages.count*0.095];
            //开始动画
            [self.gifView startAnimating];
            
            [UIView animateWithDuration:.35 animations:^{
                [self.gifView setFrame:CGRectMake(20, self.gifView.mj_y, self.gifView.mj_w, self.gifView.mj_h)];
                
            }];
            _isFirstLoad = NO;
        }
        else
        {
            if(self.gifView.isAnimating)
            {
                return;
            }
            else
            {
                [self.gifView setHidden:NO];
                [self.gifView setAnimationImages:self.gifView.animationImages];
                //设置动画播放次数
                [self.gifView setAnimationRepeatCount:HUGE_VALF];
                //设置动画播放时间
                [self.gifView setAnimationDuration:self.gifView.animationImages.count*0.095];
                //开始动画
                [self.gifView startAnimating];
                
                [UIView animateWithDuration:.35 animations:^{
                    [self.gifView setFrame:CGRectMake(20, self.gifView.mj_y, self.gifView.mj_w, self.gifView.mj_h)];
                    
                }];
            }
        }
    }
    else if (offsetY >= happenOffsetY)
    {
        [self.gifView stopAnimating];
        [self.gifView setHidden:YES];
        [self.gifView removeFromSuperview];
        //重新创建,避免设置原来视图到起始位置时出现的闪烁现象
        UIImageView *gifView = [[UIImageView alloc] init];
        [gifView setFrame:CGRectMake(GifviewX, 0, self.mj_w, self.mj_h)];
        [self addSubview:_gifView = gifView];
//        if(_idleImages == nil)
//        {
//            _idleImages = [NSMutableArray array];
//            for (NSUInteger i = 1; i <= 4; i++) {
//                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
//                [_idleImages addObject:image];
//            }
//        }
        _gifView.animationImages = self.gifImages;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (state == MJRefreshStateIdle)
    {
        if (self.gifView.isAnimating)
        {
            return;
        }
        else
        {
            [self.gifView stopAnimating];
            [self.gifView setHidden:YES];
            [self.gifView setFrame:CGRectMake(GifviewX, self.gifView.mj_y, self.gifView.mj_w, self.gifView.mj_h)];
        }
    }
}

/** 数据加载完成后执行该动画 */
- (void)performTaskWithLoadingData
{
    [super performTaskWithLoadingData];
    
    [UIView animateWithDuration:.35 animations:^{
    [self.gifView setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, self.gifView.mj_y, self.gifView.mj_w, self.gifView.mj_h)];
    }];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    
    [self.gifView setFrame:CGRectMake(GifviewX, 0, self.mj_w, self.mj_h)];
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden)
    {
        self.gifView.contentMode = UIViewContentModeCenter;
    }
    else
    {
        self.gifView.contentMode = UIViewContentModeRight;
        self.gifView.mj_w = self.mj_w * 0.5 - 90;
    }
}
