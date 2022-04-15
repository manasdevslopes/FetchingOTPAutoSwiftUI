//
//  Login.swift
//  FetchingOTPAutoSwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 15/04/22.
//

import SwiftUI
import AwesomeToast

struct Login: View {
    @StateObject var otpViewModel: OTPViewModel = .init()
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                VStack(spacing: 8) {
                    TextField("1", text: $otpViewModel.code)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                    
                    Rectangle()
                        .fill(otpViewModel.code == "" ? .gray.opacity(0.35) : .blue)
                        .frame(height: 2)
                    
                }
                .frame(width: 40)
                
                VStack(spacing: 8) {
                    TextField("6574883829", text: $otpViewModel.number)
                        .keyboardType(.numberPad)
                    
                    Rectangle()
                        .fill(otpViewModel.number == "" ? .gray.opacity(0.35) : .blue)
                        .frame(height: 2)
                }
            }
            .padding(.vertical)
            
            Button {
                Task { await otpViewModel.sendOTP() }
            } label: {
                Text("Login")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.blue)
                            .opacity(otpViewModel.isLoading ? 0.4 : 1)
                    )
                    .overlay(
                        ProgressView()
                            .opacity(otpViewModel.isLoading ? 1 : 0)
                    )
            }
            .disabled(otpViewModel.code == "" || otpViewModel.number == "")
            .opacity(otpViewModel.code == "" || otpViewModel.number == "" ? 0.4 : 1)
            
            Spacer()
        }
        .navigationTitle("Login")
        .padding()
        .frame(maxWidth: .infinity, alignment: .top)
        .background(
            NavigationLink(tag: "VERIFICATION", selection: $otpViewModel.navigationTag) {
                Verification()
                    .environmentObject(otpViewModel)
            } label: {}
                .labelsHidden()
        )
        .showToast(title: "Error:", otpViewModel.errorMsg, isPresented: $otpViewModel.showAlert, color: Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), duration: 4, alignment: .top, toastType: .offsetToast)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
