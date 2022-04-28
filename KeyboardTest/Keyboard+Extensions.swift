//
//  KeyboardExtensions.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 28.04.22.
//

import UIKit
import Combine

typealias KeyboardButtons = [[ButtonViewModel]]
typealias KeyboardSubject = PassthroughSubject<String, Never>

enum KeyboardSpecialKey: String {
    case shift = "⇧"
    case numbers = "123"
    case letters = "ABC"
    case delete = "⌫"
    case others = "#+="
    case space = "Space"
}

extension UITextDocumentProxy {
    var returnKeyTitle: String {
        switch returnKeyType {
        case .go:
            return "Go";
        case .yahoo, .google, .search:
            return "Search";
        case .join:
            return "Join";
        case .next:
            return "Next";
        case .route:
            return "Route";
        case .send:
            return "Send";
        case .done:
            return "Done";
        case .emergencyCall:
            return "Call";
        case .continue:
            return "Continue";
        default:
            return "return";
        }
    }
}
