//
//  ContentView.swift
//  Sample BiometricAuthentication
//
//  Created by 永井涼 on 2024/06/08.
//

import SwiftUI

struct ContentView: View {
    @State var authMessage = "生体認証サンプルシステムへようこそ"
    @State var lockOpen = false
    
    let biometric:BiometricAuthManager = BiometricAuthManager()
    
    var body: some View {
        VStack {
            if lockOpen {
                Button(action: { startBiometricAuthentication() }) {
                    Image(systemName: "lock.open")
                        .resizable()
                        .frame(width: 150, height: 150)
                }
            } else {
                Button(action: { startBiometricAuthentication() }) {
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 150, height: 150)
                }
            }
            
            Text("\(authMessage)")
        }
    }
    
    // 認証開始処理
    func startBiometricAuthentication() {
        Task { @MainActor in
            do {
                let authResult = try await biometric.auth()
                authMessage = authResult.0
                lockOpen = authResult.1
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

