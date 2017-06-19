//
//  DesignBackPatchViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 22/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "DesignBackPatchViewController.h"
#import "DesignHardwareChooseFontSizeViewController.h"
#import "DesignHardwareChooseFontTypeViewController.h"
#import "DesignBackPatchChooseFontColorViewController.h"
#import "Jeans.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexColor.h"
#import "UIImage+CaptureView.h"

#define WHITE_CHECK_ICON @"ic_check_circle_white_36dp"
#define GREY_CHECK_ICON @"ic_check_circle_grey600_36dp"

@interface DesignBackPatchViewController () <UITextFieldDelegate, FontTypeSelectedDelegate, SelectFontSizeDelegate, ChooseFontColorDelegate> {
    /* keyboard auto go up */
    CGFloat currentKeyboardHeight;
    CGFloat deltaHeight;
    CGFloat moved;
    CGFloat textfield_y;
    bool animated;
}
@property (nonatomic, strong) Jeans *currentJeans;
@property (nonatomic) BOOL wordLock;
@property (nonatomic, strong) NSString *selectedFontType;
@property (nonatomic) NSUInteger selectedFontSize;
@property (nonatomic, strong) NSString *selectedFontColor;
@end

@implementation DesignBackPatchViewController

@synthesize resetBackPatchButton;
@synthesize rightSegmentedControl;

@synthesize backPatchView;
@synthesize backPatchImageView;
@synthesize backPatchCheckBarButton;
@synthesize backPatchCheckBarTextLabel;
@synthesize backPatchThumbnail1;
@synthesize backPatchThumbnail2;
@synthesize backPatchThumbnail3;
@synthesize backPatchThumbnail4;

@synthesize wordLock;
@synthesize wordingView;
@synthesize wordingWordView;
@synthesize wordingBar;
@synthesize wordingViewWord;
@synthesize wordingFontColorLabel;
@synthesize wordingFontSizeLabel;
@synthesize wordingFontTypeLabel;
@synthesize wordingImageView;
@synthesize wordingLockButton;
@synthesize wordingTextField;

@synthesize bpView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup reset button
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(resetBackPatch)];
    [tap setNumberOfTapsRequired:1];
    [self.resetBackPatchButton setUserInteractionEnabled:YES];
    [self.resetBackPatchButton addGestureRecognizer:tap];
    
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
    
    /* Setup Back Patch view */
    
    // Check Bar
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didCheckBackPatch)];
    [tap setNumberOfTapsRequired:1];
    [self.backPatchCheckBarButton setUserInteractionEnabled:YES];
    [self.backPatchCheckBarButton addGestureRecognizer:tap];
    
    // Thumbnail
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToBackPatch1)];
    [tap setNumberOfTapsRequired:1];
    [self.backPatchThumbnail1 setUserInteractionEnabled:YES];
    [self.backPatchThumbnail1 addGestureRecognizer:tap];
    self.backPatchThumbnail1.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.backPatchThumbnail1.superview.layer.borderWidth = 0.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToBackPatch2)];
    [tap setNumberOfTapsRequired:1];
    [self.backPatchThumbnail2 setUserInteractionEnabled:YES];
    [self.backPatchThumbnail2 addGestureRecognizer:tap];
    self.backPatchThumbnail2.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.backPatchThumbnail2.superview.layer.borderWidth = 0.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToBackPatch3)];
    [tap setNumberOfTapsRequired:1];
    [self.backPatchThumbnail3 setUserInteractionEnabled:YES];
    [self.backPatchThumbnail3 addGestureRecognizer:tap];
    self.backPatchThumbnail3.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.backPatchThumbnail3.superview.layer.borderWidth = 0.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToBackPatch4)];
    [tap setNumberOfTapsRequired:1];
    [self.backPatchThumbnail4 setUserInteractionEnabled:YES];
    [self.backPatchThumbnail4 addGestureRecognizer:tap];
    self.backPatchThumbnail4.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.backPatchThumbnail4.superview.layer.borderWidth = 0.0;
    /* End setup back patch view */
    
    /* Setup wording view */
    self.selectedFontColor = @"Black";
    self.selectedFontSize = 72;
    self.selectedFontType = @"Arial";
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(moveWord:)];
    [self.wordingWordView setUserInteractionEnabled:YES];
    [self.wordingWordView addGestureRecognizer:pan];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(openChooseFontTypeModal)];
    [tap setNumberOfTapsRequired:1];
    [self.wordingFontTypeLabel setUserInteractionEnabled:YES];
    [self.wordingFontTypeLabel addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(openChooseFontSizeModal)];
    [self.wordingFontSizeLabel setUserInteractionEnabled:YES];
    [self.wordingFontSizeLabel addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(openChooseFontColor)];
    [self.wordingFontColorLabel setUserInteractionEnabled:YES];
    [self.wordingFontColorLabel addGestureRecognizer:tap];
    
    self.wordingTextField.delegate = self;
    
    /* End Setup wording view */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
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


