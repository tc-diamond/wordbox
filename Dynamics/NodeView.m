//
//  NodeView.m
//  Dynamics
//
//  Created by Dmitri Doroschuk on 17.04.14.
//  Copyright (c) 2014 Dmitri Doroschuk. All rights reserved.
//

#import "NodeView.h"

static CGSize const kDefaultNodeViewSize = {77, 77};

@interface NodeView ()

@property (copy, nonatomic) NSArray *childViews;
@property (strong, nonatomic) UILabel *label;

@end

@implementation NodeView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureWithPartOfSpeech:NodeViewPartOfSpeechUnknown parrent:self];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureWithPartOfSpeech:NodeViewPartOfSpeechUnknown parrent:self];
    }
    return self;
}

- (instancetype)initWithWord:(NSString*)word partOfSpeech:(NodeViewPartOfSpeech)partOfSpeech parrent:(NodeView *)parrent
{
    if (self = [super init]) {
        BOOL configureSuccess = [self configureWithPartOfSpeech:partOfSpeech parrent:parrent];
        self = configureSuccess ? self : nil;
    }
    return self;
}

- (BOOL)configureWithPartOfSpeech:(NodeViewPartOfSpeech)partOfSpeech parrent:(NodeView*)parrent
{
    if (!parrent) {
        return NO;
    }
    
    self.frame = CGRectMake(parrent.center.x - kDefaultNodeViewSize.width / 2,
                            parrent.center.y - kDefaultNodeViewSize.height / 2,
                            kDefaultNodeViewSize.width,
                            kDefaultNodeViewSize.height);
    self.center = CGPointMake(parrent.center.x + arc4random() % 20 - 10, parrent.center.y + arc4random() % 20 - 10);
    self.layer.cornerRadius = self.bounds.size.width / 2;
    
    self.label = [[UILabel alloc]initWithFrame:self.bounds];
    self.label.textColor = [UIColor whiteColor];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"Some word of war";
    
    [self addSubview:self.label];
    
    UIColor *backgroundColor;
    switch (partOfSpeech) {
        case NodeViewPartOfSpeechNoun:
            backgroundColor = [UIColor blueColor];
            break;
        case NodeViewPartOfSpeechVerb:
            backgroundColor = [UIColor redColor];
            break;
        case NodeViewPartOfSpeechAdverb:
            backgroundColor = [UIColor greenColor];
            break;
        default:
            backgroundColor = [UIColor lightGrayColor];
            break;
    }
    self.backgroundColor = backgroundColor;
    
    return YES;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.center = self.center;
}

#pragma mark - Rooting

- (void)addChild:(NodeView *)child
{
    NSMutableArray *tempoChilds = [NSMutableArray arrayWithArray:self.childViews];
    [tempoChilds addObject:child];
    
    self.childViews = [tempoChilds copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
