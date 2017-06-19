//
//  TrainingVideoCollectionViewCell.h
//  Panachz
//
//  Created by YinYin Chiu on 15/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingVideoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;


@end
