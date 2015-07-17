//
//  TileLayout.m
//  TileLayout
//
//  Created by Hirad Motamed on 2014-10-23.
//  Copyright (c) 2014 Lighthouse Labs. All rights reserved.
//

#import "TileLayout.h"

@interface TileLayout ()

@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) CGFloat interItemSpacing;

@property (nonatomic, strong) NSMutableDictionary* heightOfColumn;

@property (nonatomic, strong) NSMutableDictionary* layoutAttributesByIndexPath;

@end

@implementation TileLayout

-(void)prepareLayout
{
    self.heightOfColumn = [NSMutableDictionary dictionary];
    self.layoutAttributesByIndexPath = [NSMutableDictionary dictionary];
    
    self.numberOfColumns = 3;
    self.interItemSpacing = 5.0;
    
    CGFloat totalWidth = self.collectionView.bounds.size.width;
    CGFloat totalWidthWithoutPadding = totalWidth - (self.interItemSpacing * (self.numberOfColumns + 1));
    CGFloat columnWidth = rintf(totalWidthWithoutPadding / self.numberOfColumns);
    
    NSInteger currentColumn = 0;
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger currentSection = 0; currentSection < numberOfSections; currentSection++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:currentSection];
        
        for (NSInteger currentItem = 0; currentItem < numberOfItems; currentItem++) {
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:currentItem inSection:currentSection];
            
            UICollectionViewLayoutAttributes* layoutAttributes;
            layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            CGFloat itemHeight = [self.delegate tileLayout:self heightForItemAtIndexPath:indexPath];
            
            CGFloat x = self.interItemSpacing + (currentColumn * (self.interItemSpacing + columnWidth));
            CGFloat y;
            
            NSNumber* columnHeight = self.heightOfColumn[@(currentColumn)];
            if (columnHeight == nil) {
                self.heightOfColumn[@(currentColumn)] = @(itemHeight + self.interItemSpacing);
                y = self.interItemSpacing;
            }
            else
            {
                CGFloat currentHeight = [columnHeight doubleValue];
                y = currentHeight + self.interItemSpacing;
                self.heightOfColumn[@(currentColumn)] = @(y + itemHeight);
            }
            
            layoutAttributes.frame = CGRectMake(x, y, columnWidth, itemHeight);
            NSLog(@"Frame: (%f, %f), (%f, %f)", x, y, columnWidth, itemHeight);
            
            self.layoutAttributesByIndexPath[indexPath] = layoutAttributes;
            
            currentColumn++;
            currentColumn >= self.numberOfColumns ? currentColumn = 0 : 0;
        }
    }
}

-(CGSize)collectionViewContentSize
{
    CGFloat maxHeight = 0.0;
    
    for (NSNumber* column in self.heightOfColumn) {
        CGFloat height = [self.heightOfColumn[column] doubleValue];
        if (height > maxHeight) {
            maxHeight = height;
        }
    }
    
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), maxHeight);
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* relevantAttributes = [NSMutableArray array];
    
    for (NSIndexPath* indexPath in self.layoutAttributesByIndexPath) {
        UICollectionViewLayoutAttributes* attributes = self.layoutAttributesByIndexPath[indexPath];
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [relevantAttributes addObject:attributes];
        }
    }
    
    return [relevantAttributes copy];
}

@end
