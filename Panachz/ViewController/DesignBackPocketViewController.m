//
//  DesignBackPocketViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 14/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "DesignBackPocketViewController.h"
#import "Jeans.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+Identifier.h"
#import "UIColor+HexColor.h"

#define WHITE_CHECK_ICON @"ic_check_circle_white_36dp"
#define GREY_CHECK_ICON @"ic_check_circle_grey600_36dp"

#define LEFT_ARROW @"ic_chevron_left_grey600_48dp"
#define RIGHT_ARROW @"ic_chevron_right_grey600_48dp"
#define LEFT_ARROW_TRANS @"ic_chevron_left_grey600_48dp_trans"
#define RIGHT_ARROW_TRANS @"ic_chevron_right_grey600_48dp_trans"

@interface DesignBackPocketViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) Jeans *currentJeans;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSMutableArray *backPocketImageViews;

@end

@implementation DesignBackPocketViewController

@synthesize currentJeans;
@synthesize gender;

@synthesize resetBackPocketButton;

@synthesize backPocketImageView;
@synthesize backPocketCheckBarButton;
@synthesize backPocketCheckBarTextLabel;
@synthesize backPocketPreivewRightButton;
@synthesize backPocketPreviewLeftButton;
@synthesize backPocketImageViews;
@synthesize backPocketPreviewThumbnailScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup tap gesture on reset button
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(resetBackPacket)];
    [tap setNumberOfTapsRequired:1];
    [self.resetBackPocketButton setUserInteractionEnabled:YES];
    [self.resetBackPocketButton addGestureRecognizer:tap];
    
    // Setup left button
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTapOnLeftButton)];
    [tap setNumberOfTapsRequired:1];
    [self.backPocketPreviewLeftButton setUserInteractionEnabled:NO];
    [self.backPocketPreviewLeftButton addGestureRecognizer:tap];
    [self.backPocketPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
    
    // Setup right button
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTapOnRightButton)];
    [tap setNumberOfTapsRequired:1];
    [self.backPocketPreivewRightButton setUserInteractionEnabled:NO];
    [self.backPocketPreivewRightButton addGestureRecognizer:tap];
    [self.backPocketPreivewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
    
    // Setup thumbnail scrollview
    self.backPocketImageViews = [[NSMutableArray alloc] init];
    self.backPocketPreviewThumbnailScrollView.delegate = self;
    [self setupThumbnailPreviewForBackPocket];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didCheckBackPocket)];
    [tap setNumberOfTapsRequired:1];
    [self.backPocketCheckBarButton setUserInteractionEnabled:YES];
    [self.backPocketCheckBarButton addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectGender:)
                                                 name:@"SelectGender"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSwitchGender:)
                                                 name:@"SwitchGender"
                                               object:nil];
    
}

- (void)resetBackPacket {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Are you sure to reset Fabric?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    self.currentJeans.jeanBackPocket = JEANS_BACK_POCKET_NOT_SET;
                                                    
                                                    [self.backPocketCheckIcon setImage:nil];
                                                    
                                                    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
                                                        [self.backPocketImageView setImage:[UIImage imageNamed:@"UBPS-001M"]];
                                                        [self.backPocketCheckBarTextLabel setText:@"Men Back Pocket Shape UBPS-001M"];
                                                    } else {
                                                        [self.backPocketImageView setImage:[UIImage imageNamed:@"UBPS-001F"]];
                                                        [self.backPocketCheckBarTextLabel setText:@"Women Back Pocket Shape UBPS-001F"];
                                                    }
                                                    
                                                    [self.backPocketCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
                                                    [self setupThumbnailPreviewForBackPocket];
                                                    
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetBackPocket"
                                                                                                        object:nil];
                                                }];
    [alert addAction:cancel];
    [alert addAction:yes];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - NSNotification

- (void)didSelectGender:(NSNotification *)notifiction {
    self.gender = [notifiction.userInfo objectForKey:@"Gender"];
    self.currentJeans = [notifiction.userInfo objectForKey:@"Jeans"];
    [self setupThumbnailPreviewForBackPocket];
}

