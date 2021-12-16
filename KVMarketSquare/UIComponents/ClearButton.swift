//
//  ClearButton.swift
//  KVMarketSquare
//
//  Created by Kevin Taniguchi on 12/16/21.
//

import MapKit
import Foundation
import SwiftUI

public struct ClearButton: ViewModifier {
    @Binding var text: String
    @Binding var results: [MKLocalSearchCompletion]

    public init(text: Binding<String>, results: Binding<[MKLocalSearchCompletion]>) {
        self._text = text
        self._results = results
    }

    public func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            // onTapGesture is better than a Button here when adding to a form
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.secondary)
                .opacity(text == "" ? 0 : 1)
                .onTapGesture {
                    self.text = ""
                    self.results = []
                }
        }
    }
}
