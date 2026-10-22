//
//  AboutNyaView.swift
//  H-sign
//
//  Created by elevenvl on 23/5/25.
//

import SwiftUI
import NimbleViews
import NimbleJSON

// MARK: - View
struct AboutNyaView: View {
    private let _dataService = NBFetchService()
    
    @State private var shouldShowPatchNotes = false
    
    // MARK: Body
    var body: some View {
        NBList(.localized("About")) {
            Section {
                VStack {
                    Image(uiImage: (UIImage(named: Bundle.main.iconFileName ?? ""))! )
                        .appIconStyle(size: 72)
                    
                    Text(Bundle.main.exec)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.accent)
                    
                    HStack(spacing: 4) {
                        Text("Version")
                        Text(Bundle.main.version)
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    
                    Button {
                        _showPatchNotes()
                    } label: {
                        Text("Show patch notes").bg()
                    }
                    .font(.footnote)
                    .padding(.top, 4)
                    .tint(.accent)
                }
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(EmptyView())
            
            NBSection(.localized("Credits")) {
                // Заменили Nyasami на elevenvl и обновили ссылку
                _credit(name: "elevenvl", desc: "Developer", github: "hybr1der")
            }
            
            NBSection("Special thanks!") {
                Group {
                    Text(.localized("This couldn't have been done without the original Feather devs! ❤️"))
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 2)
                }
                .transition(.slide)
            }
            
            NBSection("Acknowledgements") {
                NavigationLink(destination: AboutView()) {
                    HStack {
                        Text("About the original Feather")
                        Spacer()
                    }
                }
            } footer: {
                Text(Bundle.main.bundleIdentifier ?? "")
            }
        }
        .onAppear {
            // Show patch notes when navigating to this view if they haven't been shown before
            if !UserDefaults.standard.bool(forKey: "patchNotesShown") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    _showPatchNotes()
                    UserDefaults.standard.set(true, forKey: "patchNotesShown")
                }
            }
        }
    }
    
    private func _showPatchNotes() {
        UIAlertController.showAlertWithOk(
            title: .localized("From elevenvl, Version \(Bundle.main.version)"), // Заменили имя в заголовке
            message: .localized("This version introduces:\n\n- Custom branding for H-sign\n- Full interface translation to Russian\n- Updated author info and social links\n- Fixed UI bugs\n- Localization updates"),
            isCancel: true,
            thankYou: true
        )
    }
}

// MARK: - Extension: view
extension AboutNyaView {
    @ViewBuilder
    private func _credit(
        name: String?,
        desc: String?,
        github: String
    ) -> some View {
        FRIconCellView(
            title: name ?? github,
            subtitle: desc ?? "",
            iconUrl: URL(string: "https://github.com/\(github).png")!,
            trailing: AnyView(
                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.secondary)
            )
        )
        .onTapGesture {
            if let url = URL(string: "https://github.com/\(github)") {
                UIApplication.shared.open(url)
            }
        }
    }
}