- (void)didSwitchGender:(NSNotification *)notifiction {
    self.gender = [notifiction.userInfo objectForKey:@"Gender"];
    
    self.currentJeans.jeanBackPocket = JEANS_BACK_POCKET_NOT_SET;
    
    [self.backPocketCheckIcon setImage:nil];
    
    if ([self.gender isEqualToString:@"M"]) {
        [self.backPocketImageView setImage:[UIImage imageNamed:@"UBPS-001M"]];
        [self.backPocketCheckBarTextLabel setText:@"Men Back Pocket Shape UBPS-001M"];
    } else {
        [self.backPocketImageView setImage:[UIImage imageNamed:@"UBPS-001F"]];
        [self.backPocketCheckBarTextLabel setText:@"Women Back Pocket Shape UBPS-001F"];
    }
    
    [self.backPocketCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    [self setupThumbnailPreviewForBackPocket];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetBackPocket"
                                                        object:nil];
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGPoint contentOffset = [self.backPocketPreviewThumbnailScrollView contentOffset];
    contentOffset.x += self.backPocketPreviewThumbnailScrollView.frame.size.width;
    
    if (contentOffset.x >= self.backPocketPreviewThumbnailScrollView.contentSize.width) {
        [self.backPocketPreivewRightButton setUserInteractionEnabled:NO];
        [self.backPocketPreivewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
    } else {
        [self.backPocketPreivewRightButton setUserInteractionEnabled:YES];
        [self.backPocketPreivewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
    }
    
    if ([self.backPocketPreviewThumbnailScrollView contentOffset].x == 0) {
        [self.backPocketPreviewLeftButton setUserInteractionEnabled:NO];
        [self.backPocketPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
    } else {
        [self.backPocketPreviewLeftButton setUserInteractionEnabled:YES];
        [self.backPocketPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW]];
    }
}

- (void)setupThumbnailPreviewForBackPocket {
    for (UIView *subview in [self.backPocketPreviewThumbnailScrollView subviews]) {
        for (UIGestureRecognizer *recognizer in subview.gestureRecognizers) {
            [subview removeGestureRecognizer:recognizer];
        }
        [subview removeFromSuperview];
    }
    
    [self.backPocketImageViews removeAllObjects];
    
    NSString *backPocketName = nil;
    NSString *genderString = nil;
    
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        genderString = @"M";
    } else {
        genderString = @"F";
    }
    
    CGFloat xPosition = 0;
    for (int i = 1; i < 6; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 98, 98)];
        [view setBackgroundColor:[UIColor colorWithRBGValue:0xffffff alpha:0.5]];
        
        UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 90, 90)];
        backPocketName = [NSString stringWithFormat:@"UBPS-00%i%@_thumbnail", i, genderString];
        [thumbnail setImage:[UIImage imageNamed:backPocketName]];
        [thumbnail setIdentifier:[NSString stringWithFormat:@"UBPS-00%i%@", i, genderString]];
        
        [self.backPocketImageViews addObject:thumbnail];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didTapOnThumbnail:)];
        [tap setNumberOfTapsRequired:1];
        [thumbnail setUserInteractionEnabled:YES];
        [thumbnail addGestureRecognizer:tap];
        
        [view addSubview:thumbnail];
        [self.backPocketPreviewThumbnailScrollView addSubview:view];
        
        xPosition += 12.0 + 98.0;
        
        if (i == 4 && self.currentJeans.jeanGender == JEANS_GENDER_M) {
            break;
        }
    }
    
    for (int i = 0; i < 3 && self.currentJeans.jeanGender == JEANS_GENDER_F; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 98, 98)];
        [view setBackgroundColor:[UIColor colorWithRBGValue:0xcccccc alpha:0.5]];
        [self.backPocketPreviewThumbnailScrollView addSubview:view];
        
        xPosition += 12.0 + 98.0;
    }
    
    // Add border to first thumbnail
    UIImageView *firstThumbnail = (UIImageView *)[self.backPocketImageViews firstObject];
    firstThumbnail.superview.layer.borderWidth = 2.0;
    firstThumbnail.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    CGSize contentSize = self.backPocketPreviewThumbnailScrollView.contentSize;
    contentSize.width = xPosition - 12.0 - 98.0;
    [self.backPocketPreviewThumbnailScrollView setContentSize:contentSize];
    
    CGPoint offset = self.backPocketPreviewThumbnailScrollView.contentOffset;
    offset.x = 0;
    [self.backPocketPreviewThumbnailScrollView setContentOffset:offset];
    
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        [self.backPocketPreivewRightButton setUserInteractionEnabled:NO];
        [self.backPocketPreivewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
    } else {
        [self.backPocketPreivewRightButton setUserInteractionEnabled:YES];
        [self.backPocketPreivewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
    }
    [self.backPocketPreviewLeftButton setUserInteractionEnabled:NO];
    [self.backPocketPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
    
    self.backPocketPreviewThumbnailScrollView.scrollEnabled = NO;
}

- (void)didTapOnLeftButton {
    [self.backPocketPreviewLeftButton setUserInteractionEnabled:NO];
    [self.backPocketPreivewRightButton setUserInteractionEnabled:NO];
    
    CGPoint contentOffset = [self.backPocketPreviewThumbnailScrollView contentOffset];
    contentOffset.x -= (self.backPocketPreviewThumbnailScrollView.frame.size.width + 12.0);
    [self.backPocketPreviewThumbnailScrollView setContentOffset:contentOffset
                                                       animated:YES];
}

- (void)didTapOnRightButton {
    [self.backPocketPreviewLeftButton setUserInteractionEnabled:NO];
    [self.backPocketPreivewRightButton setUserInteractionEnabled:NO];
    
    CGPoint contentOffset = [self.backPocketPreviewThumbnailScrollView contentOffset];
    contentOffset.x += (self.backPocketPreviewThumbnailScrollView.frame.size.width + 12.0);
    [self.backPocketPreviewThumbnailScrollView setContentOffset:contentOffset
                                                       animated:YES];
}

- (void)didTapOnThumbnail:(UIGestureRecognizer *)tap {
    UIImageView *thumbnail = (UIImageView *)tap.view;
    
    for (UIImageView *iv in self.backPocketImageViews) {
        iv.superview.layer.borderWidth = 0.0;
    }
    
    thumbnail.superview.layer.borderWidth = 2.0;
    thumbnail.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    [self.backPocketImageView setImage:[UIImage imageNamed:thumbnail.identifier]];
    [self.backPocketCheckBarTextLabel setText:[NSString stringWithFormat:@"%@ Back Pocket Shape %@", (self.currentJeans.jeanGender == JEANS_GENDER_M ? @"Men" : @"Women"), thumbnail.identifier]];
    
    JeansBackPocket jbp = JEANS_BACK_POCKET_NOT_SET;
    
    if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Men Back Pocket Shape UBPS-001M"]) {
        jbp = JEANS_BACK_POCKET_UBPS_001M;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Men Back Pocket Shape UBPS-002M"]) {
        jbp = JEANS_BACK_POCKET_UBPS_002M;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Men Back Pocket Shape UBPS-003M"]) {
        jbp = JEANS_BACK_POCKET_UBPS_003M;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Men Back Pocket Shape UBPS-004M"]) {
        jbp = JEANS_BACK_POCKET_UBPS_004M;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Women Back Pocket Shape UBPS-001F"]) {
        jbp = JEANS_BACK_POCKET_UBPS_001F;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Women Back Pocket Shape UBPS-002F"]) {
        jbp = JEANS_BACK_POCKET_UBPS_002F;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Women Back Pocket Shape UBPS-003F"]) {
        jbp = JEANS_BACK_POCKET_UBPS_003F;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Women Back Pocket Shape UBPS-004F"]) {
        jbp = JEANS_BACK_POCKET_UBPS_004F;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Women Back Pocket Shape UBPS-005F"]) {
        jbp = JEANS_BACK_POCKET_UBPS_005F;
    }
    
    if (self.currentJeans.jeanBackPocket == jbp && self.currentJeans.jeanBackPocket != JEANS_BACK_POCKET_NOT_SET) {
        [self.backPocketCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.backPocketCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
}

- (void)didCheckBackPocket {
    JeansBackPocket jbp = JEANS_BACK_POCKET_NOT_SET;
    
    if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Men Back Pocket Shape UBPS-001M"]) {
        jbp = JEANS_BACK_POCKET_UBPS_001M;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Men Back Pocket Shape UBPS-002M"]) {
        jbp = JEANS_BACK_POCKET_UBPS_002M;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Men Back Pocket Shape UBPS-003M"]) {
        jbp = JEANS_BACK_POCKET_UBPS_003M;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Men Back Pocket Shape UBPS-004M"]) {
        jbp = JEANS_BACK_POCKET_UBPS_004M;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Women Back Pocket Shape UBPS-001F"]) {
        jbp = JEANS_BACK_POCKET_UBPS_001F;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Women Back Pocket Shape UBPS-002F"]) {
        jbp = JEANS_BACK_POCKET_UBPS_002F;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Women Back Pocket Shape UBPS-003F"]) {
        jbp = JEANS_BACK_POCKET_UBPS_003F;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Women Back Pocket Shape UBPS-004F"]) {
        jbp = JEANS_BACK_POCKET_UBPS_004F;
    } else if ([self.backPocketCheckBarTextLabel.text isEqualToString:@"Women Back Pocket Shape UBPS-005F"]) {
        jbp = JEANS_BACK_POCKET_UBPS_005F;
    }
    
    if (self.currentJeans.jeanBackPocket == jbp) {
        self.currentJeans.jeanBackPocket = JEANS_BACK_POCKET_NOT_SET;
        [self.backPocketCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        [self.backPocketCheckIcon setImage:nil];
    } else {
        self.currentJeans.jeanBackPocket = jbp;
        [self.backPocketCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
        [self.backPocketCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetBackPocket"
                                                        object:nil];
}

@end
