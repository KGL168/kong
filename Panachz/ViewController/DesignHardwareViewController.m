//
//  DesignHardwareViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 14/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "DesignHardwareViewController.h"
#import "DesignHardwareChooseFontTypeViewController.h"
#import "DesignHardwareChooseFontSizeViewController.h"
#import "Jeans.h"
#import "UIColor+HexColor.h"
#import "UIImage+CaptureView.h"

#define WHITE_CHECK_ICON @"ic_check_circle_white_36dp"
#define GREY_CHECK_ICON @"ic_check_circle_grey600_36dp"

#import "TGScrollView.h"

@interface DesignHardwareViewController () <FontTypeSelectedDelegate, SelectFontSizeDelegate, UITextFieldDelegate, TGScrollViewDataSource> {
    /* keyboard auto go up */
    CGFloat currentKeyboardHeight;
    CGFloat deltaHeight;
    CGFloat moved;
    CGFloat textfield_y;
    bool animated;
}
@property (nonatomic, strong) Jeans *currentJeans;
@property (nonatomic) BOOL wordingLock;
@property (nonatomic, strong) NSString *selectedFont;
@property (nonatomic) NSUInteger selectedFontSize;

@property (nonatomic, strong) TGScrollView *shankScrollView;

@property (nonatomic, strong) NSArray *picName;
@property (nonatomic, assign) NSInteger selectedShank;
@property (nonatomic, strong) UIView *selectedMaskView;

@end

@implementation DesignHardwareViewController

@synthesize currentJeans;
@synthesize selectedFont;
@synthesize selectedFontSize;

@synthesize resetHardwareButton;
@synthesize rightSegmentedControl;
@synthesize shankCheckIcon;
@synthesize wordingCheckIcon;
@synthesize rivetCheckIcon;

@synthesize shankView;
@synthesize shankImageView;
@synthesize shankCheckBarButton;
@synthesize shankCheckBarTextLabel;
@synthesize shankThumbnail1;
@synthesize shankThumbnail2;

@synthesize wordingLock;
@synthesize wordingView;
@synthesize wordingImageView;
@synthesize wordingWordView;
@synthesize wordingBarline;
@synthesize wordingWord;
@synthesize wordingViewFontLabel;
@synthesize wordingViewFontSizeLabel;
@synthesize wordingViewTextField;
@synthesize wordingLockButton;

@synthesize rivetView;
@synthesize rivetImageView;
@synthesize rivetCheckBarButton;
@synthesize rivetCheckBarTextLabel;
@synthesize rivetThumbnail1;
@synthesize rivetThumbnail2;
@synthesize rivetThumbnail3;
@synthesize rivetThumbnail4;

@synthesize hwView;

- (UIView *)selectedMaskView
{
    if (!_selectedMaskView)
    {
        _selectedMaskView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, 98.0, 98.0)];
        _selectedMaskView.backgroundColor = [UIColor clearColor];
        _selectedMaskView.layer.borderColor = [UIColor grayColor].CGColor;
        _selectedMaskView.layer.borderWidth = 2.0;
    }
    return _selectedMaskView;
}

- (void)p_nextTap: (id)sender
{
    NSLog(@"------ next");
    [self.shankScrollView nextPage];
}

- (void)p_previousTap: (id)sender
{
    NSLog(@"------ previous");
    [self.shankScrollView previousPage];
}

- (NSInteger)numberOfRowsInTGScrollView: (TGScrollView *)scrollView
{
    return 8;
}

- (NSInteger)numberOfRowsPerPageInTGScrollView:(TGScrollView *)scrollView
{
    return 4;
}

- (void)tgScrollView: (TGScrollView *)scrollView didSelectRowAtIndex: (NSUInteger)viewIndex viewSelected: (UIView *)v
{
    self.selectedShank = viewIndex;
    [self.selectedMaskView removeFromSuperview];
    [v addSubview: self.selectedMaskView];
    
    [self.shankImageView setImage: [UIImage imageNamed: self.picName[viewIndex]]];
    if (self.currentJeans.jeanShank == JEANS_SHANK_SHINNY_GOLD)
    {
        [self.shankCheckBarButton setImage: [UIImage imageNamed: @"button_checked_bar"]];
    }
    else
    {
        [self.shankCheckBarButton setImage: [UIImage imageNamed: @"button_unchecked_bar"]];
    }
    [self.shankCheckBarTextLabel setText: self.picName[viewIndex]];
}

