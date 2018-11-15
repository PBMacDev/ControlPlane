//
//  WiFiEvidenceSource2.m
//  ControlPlaneX
//
//  Created by Dustin Rue on 7/10/11.
//  Copyright 2011 Dustin Rue. All rights reserved.
//
//  Bug fixes and improvements by Vladimir Beloborodov (VladimirTechMan) in Jul 2013.
//

#import <CoreWLAN/CoreWLAN.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "CoreWLANEvidenceSource.h"
#import "DSLogger.h"

@interface WiFiEvidenceSourceCoreWLAN () {
@private
}

@property BOOL currentNetworkIsSecure;
@property (atomic, retain, readwrite) NSDictionary *networkSSIDs;
@property (atomic, retain, readwrite) NSString *interfaceBSDName;
@property (atomic) BOOL linkActive;

- (void)clearCollectedData;

- (void)collectDataIfNeeded;
- (void)updateCollectedDataFromScanResults:(NSSet*)networks;
- (void)updateCollectedSecurity;

@end

@implementation WiFiEvidenceSourceCoreWLAN

- (id)init {
    self = [super init];
    if (!self) {
		return nil;
    }
    
    [[CWWiFiClient sharedWiFiClient] setDelegate:self];
    [self setDataCollected:YES]; //just in case. new implementation does not depend on this parameter.
    
    return self;
}

+ (BOOL) isEvidenceSourceApplicableToSystem {
    return YES;
}

- (void)collectDataIfNeeded
{
    if (self.networkSSIDs != nil) {
        return;
    }
    
    CWInterface* defaultInterface = [[CWWiFiClient sharedWiFiClient] interface];
    self.interfaceBSDName = [defaultInterface interfaceName];
    NSSet *foundNetworks = [defaultInterface cachedScanResults];
    [self updateCollectedDataFromScanResults:foundNetworks];
    [self updateCollectedSecurity];
}

- (void)updateCollectedSecurity
{
    CWInterface* currentInterface = [[CWWiFiClient sharedWiFiClient] interface];
    self.currentNetworkIsSecure = ([currentInterface security] == kCWSecurityNone) ? NO : YES;
}

- (void)updateCollectedDataFromScanResults:(NSSet*)networks
{
    NSMutableDictionary *ssids = [NSMutableDictionary dictionaryWithCapacity:([networks count] + 1)];
    
    [networks enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [ssids setObject:[obj bssid] forKey:[obj ssid]];
    }];
    
    self.networkSSIDs = [NSDictionary dictionaryWithDictionary:ssids];
}

- (void)start {
    
    if (running) {
        return;
    }
    
    [self collectDataIfNeeded];
    [self updateCollectedSecurity];
    
    CWWiFiClient *sharedWiFiClient = [CWWiFiClient sharedWiFiClient];
    [sharedWiFiClient startMonitoringEventWithType:(CWEventTypeScanCacheUpdated) error:nil];
//    [sharedWiFiClient startMonitoringEventWithType:(CWEventTypeBSSIDDidChange) error:nil];
    [sharedWiFiClient startMonitoringEventWithType:(CWEventTypeLinkDidChange) error:nil];
//    [sharedWiFiClient startMonitoringEventWithType:(CWEventTypeSSIDDidChange) error:nil];

    running = YES;
}

- (void)stop {
    if (running) {
        [[CWWiFiClient sharedWiFiClient] stopMonitoringAllEventsAndReturnError:nil];
        [self clearCollectedData];
        running = NO;
    }
}

- (NSString *)description {
    return NSLocalizedString(@"Create rules based on what WiFi networks are available or connected to.", @"");
}

- (void)clearCollectedData {
    self.networkSSIDs  = nil;
    self.currentNetworkIsSecure = YES;
}

- (NSString *)name {
	return @"WiFi";
}

- (NSArray *)typesOfRulesMatched {
	return @[ @"WiFi BSSID", @"WiFi SSID", @"WiFi Security" ];
}

- (BOOL)doesRuleMatch:(NSDictionary *)rule {
	NSString *param = rule[@"parameter"];
    
    if ([rule[@"type"] isEqualToString:@"WiFi BSSID"]) {
        return [[self.networkSSIDs allValues] containsObject:param];
    }
    
    if ([rule[@"type"] isEqualToString:@"WiFi Security"]) {
        BOOL isSecure = self.currentNetworkIsSecure;
        return ([param isEqualToString:@"Secure"]) ? (isSecure) : (!isSecure);
    }
    
    return (self.networkSSIDs[param] != nil);
}

- (NSString *)getSuggestionLeadText:(NSString *)type {
	if ([type isEqualToString:@"WiFi BSSID"]) {
		return NSLocalizedString(@"A WiFi access point with a BSSID of", @"In rule-adding dialog");
    }
    
    if ([type isEqualToString:@"WiFi Security"]) {
        return NSLocalizedString(@"Current WiFi network is:", @"In rule-adding dialog");
    }

    return NSLocalizedString(@"A WiFi access point with an SSID of", @"In rule-adding dialog");
}

- (NSArray *)getSuggestions {

    [self collectDataIfNeeded];
    NSDictionary *networkSSIDs = self.networkSSIDs;
    NSArray *sortedSSIDs = [[networkSSIDs allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

	NSMutableArray *arr = [NSMutableArray arrayWithCapacity:(2 * [networkSSIDs count])];

    for (NSString *ssid in sortedSSIDs) {
		NSString *mac = networkSSIDs[ssid];
		[arr addObject: @{  @"type": @"WiFi BSSID",
                            @"parameter": mac,
                            @"description": [NSString stringWithFormat:@"%@ (%@)", mac, ssid] }];
		[arr addObject: @{  @"type": @"WiFi SSID",
                            @"parameter": ssid,
                            @"description": ssid }];
    }
    
    [arr addObject: @{  @"type": @"WiFi Security",
                        @"parameter": @"Secure",
                        @"description": @"Secure"}];
    [arr addObject: @{  @"type": @"WiFi Security",
                        @"parameter": @"Not Secure",
                        @"description": @"Not Secure"}];
     

	return arr;
}

- (NSString *)friendlyName {
    return NSLocalizedString(@"Nearby WiFi Network", @"");
}

#pragma mark CWEventDelegate delegate

- (void)scanCacheUpdatedForWiFiInterfaceWithName:(NSString *)interfaceName
{
    if ([self.interfaceBSDName isEqualToString:interfaceName]) {
        NSSet* scanCache = [[[CWWiFiClient sharedWiFiClient] interfaceWithName:interfaceName] cachedScanResults];
        [self updateCollectedDataFromScanResults:scanCache];
    }
}

- (void)clientConnectionInvalidated
{
    [self clearCollectedData];
}

- (void)linkDidChangeForWiFiInterfaceWithName:(NSString *)interfaceName
{
    [self updateCollectedSecurity];
}

//- (void)ssidDidChangeForWiFiInterfaceWithName:(NSString *)interfaceName
//{
//    [self updateCollectedSecurity];
//}

@end
