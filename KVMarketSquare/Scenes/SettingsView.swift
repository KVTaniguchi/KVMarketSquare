//
//  SettingsView.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-13.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appData: AppData
    var utilities = Utilities()
    
    var body: some View {
        List {
            Section(header: Text("Theme")) {
                SettingsSectionView(title: "System", description: "Use system settings") {
                    Toggle(isOn: $appData.isAutomaticColorScheme) {}
                    .onChange(of: appData.isAutomaticColorScheme) { _ in
                        setUserInterfaceStyle()
                    }
                    .tint(.green)
                }
                
                if !appData.isAutomaticColorScheme {
                    SettingsSectionView(title: "Enable Dark Mode", description: "Use dark interface") {
                        Toggle(isOn: $appData.isDarkMode) {}
                        .onChange(of: appData.isDarkMode) { _ in
                            setUserInterfaceStyle()
                        }
                        .tint(.green)
                    }
                }
                
            }
        }
        .onChange(of: appData.userInterfaceStyle, perform: { value in
            utilities.overrideDisplayMode(appData.userInterfaceStyle)
        })
    }
    
    private func setUserInterfaceStyle() {
        if appData.isAutomaticColorScheme {
            appData.userInterfaceStyle = UserInterfaceStyle.system
        } else {
            if appData.isDarkMode {
                appData.userInterfaceStyle = UserInterfaceStyle.dark
            } else {
                appData.userInterfaceStyle = UserInterfaceStyle.light
            }
        }
    }
}

struct SettingsSectionView<Content>: View where Content : View {
    var title: String
    var description: String
    
    var content: () -> Content

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                Text(description)
                    .font(.footnote)
            }
            self.content()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
