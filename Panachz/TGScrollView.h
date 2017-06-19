//
//  TGScrollView.h
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TGScrollViewStyle)
{
    TGScrollViewStyleNormal,
    TGScrollViewStylePage
};

@class TGScrollView;

@protocol TGScrollViewDataSource <NSObject>

@required
- (UIView *)tgScrollView: (TGScrollView *)scrollView viewForRowAtIndex: (NSUInteger)viewIndex;
- (NSInteger)numberOfRowsInTGScrollView: (TGScrollView *)scrollView;

@optional
- (void)tgScrollView: (TGScrollView *)scrollView didSelectRowAtIndex: (NSUInteger)viewIndex;
- (void)tgScrollView: (TGScrollView *)scrollView didSelectRowAtIndex: (NSUInteger)viewIndex viewSelected: (UIView *)v;
- (NSInteger)numberOfRowsPerPageInTGScrollView: (TGScrollView *)scrollView;
- (void)tgScrollViewDidEndDecelerating: (TGScrollView *)scrollView;
- (void)tgScrollViewDidScroll: (TGScrollView *)scrollView;
- (void)tgScrollViewDidEndDragging: (TGScrollView *)scrollView willDecelerate: (BOOL)decelerate;
- (void)tgScrollViewDidEndScrollingAnimation: (TGScrollView *)scrollView;

@end

@interface TGScrollView : UIScrollView

- (instancetype)initWithFrame: (CGRect)frame style: (TGScrollViewStyle)style;

@property (nonatomic, readonly) TGScrollViewStyle style;

@property (nonatomic, assign, readonly) NSInteger screenPageIndex;

@property (nonatomic, assign) CGFloat contentSubviewGap;

@property (nonatomic, assign) BOOL enableLoop;
/**
 *  defalut to be 0.f
 */
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;

@property (nonatomic, weak) id<TGScrollViewDataSource> dataSource;

- (void)reload;

- (UIView *)dequeueReusableViewWithIndex: (NSUInteger)viewIndex;

- (void)nextPage;
- (void)previousPage;

@end