- (UIView *)tgScrollView: (TGScrollView *)scrollView viewForRowAtIndex: (NSUInteger)viewIndex
{
    UIView *v = [scrollView dequeueReusableViewWithIndex: viewIndex];
    if (!v)
    {
        v = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, 98.0, 98.0)];
        v.backgroundColor = [UIColor whiteColor];
        UIImageView *vi = [[UIImageView alloc] initWithImage: [UIImage imageNamed: self.picName[viewIndex]]];
        vi.frame = CGRectMake(0.0, 0.0, 90.0, 90.0);
        vi.center = v.center;
        [vi setContentMode: UIViewContentModeScaleAspectFill];
        [v addSubview: vi];
    }
    if (viewIndex == self.selectedShank)
    {
        [v addSubview: self.selectedMaskView];
        //v.layer.borderColor = [UIColor grayColor].CGColor;
        //v.layer.borderWidth = 2.0;
    }
    return v;
}

- (void)p_initialer
{
    _selectedShank = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_initialer];
    
    _picName = @[@"USHK-001CO", @"USHK-001GM", @"USHK-001SV", @"USHK-001SG", @"USHK-002CO", @"USHK-002GM",
                 @"USHK-002SG", @"USHK-002SV"];
    
    _shankScrollView = [[TGScrollView alloc] initWithFrame: CGRectMake(36.0, 466.0, 440.0, 98.0) style: TGScrollViewStylePage];
    [self.shankScrollView setDataSource: self];
    [self.shankView addSubview: self.shankScrollView];
    [self.shankView bringSubviewToFront: self.shankScrollView];
    
    [self.shankImageView setImage: [UIImage imageNamed: self.picName[0]]];
    
    UITapGestureRecognizer *previousTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(p_previousTap:)];
    [previousTap setNumberOfTapsRequired: 1];
    [self.previousButton setUserInteractionEnabled: YES];
    [self.previousButton addGestureRecognizer: previousTap];
    
    UITapGestureRecognizer *nextTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(p_nextTap:)];
    [nextTap setNumberOfTapsRequired: 1];
    [self.nextButton setUserInteractionEnabled: YES];
    [self.nextButton addGestureRecognizer: nextTap];
    
    // Tap gesture on reset
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(resetHardware)];
    [tap setNumberOfTapsRequired:1];
    [self.resetHardwareButton setUserInteractionEnabled:YES];
    [self.resetHardwareButton addGestureRecognizer:tap];
    
    
    // Setup segmented control in the right view
    NSDictionary *normalAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular"
                                                                             size:12.0f],
                                       NSForegroundColorAttributeName: [UIColor colorWithRBGValue:0x444444]};
    [self.rightSegmentedControl setTitleTextAttributes:normalAttributes
                                              forState:UIControlStateNormal];
    NSDictionary *selectedAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular"
                                                                               size:12.0f],
                                         NSForegroundColorAttributeName: [UIColor colorWithRBGValue:0xffffff]};
    [self.rightSegmentedControl setTitleTextAttributes:selectedAttributes
                                              forState:UIControlStateSelected];
    
    /* Setup shank view */
    
    // Check Bar
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didCheckShank)];
    [tap setNumberOfTapsRequired:1];
    [self.shankCheckBarButton setUserInteractionEnabled:YES];
    [self.shankCheckBarButton addGestureRecognizer:tap];
    
    // Thumbnail
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToShank1)];
    [tap setNumberOfTapsRequired:1];
    [self.shankThumbnail1 setUserInteractionEnabled:YES];
    [self.shankThumbnail1 addGestureRecognizer:tap];
    self.shankThumbnail1.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.shankThumbnail1.superview.layer.borderWidth = 2.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToShank2)];
    [tap setNumberOfTapsRequired:1];
    [self.shankThumbnail2 setUserInteractionEnabled:YES];
    [self.shankThumbnail2 addGestureRecognizer:tap];
    self.shankThumbnail2.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.shankThumbnail2.superview.layer.borderWidth = 0.0;
    [self.shankCheckBarTextLabel setText: self.picName[self.selectedShank]];
    /* End setup shank view */
    
    /* Setup Wordings view */
    self.wordingLock = NO;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(moveWordingViewWord:)];
    [self.wordingWordView setUserInteractionEnabled:YES];
    [self.wordingWordView addGestureRecognizer:pan];
    [self.wordingImageView setImage:[UIImage imageNamed:@"wording_images"]];
