//
//  CEFoldAnimationController.h
//  LA_SpotLight
//
//  Created by Brandon on 9/22/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

#import "CEReversibleAnimationController.h"

/**
 Animates between the two view controllers using a paper-fold style transition. You can configure the number of folds via the `folds` property.
 */
@interface CEFoldAnimationController : CEReversibleAnimationController

@property (nonatomic) NSUInteger folds;

@end
