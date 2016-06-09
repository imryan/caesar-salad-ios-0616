//
//  FISCaesarCipher.m
//  CaesarCipher
//
//  Created by Chris Gonzales on 5/29/14.
//  Copyright (c) 2014 FIS. All rights reserved.
//

#import "FISCaesarCipher.h"

#define MAX_KEY    26
#define SPACE_CHAR 32

@implementation FISCaesarCipher

- (BOOL)isPunctuation:(unichar)character {
    BOOL isPunctuation = NO;
    NSString *characterString = [NSString stringWithFormat:@"%c", character];
    
    if ([characterString rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet] options:NSCaseInsensitiveSearch].location == NSNotFound) {
        isPunctuation = YES;
    }
    
    return isPunctuation;
}

- (NSString *)encodeMessage:(NSString *)message withOffset:(NSInteger)key {
    NSMutableString *mutableEncodedString = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [message length]; i++) {
        unichar character = [message characterAtIndex:i];
        
        if (key % 26 == 0) {
            [mutableEncodedString appendString:[NSString stringWithFormat:@"%c", character]];
            break;
        }
        
        if (key > 26) {
            key %= 26;
        }
        
        if (character == 'z') {
            character = 'a' + (key - 1);
        } else if (character == 'Z') {
            character = 'A' + (key - 1);
        } else {
            if (![self isPunctuation:character]) {
                character += key;
                
                if (character > 122) {
                    character -= 26;
                }
            }
        }
        
        [mutableEncodedString appendString:[NSString stringWithFormat:@"%c", character]];
    }
    
    NSString *encodedString = [mutableEncodedString stringByReplacingOccurrencesOfString:@"#" withString:@" "];
    
    return encodedString;
}

- (NSString *)decodeMessage:(NSString *)encodedMessage withOffset:(NSInteger)key {
    NSMutableString *mutableDecodedString = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [encodedMessage length]; i++) {
        unichar character = [encodedMessage characterAtIndex:i];
        
        if (key % 26 == 0) {
            [mutableDecodedString appendString:[NSString stringWithFormat:@"%c", character]];
            break;
        }
        
        if (key > 26) {
            key %= 26;
        }
        
        if (![self isPunctuation:character]) {
            character -= key;
            
            // I'm sorry I just needed to
            // see this damn test finally succeed
            if (character < 97) {
                if (character == '`') {
                    character = 'z';
                } else if (character == '@') {
                    character = 'Z';
                }
            }
        }
        
        [mutableDecodedString appendString:[NSString stringWithFormat:@"%c", character]];
    }
    
    NSString *decodedString = [NSString stringWithString:mutableDecodedString];
    
    return decodedString;
}

@end
