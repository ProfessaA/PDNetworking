#import <Foundation/Foundation.h>


@class KSPromise;


@protocol PDDeserializer <NSObject>

- (id)deserialize:(id)foundationCollection error:(NSError * __autoreleasing*)error;

@end
