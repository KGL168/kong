//
//  TGScrollView.m
//

#import "TGScrollView.h"
#import "UIView+Layout.h"

#define TGScroll_Debug 0

#define kTGScrollView_Subview_DefaultGap 10.f

typedef NS_ENUM(NSInteger, TGScrollDirection)
{
    TGScrollDirectionNone,
    TGScrollDirectionRight,
    TGScrollDirectionLeft,
    
    // temp only horizontal
    //TGScrollDirectionUp,
    //TGScrollDirectionDown,
};

#pragma mark - TGScrollViewWrapper

@interface TGScrollViewWrapper: NSObject

@property (nonatomic, strong) UIView      *v;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGPoint     vcenter;

@end

@implementation TGScrollViewWrapper

@end

#pragma mark - TGScrollView

@interface TGScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) TGScrollViewStyle style;

@property (nonatomic, assign) TGScrollDirection scrollDirection;

@property (nonatomic, assign, readwrite) NSInteger screenPageIndex;

@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, assign) NSUInteger currentLeftPageIndex;
@property (nonatomic, assign) NSUInteger currentRightPageIndex;

@property (nonatomic, assign) NSInteger firstScreenObjectIndex;

@property (nonatomic, assign) NSInteger lastScreenObjectIndex;

@property (nonatomic, strong) NSMutableArray *wrappers;

@property (nonatomic, assign) CGFloat toAddPositionX;

@property (nonatomic, strong) NSCache *contentViewCache;

@property (nonatomic, assign) CGFloat lastContentOffset;

@property (nonatomic, assign) NSUInteger rowCount;

@property (nonatomic, assign) NSUInteger rowPageCount;

@property (nonatomic, assign) NSUInteger pageCount;

@property (nonatomic, assign) BOOL screenInitial;

@property (nonatomic, assign) CGFloat contentSubviewHalfGap;

// temp
@property (nonatomic, assign) NSUInteger loopTime;

@end

@implementation TGScrollView

/**
 *  do init
 *
 *  @param dataSource dataSource delegate
 */
- (void)setDataSource: (id<TGScrollViewDataSource>)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = dataSource;
        [self p_initPageInfo];
    }
}

- (void)setEnableLoop: (BOOL)enableLoop
{
    if (_style == TGScrollViewStylePage)
    {
        _enableLoop = enableLoop;
    }
}

- (instancetype)initWithFrame: (CGRect)frame style: (TGScrollViewStyle)style
{
    self = [super initWithFrame: frame];
    if (self)
    {
        _style = style;
        [self initialer];
    }
    return self;
}

- (void)initialer
{
    _wrappers   = [@[] mutableCopy];
    
    _screenInitial = NO;
    _contentSubviewGap = kTGScrollView_Subview_DefaultGap;
    
    _contentViewCache = [NSCache new];
    _scrollDirection = TGScrollDirectionNone;
    
    _firstScreenObjectIndex = 0;
    _lastScreenObjectIndex  = 0;
    
    _screenPageIndex = 0;
    
    if (_style == TGScrollViewStylePage)
    {
        [self setPagingEnabled: YES];
    }
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    
    if (self.style == TGScrollViewStylePage)
    {
        if (self.enableLoop)
        {
            self.currentPageIndex      = 0;
            self.currentLeftPageIndex  = 2;
            self.currentRightPageIndex = 1;
        }
        self.screenPageIndex = 0;
        [self p_setContentOffset: CGPointMake(self.enableLoop? self.width: 0.f, 0.f) animated: NO];
        [self p_setContentSize: CGSizeMake(self.width * (self.enableLoop? 3: self.pageCount), self.height)];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self p_updateVisibleViewsNow];
}

- (void)setLeftMargin: (CGFloat)leftMargin
{
    _toAddPositionX = leftMargin;
    _leftMargin = leftMargin;
    if (_style != TGScrollViewStylePage)
    {
        [self p_setContentSize: CGSizeMake(_toAddPositionX, self.height)];
    }
}

- (void)setRightMargin: (CGFloat)rightMargin
{
    _rightMargin = rightMargin;
}

