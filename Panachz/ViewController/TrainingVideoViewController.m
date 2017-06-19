//
//  TrainingVideoViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 15/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "TrainingVideoViewController.h"
#import "MasterViewController.h"
#import "SlideNavigationController.h"
#import "TrainingVideoCollectionViewCell.h"
#import "UIColor+HexColor.h"

@interface TrainingVideoViewController () <SlideNavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation TrainingVideoViewController

@synthesize designTabButton;
@synthesize customerTabButton;
@synthesize orderTabButton;

@synthesize trainingViewCategorySegmentedControl;
@synthesize videoCollectionView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup navigation bar
    NSString *titleText = @"Training Video";
    UIFont* titleFont = [UIFont fontWithName:@"Roboto" size:16];
    CGSize titleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, 20)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"Roboto" size:16];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = titleText;
    self.navigationItem.titleView = title;
    
    // Setup tab buttons
    self.designTabButton.layer.borderWidth = 1.0;
    self.designTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    self.customerTabButton.layer.borderWidth = 1.0;
    self.customerTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    self.orderTabButton.layer.borderWidth = 1.0;
    self.orderTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    // Setup segmented control
    NSDictionary *normalAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular"
                                                                             size:12.0f],
                                       NSForegroundColorAttributeName: [UIColor colorWithRBGValue:0x444444]};
    [self.trainingViewCategorySegmentedControl setTitleTextAttributes:normalAttributes
                                                             forState:UIControlStateNormal];
    NSDictionary *selectedAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular"
                                                                               size:12.0f],
                                         NSForegroundColorAttributeName: [UIColor colorWithRBGValue:0xffffff]};
    [self.trainingViewCategorySegmentedControl setTitleTextAttributes:selectedAttributes
                                                             forState:UIControlStateSelected];
    
    self.videoCollectionView.delegate = self;
    self.videoCollectionView.dataSource = self;
//    self.videoCollectionView.collectionViewLayout = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Slide Navigation Delegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu {
    return NO;
}

#pragma mark - Tab Button Pressed

- (IBAction)tabButtonPressed:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MasterViewController *vc = (MasterViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    
    if (sender == self.designTabButton) {
        vc.tab = DESIGN_VIEW;
    } else if (sender == self.customerTabButton) {
        vc.tab = CUSTOMER_VIEW;
    } else if (sender == self.orderTabButton) {
        vc.tab = ORDER_VIEW;
    }
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                    withCompletion:nil];
}

#pragma mark - UICollectionview flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(184.0, 200.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(14, 14, 14, 14);
}

#pragma mark - UICollectionview delegate



#pragma mark - UICollectionview datasource



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TrainingVideoCollectionViewCell *cell = (TrainingVideoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TrainingVideoCollectionViewCell"
                                                                                    forIndexPath:indexPath];
    
    NSLog(@"Section: %d, Row: %d", indexPath.section, indexPath.row);

    
    if (indexPath.row == 0)
    {
    
        [cell.thumbnailImageView setImage:[UIImage imageNamed:@"video_preview"]];
        [cell.titleLabel setText:@"App Guide"];
        [cell.dateLabel setText:@"May 15, 2015"];
        [cell.descriptionLabel setText:@"Video to introduce how to use the app"];
    
        cell.thumbnailImageView.userInteractionEnabled = YES;
    
        UITapGestureRecognizer * g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhoto:)];
        [cell.thumbnailImageView addGestureRecognizer:g ];
    
    }
    
    if (indexPath.row == 1)
    {
        
        [cell.thumbnailImageView setImage:[UIImage imageNamed:@"video_preview"]];
        [cell.titleLabel setText:@"Measures Training"];
        [cell.dateLabel setText:@"May 15, 2015"];
        [cell.descriptionLabel setText:@"Video for measures training"];
        
        cell.thumbnailImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhoto2:)];
        [cell.thumbnailImageView addGestureRecognizer:g ];
        
    }
    
    return cell;
}

-(void) clickPhoto:(UITapGestureRecognizer*)recognizer
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.panachz.com/app/training_v1.html"]];
}

-(void) clickPhoto2:(UITapGestureRecognizer*)recognizer
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.panachz.com/app/training_v2.html"]];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

@end
