


/*
 * Copyright (c) 2012 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */


// Public header
// audited

#import "GnMetadataObject.h"

/** @addtogroup metadata Metadata (General)
 *  General Metadata Classes
 *  @{
 */

@interface GnExternalID : GnMetadataObject

@property (nonatomic, readonly)     NSString*       source;
@property (nonatomic, readonly)     NSString*       type;
@property (nonatomic, readonly)     NSString*       value;
@end
/** @} */ // end of Metadata
