//
//  AccountModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/21/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

+ (JSONKeyMapper *) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    return self;
}

- (NSString *)fullname {
    if (_fullname.length > 0) {
        return _fullname;
    }
    
    if (_lastname.length > 0) {
        return [NSString stringWithFormat:@"%@ %@", _firstname, _lastname];
    } else {
        return [NSString stringWithFormat:@"%@", _firstname];
    }
}
@end