#pragma mark - Public Msg

- (void)nextPage
{
    if (self.contentOffset.x < self.contentSize.width - self.width)
    {
        [self setContentOffset: CGPointMake(self.contentOffset.x + self.width, 0.0) animated: YES];
    }
}

- (void)previousPage
{
    if (self.contentOffset.x > 0.0)
    {
        [self setContentOffset: CGPointMake(self.contentOffset.x - self.width, 0.0) animated: YES];
    }
}

- (void)reload
{
    [self p_reset];
    [self setNeedsLayout];
}

- (UIView *)dequeueReusableViewWithIndex: (NSUInteger)viewIndex
{
    if (viewIndex >= self.rowCount)
    {
        return nil;
    }
    UIView *loadView = [self.contentViewCache objectForKey: [NSString stringWithFormat: @"%@", @(viewIndex)]];
    return loadView;
}

#pragma mark - Private Msg

- (void)p_reset
{
    for (TGScrollViewWrapper *wrapper in self.wrappers)
    {
        wrapper.vcenter = CGPointZero;
        [wrapper.v removeFromSuperview];
        wrapper.v = nil;
    }
    self.wrappers = [@[] mutableCopy];
    [self p_initPageInfo];

    [self.contentViewCache removeAllObjects];
    
    self.lastScreenObjectIndex  = 0;
    self.firstScreenObjectIndex = 0;
    
    [self p_setContentSize:   CGSizeZero];
    [self p_setContentOffset: CGPointZero animated: NO];

    self.scrollDirection = TGScrollDirectionNone;
    self.screenInitial = NO;
    
    if (self.style == TGScrollViewStyleNormal)
    {
        self.toAddPositionX = self.leftMargin;
        [self p_setContentSize: CGSizeMake(_toAddPositionX, self.height)];
    }
    else if (self.style == TGScrollViewStylePage)
    {
        if (self.enableLoop)
        {
            self.currentPageIndex      = 0;
            self.currentLeftPageIndex  = 2;
            self.currentRightPageIndex = 1;
        }
        self.screenPageIndex = 0;
        [self p_setContentOffset: CGPointMake(self.enableLoop? self.width: 0.f, 0.f) animated: NO];
        [self p_setContentSize: CGSizeMake(self.width * (self.enableLoop? 3: self.pageCount), self.height)];
    }
}

- (void)p_initPageInfo
{
    if ([self.dataSource respondsToSelector: @selector(numberOfRowsInTGScrollView:)])
    {
        self.rowCount = [self.dataSource numberOfRowsInTGScrollView: self];
    }
    
    if (self.style == TGScrollViewStyleNormal)
    {
        self.pageCount = 1;
        self.rowPageCount = self.rowCount;
    }
    else if (self.style == TGScrollViewStylePage && [self.dataSource respondsToSelector: @selector(numberOfRowsPerPageInTGScrollView:)])
    {
        self.rowPageCount = [self.dataSource numberOfRowsPerPageInTGScrollView: self];
        self.pageCount = (self.rowPageCount + self.rowCount - 1) / self.rowPageCount;
        [self p_setContentSize: CGSizeMake(self.width * (self.enableLoop? 3: self.pageCount), self.height)];
    }
    
    for (NSUInteger i = 0; i < self.pageCount; i ++)
    {
        for (NSUInteger j = 0; j < self.rowPageCount; j ++)
        {
            TGScrollViewWrapper *scrollWrapper = [TGScrollViewWrapper new];
            [scrollWrapper setIndexPath: [NSIndexPath indexPathForRow: j inSection: i]];
            [self.wrappers addObject: scrollWrapper];
        }
    }
}

- (void)p_initialScreen
{
    if (self.screenInitial)
    {
        return;
    }
    self.screenInitial = YES;
    if (self.style == TGScrollViewStylePage)
    {
        for (NSUInteger i = 0; i < self.rowPageCount; i ++)
        {
            [self p_addViewFromIndex: i];
        }
        if (self.rowPageCount > 0)
        {
            self.lastScreenObjectIndex = self.rowPageCount - 1;
        }
    }
    else  if (self.style == TGScrollViewStyleNormal)
    {
        [self p_addViewFromIndex: 0];
        while ([self p_needLoadNextView])
        {
            [self p_addNextView];
        }
    }
}

