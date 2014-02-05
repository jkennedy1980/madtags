/******************************************************************************//**
 *
 *  asapi.h  ASAPI framework header file
 *
 *  Created by Richard Andrades on 8/25/13.
 *  Copyright (c) 2013 Alphonso Inc. All rights reserved.
 *
 * Attribution:
 *
 * The iOS framework structure was derived from this project:
 *     https://github.com/jverkoey/iOS-Framework
 * and is used and distributed under this Creative Commons licence:
 *     http://creativecommons.org/licenses/by/3.0/
 *
 *********************************************************************************/



/** The ASAPI framework error codes.
 *
 *  These may be returned by the different methods of the asapi framework, 
 *  or provided as parameters to different completion blocks.
 */
typedef enum {
    ASAPI_SUCCESS                  = 0,   /**< No error */
    ASAPI_ERR_NOT_IMPLEMENTED,            /**< Function not yet implemented */
    ASAPI_ERR_OBSOLETE,                   /**< Function no longer supported */
    ASAPI_ERR_NOT_INITIALIZED,            /**< Framework not initialized */
    ASAPI_ERR_NOT_ACTVE,                  /**< Framework not active */
    ASAPI_ERR_HANDLE_NOT_SUPPORTED,       /**< Don't support that type of handle */
    ASAPI_ERR_AUDIO_INIT_ERR,             /**< Audio subsystem init failed */
    ASAPI_ERR_AUDIO_ERR,                  /**< Audio subsystem failed */
    ASAPI_ERR_SERVER_ACR_ERR,             /**< Server ACR subsystem failed */
    ASAPI_ERR_LOCAL_ACR_ERR,              /**< Local ACR subsystem failed */
    ASAPI_ERR_UNKNOWN,                    /**< Unknown error */
    ASAPI_ERR_MAX                         /**< Number of Errors */
} asapi_err_t;



/** The possible states of the ASAPI framework. 
 *
 *  These are provided as a parameter to the completion block of the init method.
 */
typedef enum {
    ASAPI_STATE_INACTIVE = 0, /**< Not initialized, framework can not be used */
    ASAPI_STATE_ACTIVE,       /**< Framework is initialized, but not currently listening */
    ASAPI_STATE_LISTENING,    /**< Framework is initialized and listening */
} asapi_state_t;



/** This class represents the status of the ASAPI framework.
 *
 *  An object of this class is provided as a parameter to the status completion block for
 *  the init_with_key:and_status_callback:and_result_callback: method. 
 *
 * The properties of the object represents the status of the ASAPI framework and any errors encountered.
 */
@interface asapi_state : NSObject

@property (nonatomic, readonly)         asapi_state_t state; /**< the current state of the ASAPI framework.
                                                              *   Once it is ACTIVE, normal use can begin;
                                                              *   i.e. the start method can be invoked.
                                                              */
@property (nonatomic, readonly)         asapi_err_t err;     /**< an error condition, if not SUCCESS. */
@property (strong, nonatomic, readonly) NSString  *message;  /**< A printable error message */

@end



/** The prototype for the status completion block provided by the
 *  "init_with_key:and_status_callback:and_result_callback:" method.
 */
typedef void(^asapi_status_cb)(asapi_state *state);    /**< the current status of the ASAPI framework */



/** This class represents one or more successful consecutive matches by the ASAPI framework.
 *
 *  An object of this class is provided as a parameter to the results notification block for
 *  the start method. Each object represents a consecutive set (one or more) of the same 
 *  advt.
 *
 *  An array of these objects is returned by the get_id_list method.
 *
 *  The properties of the object describe a successful match or set of matches.
 */
@interface asapi_match : NSObject

@property (strong, nonatomic, readonly) NSString  *tagline; /**< tagline of the advt */
@property (strong, nonatomic, readonly) NSString  *brand;   /**< brand of the advertiser */
@property (strong, nonatomic, readonly) NSDate    *start;   /**< timestamp of the oldest consecutive match in the set */
@property (nonatomic, readonly)         NSInteger hits;     /**< no of consecutive matches for the same advt */

@end



/** The prototype for the match notification completion block provided by the start method.
 *
 *  A valid match is described by the content parameter.
 *
 */
typedef void(^asapi_result_cb)(asapi_match *content);  /**< a successful match */



/** The main class for the ASAPI framework.
 *
 *  This is a singleton class, so only one object of this class exists in the app.
 *  This shared object represents the asapi framework to the rest of the app.
 *
 *  The app needs to create the shared object at the beginning and use it for all
 *  operations on the ASAPI framework.
 *
 */
@interface asapi : NSObject



/** Returns a reference to the singleton object for the asapi class.
 */
+ (asapi *) sharedInstance;



/** The init method of the ASAPI framework.
 *
 *  Starts the initialization in the background and returns SUCCESS.
 *  Returns an error if the initialization can not be started.
 *
 *  The API key is needed to register the app with the Alphonso service.
 *
 *  The status completion callback will be called when the state changes 
 * from INACTIVE to ACTIVE.
 *  The same completion callback will be called at different stages of shutdown
 *  when the cleanup method is invoked. It is also called as a result of state
 *  changes triggered by the start and cancel methods.  If the app does not wish
 *  to keep track of the state of the framework, it can specify nil for the
 *  status completion callback.
 *
 *  The results callback will be called whenever a match is identified.
 *  The results callback can be nil if the app does not need immediate notification,
 *  but only depends on retrieving the history at a later time.
 *
 *
 *  Returns an error if the initialization can not be started.
 */
- (asapi_err_t) init_with_api_key:(const NSString *)api_key         /**< API key for the app, provided by Alphonso. */
              and_status_callback:(asapi_status_cb)progress         /**< optional completion block invoked on
                                                                     *   changes to framework state.
                                                                     */
              and_result_callback:(asapi_result_cb)results;         /**< optional completion block invoked on
                                                                     *   every successful advt match.
                                                                     */



/** Start Identification attempts.
 *
 *  Normally returns SUCCESS and calls the results callback whenever a match is identified.
 *
 *  The session status completion callback will be called when the state changes from ACTIVE to LISTENING.
 */
- (asapi_err_t) start;



/** Returns the version of the ASAPI framework as a string in the format "X.Y (Build w)",
 *  where X is the major number, Y is the minor number and w is the build number.
 *
 *  This instance method can be called even before the framework has been initialized
 *  with the init method.
 */
- (const NSString *) version;



@end
