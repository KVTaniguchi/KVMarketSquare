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
        HolidayWrapperView(content: {
            List {
                Section(header: Text(Localization.key(.SettingsViewThemeTitle))) {
                    SettingsSectionView(title: Localization.key(.SettingsThemeSystemTitle), description: Localization.key(.SettingsThemeSystemDescription)) {
                        Toggle(isOn: $appData.isAutomaticColorScheme) {}
                        .onChange(of: appData.isAutomaticColorScheme) { _ in
                            setUserInterfaceStyle()
                        }
                        .tint(.green)
                    }
                    
                    if !appData.isAutomaticColorScheme {
                        SettingsSectionView(title: Localization.key(.SettingsThemeDarkModeTitle), description: Localization.key(.SettingsThemeDarkModeDescription)) {
                            Toggle(isOn: $appData.isDarkMode) {}
                            .onChange(of: appData.isDarkMode) { _ in
                                setUserInterfaceStyle()
                            }
                            .tint(.green)
                        }
                    }
                    SettingsSectionView(title: Localization.key(.SettingsThemeSnowTitle), description: Localization.key(.SettingsThemeSnowDescription)) {
                        Toggle(isOn: $appData.isLettingItSnow) {}
                        .onChange(of: appData.isLettingItSnow) { shouldSnow in
                            appData.snowScene = BetterSnowFall()
                        }
                        .tint(.green)
                    }
                }
            }
            .onChange(of: appData.userInterfaceStyle, perform: { value in
                utilities.overrideDisplayMode(appData.userInterfaceStyle)
            })
        }, scene: appData.snowScene)
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
                Text(description)
                    .font(.caption)
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
