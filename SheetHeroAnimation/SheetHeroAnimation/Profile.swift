//
//  Profile.swift
//  SheetHeroAnimation
//
//  Created by JXW003 on 2024/1/18.
//

import SwiftUI

struct Profile: Identifiable {
    var id = UUID().uuidString
    var userName: String
    var profilePicture: String
    var lastMsg: String
    var lastActive: String
}

var profiles = [
    Profile(userName: "Apple", profilePicture: "Pic1", lastMsg: "Hi Apple !!!", lastActive: "10:25 PM"),
    Profile(userName: "Google", profilePicture: "Pic2", lastMsg: "Nothing!", lastActive: "06:25 AM"),
    Profile(userName: "Facebook", profilePicture: "Pic3", lastMsg: "Hi Watching...", lastActive: "10:25 AM"),
    Profile(userName: "Huawei", profilePicture: "Pic4", lastMsg: "404 Page not Found!", lastActive: "10:25 PM"),
    Profile(userName: "Oppo", profilePicture: "Pic5", lastMsg: "Do not Disturb.", lastActive: "10:25 PM")
]

