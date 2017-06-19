//
//  JeanDesignContainer.m
//  Panachz
//
//  Created by sanlimikaifa on 2017/3/3.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#import "JeanDesignContainer.h"
#import "Jeans.h"
#import "JeansWash.h"
#import "UIImage+Size.h"
#import "UIImageView+WebCache.h"

@interface JeanDesignContainer ()


@end

@implementation JeanDesignContainer

- (instancetype)init{
    self = [super init];
    
    self.frontView = YES;
    
//    self.frame = CGRectMake(0, 0, 360, 675);
    
    self.jeansBaseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 360, 675)];
    self.jeansBaseImageView.image = [UIImage imageNamed:@"USKY-001M-F-low_jean"];
    [self addSubview:self.jeansBaseImageView];
    
    self.dotlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 360, 675)];
    [self addSubview:self.dotlineImageView];
    
    self.leftWashView = [[UIView alloc] initWithFrame:CGRectMake(-2, 19, 240, 630)];
    [self addSubview:self.leftWashView];
    
    self.rightWashView = [[UIView alloc] initWithFrame:CGRectMake(118, 19, 240, 630)];
    [self addSubview:self.rightWashView];
    
    return self;
}

- (void)switchFrontBack {
    self.frontView = !self.frontView;
    
    [self updateJeansPreview];
}

- (void)updateJeansPreview {
    [self changeJeansPreviewBase];
    [self changeWash];
    [self changesJeansDotline];
}

- (void)changeJeansPreviewBase {
    NSString *previewImageName = nil;
    
    NSString *jeansFitName = nil;
    NSString *jeansGenderName = nil;
    NSString *jeansFrontBackString = nil;
    NSString *jeansBaseColor = nil;
    
    if (self.currentJeans.jeanFit == JEANS_FIT_SKINNY || self.currentJeans.jeanFit == JEANS_FIT_NOT_SET) {
        jeansFitName = @"USKY";
    } else if (self.currentJeans.jeanFit == JEANS_FIT_STRAIGHT) {
        jeansFitName = @"USTR";
    } else if (self.currentJeans.jeanFit == JEANS_FIT_BOOOTCUT) {
        jeansFitName = @"UBTC";
    } else {
        jeansFitName = @"UJEG";
    }
    
    jeansGenderName = self.currentJeans.jeanGender == JEANS_GENDER_M ? @"M" : @"F";
    
    jeansFrontBackString = self.frontView ? @"F" : @"B";
    
    if (self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_NOT_SET || self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_LIGHT) {
        jeansBaseColor = @"low";
    } else if (self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_MEDIUM) {
        jeansBaseColor = @"middle";
    }
    else {
        jeansBaseColor = @"high";
    }
    
    previewImageName = [NSString stringWithFormat:@"%@-001%@-%@-%@_jean", jeansFitName, jeansGenderName, jeansFrontBackString, jeansBaseColor];
    
    [self.jeansBaseImageView setImage:[UIImage imageNamed:previewImageName]];
}

- (void)changeWash {
    
    for (UIView *view in [self.leftWashView subviews]) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in [self.rightWashView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < self.currentJeans.jeanWashes.count; i++) {
        JeansWash *jeansWash = [self.currentJeans.jeanWashes objectAtIndex:i];
        
        if (self.frontView == jeansWash.front) {
            
            UIImageView *view = [[UIImageView alloc] init];
            [view sd_setImageWithURL:jeansWash.washModel.display_imgUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGFloat width = image.size.width/O_D_Scale*jeansWash.scoleNum;
                CGFloat height = image.size.height/O_D_Scale*jeansWash.scoleNum;
                view.frame = CGRectMake(0, 0, width, height);
                view.center = CGPointMake(jeansWash.centerPointX, jeansWash.centerPointY);
            }];
            
            if (jeansWash.left) {
                [self.leftWashView addSubview:view];
            } else {
                [self.rightWashView addSubview:view];
            }
        }
    }
}

- (void)changesJeansDotline {
    if (self.currentJeans.jeanContrucstionThread != JEANS_CONSTRUCTION_THREAD_NOT_SET) {
        self.dotlineImageView.hidden = NO;
        
        NSString *dotlineImageName = nil;
        NSString *jeansFitName = nil;
        NSString *jeansGenderName = nil;
        NSString *jeansFrontBackString = nil;
        NSString *jeansConstructionThreadString = nil;
        
        if (self.currentJeans.jeanFit == JEANS_FIT_SKINNY || self.currentJeans.jeanFit == JEANS_FIT_NOT_SET) {
            jeansFitName = @"USKY";
        } else if (self.currentJeans.jeanFit == JEANS_FIT_STRAIGHT) {
            jeansFitName = @"USTR";
        } else if (self.currentJeans.jeanFit == JEANS_FIT_BOOOTCUT) {
            jeansFitName = @"UBTC";
        } else {
            jeansFitName = @"UJEG";
        }
        
        jeansGenderName = self.currentJeans.jeanGender == JEANS_GENDER_M ? @"M" : @"F";
        
        jeansFrontBackString = self.frontView ? @"F" : @"B";
        
        switch (self.currentJeans.jeanContrucstionThread) {
            case JEANS_CONSTRUCTION_THREAD_COPPER:
                jeansConstructionThreadString = @"copper";
                break;
            case JEANS_CONSTRUCTION_THREAD_GOLD:
                jeansConstructionThreadString = @"gold";
                break;
            case JEANS_CONSTRUCTION_THREAD_INDIGO:
                jeansConstructionThreadString = @"indigo";
                break;
            case JEANS_CONSTRUCTION_THREAD_LIGHT_BLUE:
                jeansConstructionThreadString = @"lightblue";
                break;
            case JEANS_CONSTRUCTION_THREAD_WHITE:
                jeansConstructionThreadString = @"white";
                break;
            default:
                jeansConstructionThreadString = @"copper";
                break;
        }
        
        dotlineImageName = [NSString stringWithFormat:@"%@-001%@-%@-%@-dotline", jeansFitName, jeansGenderName, jeansFrontBackString, jeansConstructionThreadString];
        
        [self.dotlineImageView setImage:[UIImage imageNamed:dotlineImageName]];
    } else {
        self.dotlineImageView.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
