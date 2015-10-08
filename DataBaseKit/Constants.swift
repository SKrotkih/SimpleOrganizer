//
//  Constants.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 9/8/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public let AppGroupsId = "group.skappleid.SOWidget"
public let WidgetUrlScheme = "widget"

public struct DefaultsDataKeys {
    static let SODataBaseTypeKey = "DataBaseType"
    static let SOEnableiCloudForCoreDataKey = "EnableiCloudForCoreData"
}

public struct WidgetDataKeys {
    static let KeyInURLAsSwitchDataBase = "switchdbto."
}

public let KeyInURLAsTaskId = "taskid."

// Facebook
// https://developers.facebook.com/apps/538129673003368/settings/
public struct FacebookDataKeys {
    static let FacebookAppId = "538129673003368"
}

// Parse.com
// https://www.parse.com/apps/swiftorganizer
public struct ParseDataKeys {
    static let ApplicationId: String = "opRyZz4AOrPBTv2RgKX0s64PNKBS2hT38qeIVQcF"
    static let ClientKey: String = "73VaFVVZm2Q8CQp6nYHsSzFcrj2quw7INLtI7KYG"
}

// Twitter
// https://apps.twitter.com/app/4213797/settings
public struct TwitterDataKeys {
    static let ConsumerKey: String = "fDb5IMZFmzkiuPwJ4qRIbg"
    static let ConsumerSecret: String = "ZtZaP2N7IXjbBeDTcZ6eapy8gQ2kvuKtK5Eo3FVPv8Q"
}
