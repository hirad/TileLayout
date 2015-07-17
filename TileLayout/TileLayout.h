//
//  TileLayout.h
//  TileLayout
//
//  Created by Hirad Motamed on 2014-10-23.
//  Copyright (c) 2014 Lighthouse Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TileLayout;

@protocol TileLayoutDelegate <NSObject>

-(CGFloat)tileLayout:(TileLayout*)layout heightForItemAtIndexPath:(NSIndexPath*)indexPath;

@end



@interface TileLayout : UICollectionViewLayout

@property (nonatomic, weak) id<TileLayoutDelegate> delegate;

@end