- (BOOL)p_needUnloadPreviousView
{
    if (![self p_isVaildIndex: self.firstScreenObjectIndex])
    {
        return NO;
    }
    if (!self.enableLoop && self.firstScreenObjectIndex == self.rowCount - 1)
    {
        return NO;
    }
    TGScrollViewWrapper *scrollWrapper = self.wrappers[self.firstScreenObjectIndex];
    
    if (scrollWrapper.v.right - self.contentOffset.x < 0.f)
    {
        return YES;
    }
    return NO;
}

- (BOOL)p_needLoadNextView
{
    if (!self.wrappers.count)
    {
        return NO;
    }
    if (![self p_isVaildIndex: self.lastScreenObjectIndex])
    {
        return NO;
    }
    
    TGScrollViewWrapper *scrollWrapper = self.wrappers[self.lastScreenObjectIndex];
    
    if (self.style == TGScrollViewStyleNormal)
    {
        if (self.lastScreenObjectIndex == self.rowCount - 1)
        {
            return NO;
        }
        if (scrollWrapper.v.right - self.contentOffset.x + self.contentSubviewGap < self.width)
        {
            return YES;
        }
    }
    
    else if (self.style == TGScrollViewStylePage)
    {
        // page last one
        if (scrollWrapper.indexPath.row == self.rowPageCount - 1)
        {
            if (!self.enableLoop && self.lastScreenObjectIndex == self.rowCount - 1)
            {
                return NO;
            }
            
            if (self.enableLoop)
            {
                if (scrollWrapper.indexPath.section == self.currentRightPageIndex)
                {
                    return NO;
                }
            }
            
            if (scrollWrapper.v.right - self.contentOffset.x + self.leftMargin + self.rightMargin + self.contentSubviewHalfGap * 2 < self.width)
            {
                return YES;
            }
        }
        else
        {
            if (!self.enableLoop && self.lastScreenObjectIndex == self.rowCount - 1)
            {
                return NO;
            }
            
            if (self.enableLoop)
            {
                NSUInteger pageCount = (self.rowCount % self.rowPageCount)? (self.rowCount % self.rowPageCount): self.rowPageCount;
                NSUInteger nextPageViewCount = (self.currentRightPageIndex == self.pageCount - 1)? pageCount : self.rowPageCount;
                if (scrollWrapper.indexPath.section == self.currentRightPageIndex && scrollWrapper.indexPath.row == nextPageViewCount - 1)
                {
                    return NO;
                }
            }
            if (scrollWrapper.v.right - self.contentOffset.x + self.contentSubviewHalfGap * 2 <= self.width)
            {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)p_needLoadPreviousView
{
    if (!self.wrappers.count)
    {
        return NO;
    }
    if (![self p_isVaildIndex: self.firstScreenObjectIndex])
    {
        return NO;
    }
    TGScrollViewWrapper *scrollWrapper = self.wrappers[self.firstScreenObjectIndex];
    
    if (self.style == TGScrollViewStyleNormal)
    {
        if (self.firstScreenObjectIndex == 0)
        {
            return NO;
        }
        if (scrollWrapper.v.left - self.contentOffset.x - self.contentSubviewGap > 0.f)
        {
            return YES;
        }
    }
    else if (self.style == TGScrollViewStylePage)
    {
        if (scrollWrapper.indexPath.row == 0)
        {
            if (!self.enableLoop && self.firstScreenObjectIndex == 0)
            {
                return NO;
            }
            
            if (self.enableLoop)
            {
                if (scrollWrapper.indexPath.section == self.currentLeftPageIndex && scrollWrapper.indexPath.row == 0)
                {
                    return NO;
                }
            }
            if (scrollWrapper.v.left - self.contentOffset.x - self.contentSubviewHalfGap * 2 - self.leftMargin - self.rightMargin > 0.f)
            {
                return YES;
            }
        }
        else
        {
            if (scrollWrapper.v.left - self.contentOffset.x - self.contentSubviewHalfGap * 2 > 0.f)
            {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)p_needUnloadNextView
{
    if (!self.wrappers.count)
    {
        return NO;
    }
    if (![self p_isVaildIndex: self.lastScreenObjectIndex])
    {
        return NO;
    }
    TGScrollViewWrapper *scrollWrapper = self.wrappers[self.lastScreenObjectIndex];
    
    if (scrollWrapper.v.left - self.contentOffset.x > self.width)
    {
        return YES;
    }
    return NO;
}

- (void)p_addNextView
{
    if (self.enableLoop)
    {
        self.lastScreenObjectIndex = (++ self.lastScreenObjectIndex) % self.rowCount;
    }
    else
    {
        if (self.lastScreenObjectIndex < self.rowCount - 1)
        {
            self.lastScreenObjectIndex ++;
        }
    }
    [self p_addViewFromIndex: self.lastScreenObjectIndex];
}

- (void)p_addPreviousView
{
    self.firstScreenObjectIndex = (-- self.firstScreenObjectIndex + self.rowCount) % self.rowCount;
    [self p_addViewFromIndex: self.firstScreenObjectIndex];
}

- (void)p_removeNextView
{
    [self p_removeViewFromIndex: self.lastScreenObjectIndex];
    self.lastScreenObjectIndex = (-- self.lastScreenObjectIndex + self.rowCount) % self.rowCount;
}

- (void)p_removePreviousView
{
    [self p_removeViewFromIndex: self.firstScreenObjectIndex];
    //self.firstScreenObjectIndex = (++ self.firstScreenObjectIndex) % self.rowCount;
    if (self.enableLoop)
    {
        self.firstScreenObjectIndex = (++ self.lastScreenObjectIndex) % self.rowCount;
    }
    else
    {
        if (self.firstScreenObjectIndex < self.rowCount - 1)
        {
            self.firstScreenObjectIndex ++;
        }
    }
    
}

- (void)p_addViewFromIndex: (NSUInteger)index
{
    if (![self p_isVaildIndex: index])
    {
        return;
    }
    TGScrollViewWrapper *scrollWrapper = [self.wrappers objectAtIndex: index];
    UIView *loadView = [self.dataSource tgScrollView: self viewForRowAtIndex: index];
    loadView.left = 0.f;
    if (CGPointEqualToPoint(scrollWrapper.vcenter, CGPointZero))
    {
        if (self.style == TGScrollViewStylePage)
        {
            self.contentSubviewHalfGap = (self.width - self.leftMargin - self.rightMargin - loadView.width * self.rowPageCount) / (self.rowPageCount * 2);
            CGFloat offsetx = self.leftMargin + (scrollWrapper.indexPath.row * 2 + 1) * (self.contentSubviewHalfGap + loadView.centerX);
            
            [loadView setCenter: CGPointMake(self.width * [self p_toAddPageIndex: scrollWrapper.indexPath] + offsetx, self.height / 2.0)];
            scrollWrapper.vcenter = loadView.center;
        }
        else if (self.style == TGScrollViewStyleNormal)
        {
            loadView.left = self.toAddPositionX;
            scrollWrapper.vcenter = loadView.center;
            self.toAddPositionX += loadView.width + self.contentSubviewGap;
            
            if (index == self.rowCount - 1)
            {
                // last one
                [self p_setContentSize: CGSizeMake(self.toAddPositionX + self.rightMargin, self.height)];
            }
            else
            {
                [self p_setContentSize: CGSizeMake(self.toAddPositionX, self.height)];
            }
        }
    }
    else
    {
        loadView.center = scrollWrapper.vcenter;
    }
    [self addSubview: loadView];
    scrollWrapper.v = loadView;
}

- (void)p_removeViewFromIndex: (NSUInteger)index
{
    if (![self p_isVaildIndex: index])
    {
        return;
    }
    TGScrollViewWrapper *scrollWrapper = self.wrappers[index];
    if (scrollWrapper.v)
    {
        [self.contentViewCache setObject: scrollWrapper.v forKey: [NSString stringWithFormat: @"%@:%@", @(scrollWrapper.indexPath.section), @(scrollWrapper.indexPath.row)]];
        [scrollWrapper.v removeFromSuperview];
        scrollWrapper.v = nil;
        if (self.style == TGScrollViewStylePage)
        {
            scrollWrapper.vcenter = CGPointZero;
        }
    }
}

- (void)p_updateVisibleViewsNow
{
    if (self.scrollDirection == TGScrollDirectionNone)
    {
        [self p_initialScreen];
    }
    else if (self.scrollDirection == TGScrollDirectionLeft)
    {
        while ([self p_needLoadNextView])
        {
            [self p_addNextView];
        }
        while ([self p_needUnloadPreviousView])
        {
            [self p_removePreviousView];
        }
    }
    else if (self.scrollDirection == TGScrollDirectionRight)
    {
        while ([self p_needLoadPreviousView])
        {
            [self p_addPreviousView];
        }
        while ([self p_needUnloadNextView])
        {
            [self p_removeNextView];
        }
    }
    //[self debugSubViews];
}

- (void)p_setContentSize: (CGSize)size
{
    self.delegate = nil;
    self.contentSize = size;
    self.delegate = self;
}

- (void)p_setContentOffset: (CGPoint)offset animated: (BOOL)animated
{
    self.delegate = nil;
    [self setContentOffset: offset animated: animated];
    self.delegate = self;
}

- (BOOL)p_isVaildIndex: (NSUInteger)idx
{
    return (idx < self.rowCount);
}

- (NSUInteger)p_indexFromIndexPath: (NSIndexPath *)indexPath
{
    __block NSUInteger index = NSUIntegerMax;
    [self.wrappers enumerateObjectsUsingBlock: ^(TGScrollViewWrapper* wrapper, NSUInteger idx, BOOL *stop)
     {
         if ([wrapper.indexPath isEqual: indexPath])
         {
             index = [self.wrappers indexOfObject: wrapper];
             *stop = YES;
         }
     }];
    return index;
}


- (NSUInteger)p_toAddPageIndex: (NSIndexPath *)indexPath
{
    if (!self.enableLoop)
    {
        return indexPath.section;
    }
    if (indexPath.section == self.currentPageIndex)
    {
        return 1;
    }
    if (indexPath.section == self.currentLeftPageIndex)
    {
        return 0;
    }
    if (indexPath.section == self.currentRightPageIndex)
    {
        return 2;
    }
    return 0;
}

- (void)p_moveViewsToCenterFromIndex: (NSUInteger)idx
{
    for (TGScrollViewWrapper *wrapper in self.wrappers)
    {
        if (wrapper.indexPath.section == idx)
        {
            CGFloat offsetx = self.leftMargin + (wrapper.indexPath.row * 2 + 1) * self.contentSubviewHalfGap + wrapper.indexPath.row * wrapper.v.width;
            wrapper.v.left = offsetx + self.width;
            wrapper.vcenter = wrapper.v.center;
        }
    }
}

- (void)p_adjustViews
{
    if (self.style == TGScrollViewStylePage)
    {
        if (self.enableLoop)
        {
            BOOL changed = NO;
            if (self.contentOffset.x == 0.f)
            {
                self.currentPageIndex = (self.currentPageIndex - 1 + self.rowPageCount) % self.rowPageCount;
                changed = YES;
            }
            else if (self.contentOffset.x == self.width * 2.f)
            {
                self.currentPageIndex = (self.currentPageIndex + 1) % self.rowPageCount;
                changed = YES;
            }
            if (changed)
            {
                self.currentLeftPageIndex = (self.currentPageIndex - 1 + self.rowPageCount) % self.rowPageCount;
                self.currentRightPageIndex = (self.currentPageIndex + 1) % self.rowPageCount;
                [self p_moveViewsToCenterFromIndex: self.currentPageIndex];
                [self p_setContentOffset: CGPointMake(self.width, 0.f) animated: NO];
            }
            self.screenPageIndex = self.currentPageIndex;
        }
        else
        {
            CGFloat width = self.width;
            self.screenPageIndex = (self.contentOffset.x + (0.5f * width)) / width;
        }
    }
}

#pragma mark - touches

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event
{
    [super touchesEnded: touches withEvent: event];
    UITouch *touch = [[touches allObjects] objectAtIndex: 0];
    CGPoint touchPoint = [touch locationInView: self];
    for (NSUInteger i = self.firstScreenObjectIndex; i <= self.lastScreenObjectIndex ; i ++)
    {
        if (self.wrappers.count)
        {
            TGScrollViewWrapper *wrapper = self.wrappers[i];
            if (CGRectContainsPoint(wrapper.v.frame, touchPoint))
            {
//                if ([self.dataSource respondsToSelector: @selector(tgScrollView:didSelectRowAtIndex:)])
//                {
//                    [self.dataSource tgScrollView: self didSelectRowAtIndex: i];
//                }
                if ([self.dataSource respondsToSelector: @selector(tgScrollView:didSelectRowAtIndex:viewSelected:)])
                {
                    [self.dataSource tgScrollView: self didSelectRowAtIndex: i viewSelected: wrapper.v];
                }
                break;
            }
        }
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.dataSource && [self.dataSource respondsToSelector: @selector(tgScrollViewDidEndDragging:willDecelerate:)])
    {
        [self.dataSource tgScrollViewDidEndDragging: self willDecelerate: decelerate];
    }
}

- (void)scrollViewDidEndScrollingAnimation: (UIScrollView *)scrollView
{
    self.scrollDirection = TGScrollDirectionNone;
    [self p_adjustViews];
    
    if (self.dataSource && [self.dataSource respondsToSelector: @selector(tgScrollViewDidEndScrollingAnimation:)])
    {
        [self.dataSource tgScrollViewDidEndScrollingAnimation: self];
    }
}

- (void)scrollViewDidEndDecelerating: (UIScrollView *)scrollView
{
    self.scrollDirection = TGScrollDirectionNone;
    [self p_adjustViews];
    
    if (self.dataSource && [self.dataSource respondsToSelector: @selector(tgScrollViewDidEndDecelerating:)])
    {
        [self.dataSource tgScrollViewDidEndDecelerating: self];
    }
}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
    if (self.lastContentOffset > scrollView.contentOffset.x)
    {
        self.scrollDirection = TGScrollDirectionRight;
    }
    else if (self.lastContentOffset < scrollView.contentOffset.x)
    {
        self.scrollDirection = TGScrollDirectionLeft;
    }
    self.lastContentOffset = scrollView.contentOffset.x;
    
    if (self.dataSource && [self.dataSource respondsToSelector: @selector(tgScrollViewDidScroll:)])
    {
        [self.dataSource tgScrollViewDidScroll: self];
    }
}

#pragma mark - debug

- (void)debugSubViews
{
#if DEBUG
    NSLog(@"\n");
    NSLog(@"-----------");
    NSLog(@"**** first index: %@", @(self.firstScreenObjectIndex));
    NSLog(@"**** last index: %@", @(self.lastScreenObjectIndex));
    NSUInteger viewNum = 0;
    for (NSUInteger i = 0; i < self.rowCount; i ++)
    {
        TGScrollViewWrapper *wrapper = self.wrappers[i];
        if (wrapper.v)
        {
            NSLog(@"**** section: %@ row: %@ view: %@", @(wrapper.indexPath.section), @(wrapper.indexPath.row),  NSStringFromCGRect(wrapper.v.frame));
            NSAssert(!CGRectIsNull(CGRectIntersection(self.bounds, wrapper.v.frame)), @"view :%@ :frame: %@ error not on screen: %@", @([self.wrappers indexOfObject: wrapper]), NSStringFromCGRect(wrapper.v.frame), NSStringFromCGRect(self.bounds));
            viewNum ++;
        }
    }
    NSLog(@"-----------");
#endif
}

@end
