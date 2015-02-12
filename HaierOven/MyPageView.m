//
//  MyPageView.m
//  HaierOven
//
//  Created by 刘康 on 14/12/25.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "MyPageView.h"

@interface MyPageView ()

@property (nonatomic,copy) NSString *pattern;

@end

@implementation MyPageView {
    NSMutableDictionary *_images;
    NSMutableArray *_pageViews;
}

@synthesize page = _page;
@synthesize pattern = _pattern;
@synthesize delegate = _delegate;
@synthesize numberOfPages = _numberOfPages;

- (void)commonInit
{
    _page = 0;
    _pattern = @"";
    _images = [NSMutableDictionary dictionary];
    _pageViews = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    UIImage* normalImage = [self createImageWithColor:[UIColor whiteColor]];
    UIImage* hilightedImage = [self createImageWithColor:[UIColor orangeColor]];
    NSString* patternStr;
    for (int loop = 0; loop < numberOfPages; loop++) {
        [self setImage:normalImage highlightedImage:hilightedImage forKey:[NSString stringWithFormat:@"%d", loop]];
        if (loop == 0) {
            patternStr = [NSString stringWithFormat:@"%d", loop];
        } else {
            patternStr = [patternStr stringByAppendingString:[NSString stringWithFormat:@"%d", loop]];
        }
        
    }
    
    self.pattern = patternStr;
}

- (void)setPage:(NSInteger)page
{
    // Skip if delegate said "do not update"
    if ([_delegate respondsToSelector:@selector(pageView:shouldUpdateToPage:)] && ![_delegate pageView:self shouldUpdateToPage:page]) {
        return;
    }
    
    _page = page;
    [self setNeedsLayout];
    
    // Inform delegate of the update
    if ([_delegate respondsToSelector:@selector(pageView:didUpdateToPage:)]) {
        [_delegate pageView:self didUpdateToPage:page];
    }
    
    // Send update notification
    [[NSNotificationCenter defaultCenter] postNotificationName:MYPAGEVIEW_DID_UPDATE_NOTIFICATION object:self];
}

- (NSInteger)numberOfPages
{
    return _pattern.length;
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    self.page = [_pageViews indexOfObject:recognizer.view];
}

- (UIImageView *)imageViewForKey:(NSString *)key
{
    NSDictionary *imageData = [_images objectForKey:key];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[imageData objectForKey:@"normal"] highlightedImage:[imageData objectForKey:@"highlighted"]];
    imageView.frame = CGRectMake(0, 0, 20, 5);
    imageView.userInteractionEnabled = YES;
    
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 2.5;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [imageView addGestureRecognizer:tgr];
    
    return imageView;
}

- (void)layoutSubviews
{
    [_pageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    [_pageViews removeAllObjects];
    
    NSInteger pages = self.numberOfPages;
    CGFloat xOffset = Main_Screen_Width > 320 ? 20 * self.numberOfPages + 50 : 20 * self.numberOfPages + 20;
    for (int i=0; i<pages; i++) {
        NSString *key = [_pattern substringWithRange:NSMakeRange(i, 1)];
        UIImageView *imageView = [self imageViewForKey:key];
        
        CGRect frame = imageView.frame;
        frame.origin.x = xOffset;
        imageView.frame = frame;
        imageView.highlighted = (i == self.page);
        
        [self addSubview:imageView];
        [_pageViews addObject:imageView];
        
        xOffset = xOffset + frame.size.width + 20;
    }

}

- (void)setImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage forKey:(NSString *)key
{
    NSDictionary *imageData = [NSDictionary dictionaryWithObjectsAndKeys:image, @"normal", highlightedImage, @"highlighted", nil];
    [_images setObject:imageData forKey:key];
    [self setNeedsLayout];
}

@end