#pragma mark - NSNotification

- (void)didSelectGender:(NSNotification *)notifiction {
    self.currentJeans = [notifiction.userInfo objectForKey:@"Jeans"];
    
}

- (void)resetJeans {
    self.currentJeans.jeanBackPatchType = JEANS_BACK_PATCH_NOT_SET;
    self.currentJeans.jeanBackPatchText = nil;
    self.currentJeans.jeanBackPatchFontColor = @"Black";
    self.currentJeans.jeanBackPatchFontSize = 72;
    self.currentJeans.jeanBackPatchFontType = @"Arial";
    
    self.rightSegmentedControl.selectedSegmentIndex = 0;
    self.backPatchView.hidden = NO;
    self.wordingView.hidden = YES;
    
    [self.backPatchCheckIcon setImage:nil];
    [self.wordingCheckIcon setImage:nil];
    
    [self switchToBackPatch1];
    [self.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    
    self.wordLock = NO;
    [self.wordingViewWord setText:@""];
    self.wordingBar.hidden = NO;
    [self.wordingWordView setUserInteractionEnabled:YES];
    [self.wordingLockButton setImage:[UIImage imageNamed:@"circle_unlocked"]
                                forState:UIControlStateNormal];
    self.selectedFontType = @"Arial";
    [self.wordingFontTypeLabel setText:@"Arial"];
    [self.wordingFontTypeLabel setUserInteractionEnabled:YES];
    self.selectedFontSize = 72;
    [self.wordingFontSizeLabel setText:@"72"];
    [self.wordingFontSizeLabel setUserInteractionEnabled:YES];
    self.selectedFontColor = @"Black";
    [self.wordingFontColorLabel setText:@"Black"];
    [self.wordingFontColorLabel setUserInteractionEnabled:YES];
    self.wordingTextField.enabled = YES;
    [self.wordingTextField setText:@""];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetBackPatch"
                                                        object:nil];
}

#pragma mark - Tap gesture

