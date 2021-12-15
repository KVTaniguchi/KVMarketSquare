//
//  HolidayWrapperView.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-15.
//

import SwiftUI

struct HolidayWrapperView<Content>: View where Content : View {
    @EnvironmentObject private var appData: AppData
    @Environment(\.colorScheme) var colorScheme

    var content: () -> Content
    
    var body: some View {
        ZStack {
            if colorScheme == .dark && appData.isLettingItSnow {
                SnowfallView()
            }
            self.content()
        }
    }
}

