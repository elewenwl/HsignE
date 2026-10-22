//
//  SettingsView.swift
//  H-sign
//
//  Created by elevenvl on 10.04.2025.
//

import SwiftUI
import NimbleViews

struct SettingsView: View {
    @AppStorage("feather.selectedCert") private var _storedSelectedCert: Int = 0
    @FetchRequest(
        entity: CertificatePair.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CertificatePair.date, ascending: false)],
        animation: .snappy
    ) private var _certificates: FetchedResults<CertificatePair>
    
    private var selectedCertificate: CertificatePair? {
        guard _storedSelectedCert >= 0, _storedSelectedCert < _certificates.count else {
            return nil
        }
        return _certificates[_storedSelectedCert]
    }
    
    private let _githubUrl = "https://github.com/elewenwl"
    private let _telegramDevUrl = "https://t.me/to_el_day"
    private let _telegramChannelUrl = "https://t.me/Hsign_com"
    private let _websiteUrl = "https://sfkumuxib.github.io/elevenvl-tools/"
    
    var body: some View {
        NBNavigationView(.localized("Настройки")) {
            Form {
                _feedback()
                
                Section {
                    NavigationLink(destination: AppIconView()) {
                        Label(.localized("Иконка приложения"), systemImage: "app.badge")
                    }
                    NavigationLink(destination: AppearanceView()) {
                        Label(.localized("Внешний вид"), systemImage: "paintbrush")
                    }
                }
                
                NBSection(.localized("Сертификаты")) {
                    if let cert = selectedCertificate {
                        CertificatesCellView(cert: cert)
                    } else {
                        Text(.localized("Нет сертификата"))
                            .font(.footnote)
                            .foregroundColor(.disabled())
                    }
                    NavigationLink(destination: CertificatesView()) {
                        Label(.localized("Сертификаты"), systemImage: "signature")
                    }
                } footer: {
                    Text(.localized("Добавляйте сертификаты и управляйте ими для подписи приложений."))
                }
                
                NBSection(.localized("Функции")) {
                    NavigationLink(destination: LogsView(manager: LogsManager.shared)) {
                        Label(.localized("Логи"), systemImage: "apple.terminal")
                    }
                    NavigationLink(destination: AppFeaturesView()) {
                        Label(.localized("Функции приложения"), systemImage: "sparkles")
                    }
                    NavigationLink(destination: ConfigurationView()) {
                        Label(.localized("Параметры подписи"), systemImage: "gear")
                    }
                    NavigationLink(destination: ArchiveView()) {
                        Label(.localized("Архивация"), systemImage: "archivebox")
                    }
                    NavigationLink(destination: InstallationView()) {
                        Label(.localized("Установка"), systemImage: "server.rack")
                    }
                }
                
                _directories()
                
                NBSection(.localized("Полезные ссылки")) {
                    Button {
                        if let url = URL(string: "https://altstore.io") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Скачать AltStore", systemImage: "arrow.down.circle")
                    }
                    
                    Button {
                        if let url = URL(string: "https://usescarlet.com") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Скачать Scarlet", systemImage: "flame")
                    }
                    
                    Button {
                        if let url = URL(string: "https://esign.yyyue.xyz") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Скачать ESign", systemImage: "signature")
                    }
                    
                    Button {
                        if let url = URL(string: _websiteUrl) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Сайт H-sign", systemImage: "safari")
                    }
                } footer: {
                    Text(.localized("Официальные сайты для скачивания инструментов подписи и нашего сайта."))
                }
                
                Section {
                    NavigationLink(destination: ResetView()) {
                        Label(.localized("Сброс"), systemImage: "trash")
                    }
                } footer: {
                    Text("Сбросить настройки источников, сертификатов, приложений и содержимого.")
                }
            }
        }
    }
}

extension SettingsView {
    @ViewBuilder
    private func _feedback() -> some View {
        Section {
            NavigationLink(destination: AboutNyaView()) {
                Label(.localized("О приложении"), systemImage: "info.circle")
            }
            
            Button(.localized("Telegram Канал"), systemImage: "megaphone") {
                UIApplication.open(_telegramChannelUrl)
            }
            
            Button(.localized("Разработчик в Telegram"), systemImage: "paperplane.circle") {
                UIApplication.open(_telegramDevUrl)
            }
            
            Button(.localized("Репозиторий на GitHub"), systemImage: "safari") {
                UIApplication.open(_githubUrl)
            }
        }
    }
    
    @ViewBuilder
    private func _directories() -> some View {
        NBSection(.localized("Разное")) {
            Button(.localized("Открыть документы"), systemImage: "folder") {
                UIApplication.open(URL.documentsDirectory.toSharedDocumentsURL()!)
            }
            Button(.localized("Открыть архивы"), systemImage: "folder") {
                UIApplication.open(FileManager.default.archives.toSharedDocumentsURL()!)
            }
        } footer: {
            Text(.localized("Все файлы H-sign, кроме сертификатов, находятся в папке документов."))
        }
    }
}