- (void)resetBackPatch {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Waring"
                                                                   message:@"Are you sure to reset Back Patch?" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction *action) {
                                                    weakSelf.currentJeans.jeanBackPatchType = JEANS_BACK_PATCH_NOT_SET;
                                                    weakSelf.currentJeans.jeanBackPatchText = nil;
                                                    weakSelf.currentJeans.jeanBackPatchFontColor = @"Black";
                                                    weakSelf.currentJeans.jeanBackPatchFontSize = 72;
                                                    weakSelf.currentJeans.jeanBackPatchFontType = @"Arial";
                                                    
                                                    weakSelf.rightSegmentedControl.selectedSegmentIndex = 0;
                                                    weakSelf.backPatchView.hidden = NO;
                                                    weakSelf.wordingView.hidden = YES;
                                                    
                                                    [weakSelf.backPatchCheckIcon setImage:nil];
                                                    [weakSelf.wordingCheckIcon setImage:nil];
                                                    
                                                    [weakSelf switchToBackPatch1];
                                                    [weakSelf.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
                                                    
                                                    weakSelf.wordLock = NO;
                                                    [weakSelf.wordingViewWord setText:@""];
                                                    weakSelf.wordingBar.hidden = NO;
                                                    [weakSelf.wordingWordView setUserInteractionEnabled:YES];
                                                    [weakSelf.wordingLockButton setImage:[UIImage imageNamed:@"circle_unlocked"]
                                                                                forState:UIControlStateNormal];
                                                    weakSelf.selectedFontType = @"Arial";
                                                    [weakSelf.wordingFontTypeLabel setText:@"Arial"];
                                                    [weakSelf.wordingFontTypeLabel setUserInteractionEnabled:YES];
                                                    weakSelf.selectedFontSize = 72;
                                                    [weakSelf.wordingFontSizeLabel setText:@"72"];
                                                    [weakSelf.wordingFontSizeLabel setUserInteractionEnabled:YES];
                                                    weakSelf.selectedFontColor = @"Black";
                                                    [weakSelf.wordingFontColorLabel setText:@"Black"];
                                                    [weakSelf.wordingFontColorLabel setUserInteractionEnabled:YES];
                                                    weakSelf.wordingTextField.enabled = YES;
                                                    [weakSelf.wordingTextField setText:@""];
                                                    
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetBackPatch"
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

- (IBAction)rightSegmentedControlDidChangeValue:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        if (self.currentJeans.jeanBackPatchType == JEANS_BACK_PATCH_NOT_SET) {
            [self.backPatchCheckIcon setImage:nil];
        } else {
            [self.backPatchCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
        }
        
        self.backPatchView.hidden = NO;
        self.wordingView.hidden = YES;
    } else {
        if (self.currentJeans.jeanBackPatchType == JEANS_BACK_PATCH_NOT_SET) {
            [self.backPatchCheckIcon setImage:nil];
        } else {
            [self.backPatchCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
        }
        
        self.backPatchView.hidden = YES;
        self.wordingView.hidden = NO;
    }
}

#pragma mark - Back Patch view

- (void)didCheckBackPatch {
    JeansBackPatchType jbpt= JEANS_BACK_PATCH_NOT_SET;
    UIImage *bppImage = nil;
    if ([self.backPatchCheckBarTextLabel.text isEqualToString:@"White color coated genuine bufflo leather"]) {
        jbpt = JEANS_BACK_PATCH_WHITE_COLOR_COATED_GENUINE_BUFFLO_LEATHER;
        [self.wordingImageView setImage:[UIImage imageNamed:@"UBLP-001F"]];
        bppImage = [UIImage imageNamed:@"UBLP-001F"];
    } else if ([self.backPatchCheckBarTextLabel.text isEqualToString:@"Genuine bull Leather"]) {
        jbpt = JEANS_BACK_PATCH_GENUINE_BULL_LEATHER;
        [self.wordingImageView setImage:[UIImage imageNamed:@"UBLP-002F"]];
        bppImage = [UIImage imageNamed:@"UBLP-002F"];
    } else if ([self.backPatchCheckBarTextLabel.text isEqualToString:@"Black color coated genuine bufflo leather"]) {
        jbpt = JEANS_BACK_PATCH_BLACK_COLOR_COATED_GENUINE_BUFFLO_LEATHER;
        [self.wordingImageView setImage:[UIImage imageNamed:@"UBLP-003F"]];
        bppImage = [UIImage imageNamed:@"UBLP-003F"];
    } else if ([self.backPatchCheckBarTextLabel.text isEqualToString:@"Genuine suede leather"]) {
        jbpt = JEANS_BACK_PATCH_GENUINE_SUEDE_LEATHER;
        [self.wordingImageView setImage:[UIImage imageNamed:@"UBLP-004F"]];
        bppImage = [UIImage imageNamed:@"UBLP-004F"];
    }
    //self.bpView = self.wordingi
    if (self.currentJeans.jeanBackPatchType == jbpt) {
        self.currentJeans.jeanBackPatchType = JEANS_BACK_PATCH_NOT_SET;
        [self.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        [self.backPatchCheckIcon setImage:nil];
        [self.wordingImageView setImage:[UIImage imageNamed:@"UBLP-001F"]];
    } else {
        self.currentJeans.jeanBackPatchType = jbpt;
        [self.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
        [self.backPatchCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
        
        BOOL b = self.wordingBar.hidden;
        self.wordingBar.hidden = YES;
        //self.bpView
        //self.currentJeans.backPatchImage = [UIImage imageWithView:self.bpView];
        self.currentJeans.backPatchImage = bppImage;
        self.wordingBar.hidden = b;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetBackPatch"
                                                        object:nil];
}

- (void)switchToBackPatch1 {
    self.backPatchThumbnail1.superview.layer.borderWidth = 2.0;
    self.backPatchThumbnail2.superview.layer.borderWidth = 0.0;
    self.backPatchThumbnail3.superview.layer.borderWidth = 0.0;
    self.backPatchThumbnail4.superview.layer.borderWidth = 0.0;
    
    [self.backPatchImageView setImage:[UIImage imageNamed:@"UBLP-001F"]];
    if (self.currentJeans.jeanBackPatchType == JEANS_BACK_PATCH_WHITE_COLOR_COATED_GENUINE_BUFFLO_LEATHER) {
        [self.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    [self.backPatchCheckBarTextLabel setText:@"White color coated genuine bufflo leather"];
}

- (void)switchToBackPatch2 {
    self.backPatchThumbnail1.superview.layer.borderWidth = 0.0;
    self.backPatchThumbnail2.superview.layer.borderWidth = 2.0;
    self.backPatchThumbnail3.superview.layer.borderWidth = 0.0;
    self.backPatchThumbnail4.superview.layer.borderWidth = 0.0;
    
    [self.backPatchImageView setImage:[UIImage imageNamed:@"UBLP-002F"]];
    if (self.currentJeans.jeanBackPatchType == JEANS_BACK_PATCH_GENUINE_BULL_LEATHER) {
        [self.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    [self.backPatchCheckBarTextLabel setText:@"Genuine bull Leather"];
}

- (void)switchToBackPatch3 {
    self.backPatchThumbnail1.superview.layer.borderWidth = 0.0;
    self.backPatchThumbnail2.superview.layer.borderWidth = 0.0;
    self.backPatchThumbnail3.superview.layer.borderWidth = 2.0;
    self.backPatchThumbnail4.superview.layer.borderWidth = 0.0;
    
    [self.backPatchImageView setImage:[UIImage imageNamed:@"UBLP-003F"]];
    if (self.currentJeans.jeanBackPatchType == JEANS_BACK_PATCH_BLACK_COLOR_COATED_GENUINE_BUFFLO_LEATHER) {
        [self.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    [self.backPatchCheckBarTextLabel setText:@"Black color coated genuine bufflo leather"];
}

- (void)switchToBackPatch4 {
    self.backPatchThumbnail1.superview.layer.borderWidth = 0.0;
    self.backPatchThumbnail2.superview.layer.borderWidth = 0.0;
    self.backPatchThumbnail3.superview.layer.borderWidth = 0.0;
    self.backPatchThumbnail4.superview.layer.borderWidth = 2.0;
    
    [self.backPatchImageView setImage:[UIImage imageNamed:@"UBLP-004F"]];
    if (self.currentJeans.jeanBackPatchType == JEANS_BACK_PATCH_GENUINE_SUEDE_LEATHER) {
        [self.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.backPatchCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    [self.backPatchCheckBarTextLabel setText:@"Genuine suede leather"];
}

#pragma mark - Wording View

- (void)moveWord:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint trans = [recognizer translationInView:recognizer.view];
        CGRect rect = recognizer.view.frame;
        rect.origin.x += trans.x;
        rect.origin.y += trans.y;
        
        if (CGRectContainsRect(recognizer.view.superview.bounds, rect)) {
            recognizer.view.frame = rect;
        }
        
        [recognizer setTranslation:CGPointZero
                     inView:recognizer.view.superview];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChooseFontSize"]) {
        DesignHardwareChooseFontSizeViewController *vc = (DesignHardwareChooseFontSizeViewController *)segue.destinationViewController;
        vc.selectFontSizeDelegate = self;
    } else if ([segue.identifier isEqualToString:@"ChooseFontType"]) {
        DesignHardwareChooseFontTypeViewController *vc = (DesignHardwareChooseFontTypeViewController *)segue.destinationViewController;
        vc.fontTyleSelectedDelegate = self;
    } else if ([segue.identifier isEqualToString:@"ChooseFontColor"]) {
        DesignBackPatchChooseFontColorViewController *vc = (DesignBackPatchChooseFontColorViewController *)segue.destinationViewController;
        vc.chooseFontColorDelegate = self;
    }
}

- (void)openChooseFontTypeModal {
    [self performSegueWithIdentifier:@"ChooseFontType"
                              sender:self];
}

- (void)openChooseFontSizeModal {
    [self performSegueWithIdentifier:@"ChooseFontSize"
                              sender:self];
}

- (void)openChooseFontColor {
    [self performSegueWithIdentifier:@"ChooseFontColor"
                              sender:nil];
}

- (void)didSelectedFontSize:(NSUInteger)fontSize {
    self.selectedFontSize = fontSize;
    [self.wordingFontSizeLabel setText:[NSString stringWithFormat:@"%lu", fontSize]];
    [self updateWordingStyle];
}

- (void)didSelectFontType:(NSString *)fontName {
    self.selectedFontType = fontName;
    [self.wordingFontTypeLabel setText:fontName];
    [self updateWordingStyle];
}

- (void)didChooseFontColor:(NSString *)fontColor {
    self.selectedFontColor = fontColor;
    [self.wordingFontColorLabel setText:fontColor];
    [self updateWordingStyle];
}

- (void)updateWordingStyle {
    UIFont *font = [UIFont fontWithName:self.selectedFontType
                                   size:self.selectedFontSize];
    [self.wordingViewWord setFont:font];
    
    UIColor *fontColor;
    if ([self.selectedFontColor isEqualToString:@"Black"]) {
        fontColor = [UIColor blackColor];
    } else if ([self.selectedFontColor isEqualToString:@"White"]) {
        fontColor = [UIColor whiteColor];
    } else if ([self.selectedFontColor isEqualToString:@"Red"]) {
        fontColor = [UIColor redColor];
    } else if ([self.selectedFontColor isEqualToString:@"Blue"]) {
        fontColor = [UIColor blueColor];
    } else if ([self.selectedFontColor isEqualToString:@"Green"]) {
        fontColor = [UIColor greenColor];
    } else if ([self.selectedFontColor isEqualToString:@"Yellow"]) {
        fontColor = [UIColor yellowColor];
    } else {
        fontColor = [UIColor colorWithRBGValue:0xcccccc];
    }
    
    [self.wordingViewWord setTextColor:fontColor];
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect newFrame = [textField convertRect:textField.bounds
                                      toView:nil];
    textfield_y = newFrame.origin.y;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.wordingTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)changeWords:(id)sender {
    UITextField *tf = (UITextField *)sender;
    [self.wordingViewWord setText:tf.text];
}

- (IBAction)wordLocks:(id)sender {
    self.wordLock = !self.wordLock;
    
    if (self.wordLock) {
        [self.wordingCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
        [self.wordingLockButton setImage:[UIImage imageNamed:@"circle_locked"]
                                forState:UIControlStateNormal];
        [self.wordingFontColorLabel setUserInteractionEnabled:NO];
        [self.wordingFontSizeLabel setUserInteractionEnabled:NO];
        [self.wordingFontTypeLabel setUserInteractionEnabled:NO];
        self.wordingTextField.enabled = NO;
        [self.wordingWordView setUserInteractionEnabled:NO];
        self.wordingBar.hidden = YES;
        
        self.currentJeans.jeanBackPatchFontColor = self.selectedFontColor;
        self.currentJeans.jeanBackPatchFontSize = self.selectedFontSize;
        self.currentJeans.jeanBackPatchFontType = self.selectedFontType;
        self.currentJeans.jeanBackPatchText = self.wordingTextField.text;
        
        BOOL b = self.wordingBar.hidden;
        self.wordingBar.hidden = YES;
        self.currentJeans.backPatchImage = [UIImage imageWithView:self.bpView];
        self.wordingBar.hidden = b;
    } else {
        [self.wordingCheckIcon setImage:nil];
        [self.wordingLockButton setImage:[UIImage imageNamed:@"circle_unlocked"]
                                forState:UIControlStateNormal];
        [self.wordingFontColorLabel setUserInteractionEnabled:YES];
        [self.wordingFontSizeLabel setUserInteractionEnabled:YES];
        [self.wordingFontTypeLabel setUserInteractionEnabled:YES];
        self.wordingTextField.enabled = YES;
        [self.wordingWordView setUserInteractionEnabled:YES];
        self.wordingBar.hidden = NO;
        
        self.currentJeans.jeanBackPatchText = nil;
    }
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetBackPatch"
                                                        object:nil];
}

@end
