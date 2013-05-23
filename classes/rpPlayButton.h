//
//  rpPlayButton.h
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "UIButtonPlus.h"

typedef enum {
    RPControlsPlayButtonIconPlay,
    RPControlsPlayButtonIconPause
} RPControlsPlayButtonIcon;

@interface rpPlayButton : UIButtonPlus {
    RPControlsPlayButtonIcon _icon;
}

@property RPControlsPlayButtonIcon icon;

@end
