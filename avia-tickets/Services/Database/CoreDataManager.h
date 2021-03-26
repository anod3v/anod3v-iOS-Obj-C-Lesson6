//
//  CoreDataHelper.h
//  avia-tickets
//
//  Created by Artur Igberdin on 19.03.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FavoriteTicket+CoreDataClass.h"
#import "DataManager.h"

@class Ticket;

@interface CoreDataManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray <FavoriteTicket *> *)favorites;

- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;

@end
