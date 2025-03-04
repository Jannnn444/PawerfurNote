//
//  Extensions.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import Foundation
import SwiftUI

// MARK: - View

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

