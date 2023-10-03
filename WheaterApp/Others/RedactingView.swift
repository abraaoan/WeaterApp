//
//  RedactingView.swift
//  WheaterApp
//
//  Created by Abraao Nascimento on 27/09/2023.
//

import Foundation
import SwiftUI

struct RedactingView<Input: View, Output: View>: View {
    var content: Input
    var modifier: (Input) -> Output

    @Environment(\.redactionReasons) private var reasons

    var body: some View {
        if reasons.isEmpty {
            content
        } else {
            modifier(content)
        }
    }
}

extension View {
    func whenRedacted<T: View>(
        apply modifier: @escaping (Self) -> T
    ) -> some View {
        RedactingView(content: self, modifier: modifier)
    }
}