//    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self
//                                                                                       action:@selector(rotateWordingViewWord:)];
//    [self.wordingWordView addGestureRecognizer:rotate];
    
    self.selectedFont = @"Arial";
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(openFontSelectModal)];
    [tap setNumberOfTapsRequired:1];
    [self.wordingViewFontLabel setUserInteractionEnabled:YES];
    [self.wordingViewFontLabel addGestureRecognizer:tap];
    
    self.selectedFontSize = 72;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(openFontSizeSelectModal)];
    [tap setNumberOfTapsRequired:1];
    [self.wordingViewFontSizeLabel setUserInteractionEnabled:YES];
    [self.wordingViewFontSizeLabel addGestureRecognizer:tap];
    
    self.wordingViewTextField.delegate = self;
    /* End setup wordings view*/
    
    /* Setup rivet view */
    
    // Check bar
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didCheckRivet)];
    [tap setNumberOfTapsRequired:1];
    [self.rivetCheckBarButton setUserInteractionEnabled:YES];
    [self.rivetCheckBarButton addGestureRecognizer:tap];
    
    // Thumbnail
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToRivet1)];
    [tap setNumberOfTouchesRequired:1];
    [self.rivetThumbnail1 setUserInteractionEnabled:YES];
    [self.rivetThumbnail1 addGestureRecognizer:tap];
    self.rivetThumbnail1.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.rivetThumbnail1.superview.layer.borderWidth = 2.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToRivet2)];
    [tap setNumberOfTouchesRequired:1];
    [self.rivetThumbnail2 setUserInteractionEnabled:YES];
    [self.rivetThumbnail2 addGestureRecognizer:tap];
    self.rivetThumbnail2.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.rivetThumbnail2.superview.layer.borderWidth = 0.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToRivet3)];
    [tap setNumberOfTouchesRequired:1];
    [self.rivetThumbnail3 setUserInteractionEnabled:YES];
    [self.rivetThumbnail3 addGestureRecognizer:tap];
    self.rivetThumbnail3.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.rivetThumbnail3.superview.layer.borderWidth = 0.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToRivet4)];
    [tap setNumberOfTouchesRequired:1];
    [self.rivetThumbnail4 setUserInteractionEnabled:YES];
    [self.rivetThumbnail4 addGestureRecognizer:tap];
    self.rivetThumbnail4.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.rivetThumbnail4.superview.layer.borderWidth = 0.0;
    
    /* End Setup rivet view */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)viewAnimated {
    [super viewWillAppear: viewAnimated];
    self.nextButton.userInteractionEnabled = YES;
    self.previousButton.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectGender:)
                                                 name:@"SelectGender"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetJeans)
                                                 name:@"ResetJeans"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rightSegmentedControlDidChangeValue:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.shankView.hidden = NO;
        self.wordingView.hidden = YES;
        self.rivetView.hidden = YES;
        
        if (self.currentJeans.jeanShank == JEANS_SHANK_NOT_SET) {
            [self.shankCheckIcon setImage:nil];
        } else {
            [self.shankCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
        }
        
        if (self.currentJeans.jeanRivet == JEANS_RIVET_NOT_SET) {
            [self.rivetCheckIcon setImage:nil];
        } else {
            [self.rivetCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
        }
        
        if (self.currentJeans.jeanHardwareWordingText != nil) {
            [self.wordingCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
        } else {
            [self.wordingCheckIcon setImage:nil];
        }
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        self.shankView.hidden = YES;
        self.wordingView.hidden = NO;
        self.rivetView.hidden = YES;
        
        if (self.currentJeans.jeanShank == JEANS_SHANK_NOT_SET) {
            [self.shankCheckIcon setImage:nil];
        } else {
            [self.shankCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
        }
        
        if (self.currentJeans.jeanRivet == JEANS_RIVET_NOT_SET) {
            [self.rivetCheckIcon setImage:nil];
        } else {
            [self.rivetCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
        }
        
        if (self.currentJeans.jeanHardwareWordingText != nil) {
            [self.wordingCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
        } else {
            [self.wordingCheckIcon setImage:nil];
        }
        
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        self.shankView.hidden = YES;
        self.wordingView.hidden = YES;
        self.rivetView.hidden = NO;
        
        if (self.currentJeans.jeanShank == JEANS_SHANK_NOT_SET) {
            [self.shankCheckIcon setImage:nil];
        } else {
            [self.shankCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
        }
        
        if (self.currentJeans.jeanRivet == JEANS_RIVET_NOT_SET) {
            [self.rivetCheckIcon setImage:nil];
        } else {
            [self.rivetCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
        }
        
        if (self.currentJeans.jeanHardwareWordingText != nil) {
            [self.wordingCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
        } else {
            [self.wordingCheckIcon setImage:nil];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchBack"
                                                            object:nil];
    }
}


#pragma mark - NSNotification

- (void)didSelectGender:(NSNotification *)notifiction {
    self.currentJeans = [notifiction.userInfo objectForKey:@"Jeans"];
}

#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    deltaHeight = kbSize.height - moved;
    currentKeyboardHeight = kbSize.height;
    [self animateTextField: YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self animateTextField: NO];
    currentKeyboardHeight = 0.0f;
}

- (void)animateTextField:(BOOL)up {
    if (textfield_y > [[UIScreen mainScreen] bounds].size.height - currentKeyboardHeight && !animated && up) {
        animated = YES;
    }
    
    if (animated) {
        const float movementDuration = 0.3f;
        
        int movement = (up ? -deltaHeight : moved);
        
        moved = (up ? moved + deltaHeight : 0.0f);
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
        
        if (!up) {
            animated = NO;
        }
    }
    
    textfield_y = 0.0f;
}

#pragma mark - Tap gesture

-(void)resetJeans {
    self.currentJeans.jeanShank = JEANS_SHANK_NOT_SET;
    self.currentJeans.jeanRivet = JEANS_RIVET_NOT_SET;
    self.currentJeans.jeanHardwareWordingText = nil;
    self.currentJeans.jeanHardwareWordingFontType = @"Arial";
    self.currentJeans.jeanHardwareWordingFontSize = 72;
    
    self.rightSegmentedControl.selectedSegmentIndex = 0;
    [self.shankCheckIcon setImage:nil];
    [self.wordingCheckIcon setImage:nil];
    [self.rivetCheckIcon setImage:nil];
    
    self.shankView.hidden = NO;
    self.wordingView.hidden = YES;
    self.rivetView.hidden = YES;
    
    //[self switchToShank1];
    [self.shankCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    
    self.wordingLock = NO;
    self.wordingBarline.hidden = NO;
    [self.wordingWord setText:@""];
    [self.wordingView setUserInteractionEnabled:YES];
    [self.wordingLockButton setImage:[UIImage imageNamed:@"circle_unlocked"]
                                forState:UIControlStateNormal];
    self.selectedFont = @"Arial";
    [self.wordingViewFontLabel setText:@"Arial"];
    [self.wordingViewFontLabel setUserInteractionEnabled:YES];
    self.selectedFontSize = 72;
    [self.wordingViewFontSizeLabel setText:@"72"];
    [self.wordingViewFontSizeLabel setUserInteractionEnabled:YES];
    self.wordingViewTextField.enabled = YES;
    [self.wordingViewTextField setText:@""];
    
    //[self switchToRivet1];
    [self.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    
    [self.shankCheckBarTextLabel setText: self.picName[self.selectedShank]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetHardware"
                                                        object:nil];
}

- (void)resetHardware {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Waring"
                                                                   message:@"Are you sure to reset Hardware?" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction *action) {
                                                    weakSelf.currentJeans.jeanShank = JEANS_SHANK_NOT_SET;
                                                    weakSelf.currentJeans.jeanRivet = JEANS_RIVET_NOT_SET;
                                                    weakSelf.currentJeans.jeanHardwareWordingText = nil;
                                                    weakSelf.currentJeans.jeanHardwareWordingFontType = @"Arial";
                                                    weakSelf.currentJeans.jeanHardwareWordingFontSize = 72;
                                                    
                                                    weakSelf.rightSegmentedControl.selectedSegmentIndex = 0;
                                                    [weakSelf.shankCheckIcon setImage:nil];
                                                    [weakSelf.wordingCheckIcon setImage:nil];
                                                    [weakSelf.rivetCheckIcon setImage:nil];
                                                    
                                                    weakSelf.shankView.hidden = NO;
                                                    weakSelf.wordingView.hidden = YES;
                                                    weakSelf.rivetView.hidden = YES;
                                                    
                                                    //[weakSelf switchToShank1];
                                                    [weakSelf.shankCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
                                                    
                                                    weakSelf.wordingLock = NO;
                                                    weakSelf.wordingBarline.hidden = NO;
                                                    [weakSelf.wordingWord setText:@""];
                                                    [weakSelf.wordingView setUserInteractionEnabled:YES];
                                                    [weakSelf.wordingLockButton setImage:[UIImage imageNamed:@"circle_unlocked"]
                                                                                forState:UIControlStateNormal];
                                                    weakSelf.selectedFont = @"Arial";
                                                    [weakSelf.wordingViewFontLabel setText:@"Arial"];
                                                    [weakSelf.wordingViewFontLabel setUserInteractionEnabled:YES];
                                                    weakSelf.selectedFontSize = 72;
                                                    [weakSelf.wordingViewFontSizeLabel setText:@"72"];
                                                    [weakSelf.wordingViewFontSizeLabel setUserInteractionEnabled:YES];
                                                    weakSelf.wordingViewTextField.enabled = YES;
                                                    [weakSelf.wordingViewTextField setText:@""];
                                                    
                                                    [weakSelf switchToRivet1];
                                                    [weakSelf.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
                                                    
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetHardware"
                                                                                                        object:nil];
                                                }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No"
                                                 style:UIAlertActionStyleCancel
                                               handler:nil];
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - Shank view

- (void)didCheckShank {
    JeansShank js = JEANS_SHANK_NOT_SET;
    
    if ([self.shankCheckBarTextLabel.text isEqualToString:@"Shank Shinny Gold"]) {
        js = JEANS_SHANK_SHINNY_GOLD;
        //[self.wordingImageView setImage:[UIImage imageNamed:@"USHK-001SG"]];
        [self.wordingImageView setImage:[UIImage imageNamed:@"wording_images"]];
    } else if ([self.shankCheckBarTextLabel.text isEqualToString:@"Shank Silver"]) {
        js = JEANS_SHANK_SILVER;
        [self.wordingImageView setImage:[UIImage imageNamed:@"USHK-001SV"]];
    }
    else
    {
        //[self.wordingImageView setImage: [UIImage imageNamed: self.picName[self.selectedShank]]];
        self.currentJeans.hardwareImage = [UIImage imageNamed: self.picName[self.selectedShank]];
        self.currentJeans.hardwareString = self.picName[self.selectedShank];
        [self.wordingImageView setImage:[UIImage imageNamed:@"wording_images"]];
    }
    
    if (self.currentJeans.jeanShank == js) {
        self.currentJeans.jeanShank = JEANS_SHANK_NOT_SET;
        [self.shankCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        [self.shankCheckIcon setImage:nil];
        //[self.wordingImageView setImage:[UIImage imageNamed:@"USHK-001SG"]];
        
        //self.currentJeans.hardwareImage = nil;
    } else {
        self.currentJeans.jeanShank = js;
        [self.shankCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
        [self.shankCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
        
        BOOL b = self.wordingBarline.hidden;
        self.wordingBarline.hidden = YES;
        //self.currentJeans.hardwareImage = [UIImage imageWithView:self.hwView];
        self.wordingBarline.hidden = b;
    }
    
    [self.shankCheckBarButton setImage: [UIImage imageNamed: @"button_checked_bar"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetHardware"
                                                        object:nil];
}

- (void)switchToShank1 {
    self.shankThumbnail1.superview.layer.borderWidth = 2.0;
    self.shankThumbnail2.superview.layer.borderWidth = 0.0;
    
    [self.shankImageView setImage:[UIImage imageNamed:@"USHK-001SG"]];
    if (self.currentJeans.jeanShank == JEANS_SHANK_SHINNY_GOLD) {
        [self.shankCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.shankCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    [self.shankCheckBarTextLabel setText:@"Shank Shinny Gold"];
}

- (void)switchToShank2 {
    self.shankThumbnail1.superview.layer.borderWidth = 0.0;
    self.shankThumbnail2.superview.layer.borderWidth = 2.0;
    
    [self.shankImageView setImage:[UIImage imageNamed:@"USHK-001SV"]];
    if (self.currentJeans.jeanShank == JEANS_SHANK_SILVER) {
        [self.shankCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.shankCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    [self.shankCheckBarTextLabel setText:@"Shank Silver"];
}

#pragma mark - Wordings View

- (void)moveWordingViewWord:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged || pan.state == UIGestureRecognizerStateEnded) {
        CGPoint trans = [pan translationInView:pan.view];
        CGRect rect = pan.view.frame;
        rect.origin.x += trans.x;
        rect.origin.y += trans.y;
        
        if (CGRectContainsRect(pan.view.superview.bounds, rect)) {
            pan.view.frame = rect;
        }
        
        [pan setTranslation:CGPointZero
                     inView:pan.view.superview];
    }
}

- (void)rotateWordingViewWord:(UIRotationGestureRecognizer *)rotate {
    if (rotate.state == UIGestureRecognizerStateBegan || rotate.state == UIGestureRecognizerStateChanged) {
        rotate.view.transform = CGAffineTransformRotate(rotate.view.transform, rotate.rotation);
    }
    
    rotate.rotation = 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChooseFontType"]) {
        DesignHardwareChooseFontTypeViewController *vc = (DesignHardwareChooseFontTypeViewController *)segue.destinationViewController;
        vc.fontTyleSelectedDelegate = self;
    } else if ([segue.identifier isEqualToString:@"ChooseFontSize"]) {
        DesignHardwareChooseFontSizeViewController *vc = (DesignHardwareChooseFontSizeViewController *)segue.destinationViewController;
        vc.selectFontSizeDelegate = self;
    }
}

- (void)openFontSelectModal {
    [self performSegueWithIdentifier:@"ChooseFontType"
                              sender:self];
}

- (void)openFontSizeSelectModal {
    [self performSegueWithIdentifier:@"ChooseFontSize"
                              sender:self];
}

- (IBAction)lockWordings:(id)sender {
    self.wordingLock = !self.wordingLock;
    
    if (self.wordingLock) {
        [self.wordingCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
        [self.wordingLockButton setImage:[UIImage imageNamed:@"circle_locked"]
                                forState:UIControlStateNormal];
        [self.wordingViewFontLabel setUserInteractionEnabled:NO];
        [self.wordingViewFontSizeLabel setUserInteractionEnabled:NO];
        [self.wordingViewTextField setEnabled:NO];
        [self.wordingWordView setUserInteractionEnabled:NO];
        self.wordingBarline.hidden = YES;
        
        self.currentJeans.jeanHardwareWordingText = self.wordingViewTextField.text;
        self.currentJeans.jeanHardwareWordingFontSize = [self.wordingViewFontSizeLabel.text intValue];
        self.currentJeans.jeanHardwareWordingFontType = self.wordingViewFontLabel.text;
    } else {
        [self.wordingCheckIcon setImage:nil];
        [self.wordingLockButton setImage:[UIImage imageNamed:@"circle_unlocked"]
                                forState:UIControlStateNormal];
        [self.wordingViewFontLabel setUserInteractionEnabled:YES];
        [self.wordingViewFontSizeLabel setUserInteractionEnabled:YES];
        [self.wordingViewTextField setEnabled:YES];
        [self.wordingWordView setUserInteractionEnabled:YES];
        self.wordingBarline.hidden = NO;
        
        self.currentJeans.jeanHardwareWordingText = nil;
    }
    
    BOOL b = self.wordingBarline.hidden;
    self.wordingBarline.hidden = YES;
    self.currentJeans.hardwareImage = [UIImage imageNamed: self.picName[self.selectedShank]];
    self.currentJeans.hardwareString = self.picName[self.selectedShank];
    self.wordingBarline.hidden = b;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetHardware"
                                                        object:nil];
}

#pragma mark - Font Type/Size Selected Delegate

- (void)didSelectFontType:(NSString *)fontName {
    self.selectedFont = fontName;
    [self.wordingViewFontLabel setText:fontName];
    [self.wordingViewFontLabel setTextColor:[UIColor colorWithRBGValue:0x444444]];
    [self.wordingWord setFont:[UIFont fontWithName:self.selectedFont
                                              size:self.selectedFontSize]];
}

- (void)didSelectedFontSize:(NSUInteger)fontSize {
    self.selectedFontSize = fontSize + 1;
    [self.wordingViewFontSizeLabel setText:[NSString stringWithFormat:@"%lu", fontSize]];
    [self.wordingWord setFont:[UIFont fontWithName:self.selectedFont
                                              size:self.selectedFontSize]];
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect newFrame = [textField convertRect:textField.bounds
                                      toView:nil];
    textfield_y = newFrame.origin.y;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.wordingViewTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)changeWords:(id)sender {
    UITextField *tf = (UITextField *)sender;
    [self.wordingWord setText:tf.text];
}

#pragma mark - Rivet View

- (void)didCheckRivet {
    JeansRivet jr = JEANS_RIVET_NOT_SET;
    
    if ([self.rivetCheckBarTextLabel.text isEqualToString:@"Rivet-UBPR-001AC"]) {
        jr = JEANS_RIVET_1;
    } else if ([self.rivetCheckBarTextLabel.text isEqualToString:@"Rivet-UBPR-001CO"]) {
        jr = JEANS_RIVET_2;
    } else if ([self.rivetCheckBarTextLabel.text isEqualToString:@"Rivet-UBPR-001SG"]) {
        jr = JEANS_RIVET_3;
    } else if ([self.rivetCheckBarTextLabel.text isEqualToString:@"Rivet-UBPR-001SV"]) {
        jr = JEANS_RIVET_4;
    }
    
    NSLog(@"%lu", jr);
    
    if (self.currentJeans.jeanRivet == jr) {
        self.currentJeans.jeanRivet = JEANS_RIVET_NOT_SET;
        [self.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        [self.rivetCheckIcon setImage:nil];
    } else {
        self.currentJeans.jeanRivet = jr;
        [self.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
        [self.rivetCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetHardware"
                                                        object:nil];
}

- (void)switchToRivet1 {
    self.rivetThumbnail1.superview.layer.borderWidth = 2.0;
    self.rivetThumbnail2.superview.layer.borderWidth = 0.0;
    self.rivetThumbnail3.superview.layer.borderWidth = 0.0;
    self.rivetThumbnail4.superview.layer.borderWidth = 0.0;
    
    [self.rivetImageView setImage:[UIImage imageNamed:@"UBPR-001AC-L"]];
    if (self.currentJeans.jeanRivet == JEANS_RIVET_1) {
        [self.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    [self.rivetCheckBarTextLabel setText:@"Rivet-UBPR-001AC"];
}

- (void)switchToRivet2 {
    self.rivetThumbnail1.superview.layer.borderWidth = 0.0;
    self.rivetThumbnail2.superview.layer.borderWidth = 2.0;
    self.rivetThumbnail3.superview.layer.borderWidth = 0.0;
    self.rivetThumbnail4.superview.layer.borderWidth = 0.0;
    
    [self.rivetImageView setImage:[UIImage imageNamed:@"UBPR-001CO-L"]];
    if (self.currentJeans.jeanRivet == JEANS_RIVET_2) {
        [self.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    [self.rivetCheckBarTextLabel setText:@"Rivet-UBPR-001CO"];
}

- (void)switchToRivet3 {
    self.rivetThumbnail1.superview.layer.borderWidth = 0.0;
    self.rivetThumbnail2.superview.layer.borderWidth = 0.0;
    self.rivetThumbnail3.superview.layer.borderWidth = 2.0;
    self.rivetThumbnail4.superview.layer.borderWidth = 0.0;
    
    [self.rivetImageView setImage:[UIImage imageNamed:@"UBPR-001SG-L"]];
    if (self.currentJeans.jeanRivet == JEANS_RIVET_3) {
        [self.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    [self.rivetCheckBarTextLabel setText:@"Rivet-UBPR-001SG"];
}

- (void)switchToRivet4 {
    self.rivetThumbnail1.superview.layer.borderWidth = 0.0;
    self.rivetThumbnail2.superview.layer.borderWidth = 0.0;
    self.rivetThumbnail3.superview.layer.borderWidth = 0.0;
    self.rivetThumbnail4.superview.layer.borderWidth = 2.0;
    
    [self.rivetImageView setImage:[UIImage imageNamed:@"UBPR-001SV-L"]];
    if (self.currentJeans.jeanRivet == JEANS_RIVET_4) {
        [self.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.rivetCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    [self.rivetCheckBarTextLabel setText:@"Rivet-UBPR-001SV"];
}

@end
