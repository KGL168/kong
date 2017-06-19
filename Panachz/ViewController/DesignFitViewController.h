//
//  DesignFitViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 10/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignFitViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *genderImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *resetButtonImageView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *rightSegmentedControl;
@property (strong, nonatomic) IBOutlet UIImageView *fitCheckIcon;
@property (strong, nonatomic) IBOutlet UIImageView *riseCheckIcon;
@property (strong, nonatomic) IBOutlet UIImageView *flyCheckIcon;

@property (strong, nonatomic) IBOutlet UIImageView *jeansImageView;
@property (strong, nonatomic) IBOutlet UILabel *jeansFitDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *jeansFitDescriptionLabel2;

@property (strong, nonatomic) IBOutlet UIImageView *fitCheckBarImageView;
@property (strong, nonatomic) IBOutlet UILabel *fitCheckBarTextLabel;

@property (strong, nonatomic) IBOutlet UIImageView *skinnyFitThumbnailImageView;
@property (strong, nonatomic) IBOutlet UIView *skinnyFitThumbnailBorder;
@property (strong, nonatomic) IBOutlet UIImageView *straightFitThumbnailImageView;
@property (strong, nonatomic) IBOutlet UIView *straightFitThumbnailBorder;
@property (strong, nonatomic) IBOutlet UIImageView *bootutFitThumbnailImageView;
@property (strong, nonatomic) IBOutlet UIView *bootcutFitThumbnailBorder;
@property (strong, nonatomic) IBOutlet UIImageView *jeggingsFitThumbnailImageView;
@property (strong, nonatomic) IBOutlet UIView *jegginsFitThumbnail;
@property (strong, nonatomic) IBOutlet UIView *jeggingsFitThumbnailBorder;

@property (strong, nonatomic) IBOutlet UIImageView *riseViewJeansImageView;
@property (strong, nonatomic) IBOutlet UILabel *riseViewJeansDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *riseViewJeansDescriptionLabel2;
@property (strong, nonatomic) IBOutlet UIImageView *riseCheckBarImageView;
@property (strong, nonatomic) IBOutlet UILabel *riseCheckBarTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lowRiseThumbnailImageview;
@property (strong, nonatomic) IBOutlet UIView *lowRiseThumbnailBorder;
@property (strong, nonatomic) IBOutlet UIImageView *midRiseThumbmailImageView;
@property (strong, nonatomic) IBOutlet UIView *midRiseThumbnailBorder;

@property (strong, nonatomic) IBOutlet UIImageView *flyViewJeansImageView;
@property (strong, nonatomic) IBOutlet UILabel *flyViewJeansDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *flyViewJeansDescriptionLabel2;
@property (strong, nonatomic) IBOutlet UIImageView *flyCheckBarImageView;
@property (strong, nonatomic) IBOutlet UILabel *flyCheckBarTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *zipFlyThumbnailImageView;
@property (strong, nonatomic) IBOutlet UIView *zipFlyThumbnailBorder;
@property (strong, nonatomic) IBOutlet UIImageView *buttonFlyThumbnailImageView;
@property (strong, nonatomic) IBOutlet UIView *buttonFlyThumbnailBorder;

@property (strong, nonatomic) IBOutlet UIView *fitView;
@property (strong, nonatomic) IBOutlet UIView *riseView;
@property (strong, nonatomic) IBOutlet UIView *flyView;

- (IBAction)didChangeSegmentControlOption:(id)sender;

@end
