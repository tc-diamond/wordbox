//
//  NodeView.h
//  Dynamics
//
//  Created by Dmitri Doroschuk on 17.04.14.
//  Copyright (c) 2014 Dmitri Doroschuk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NodeViewPartOfSpeech){
    NodeViewPartOfSpeechNoun = 0,
    NodeViewPartOfSpeechVerb,
    NodeViewPartOfSpeechAdverb,
    NodeViewPartOfSpeechUnknown
};

@class NodeView;
@protocol NodeViewDelegate <NSObject>

- (void)nodeViewDidTap:(NodeView*)nodeView;
- (void)nodeViewDidLongPressed:(NodeView*)nodeView;

@end

@interface NodeView : UIView

@property (weak, nonatomic) id<NodeViewDelegate> delegate;

@property (copy, nonatomic, readonly) NSArray *childViews;
@property (strong, nonatomic) NodeView *parrentView;
@property (assign, nonatomic) NodeViewPartOfSpeech partOfSpeech;
@property (assign, nonatomic) BOOL selected;

- (instancetype)initWithWord:(NSString*)word partOfSpeech:(NodeViewPartOfSpeech)partOfSpeech parrent:(NodeView*)parrent;
- (void)addChild:(NodeView*)child;

@end