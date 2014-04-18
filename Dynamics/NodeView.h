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

@interface NodeView : UIView

@property (assign, nonatomic) NodeViewPartOfSpeech partOfSpeech;
@property (copy, nonatomic, readonly) NSArray *childViews;
@property (strong, nonatomic) NodeView *parrentView;

- (instancetype)initWithWord:(NSString*)word partOfSpeech:(NodeViewPartOfSpeech)partOfSpeech parrent:(NodeView*)parrent;
- (void)addChild:(NodeView*)child;

@end