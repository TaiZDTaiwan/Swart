//
//  CreateAccountView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 13/08/2021.
//

import SwiftUI
import Firebase
import AuthenticationServices
import ActivityIndicatorView

struct CreateAccountView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    
    let datesFormattersViewModel = DatesFormattersViewModel()
    
    let userRepositoryViewModel = UserRepositoryViewModel()
    
    @Binding var showLogInSheetView: Bool
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthday = Date()
    @State private var email = ""
    @State private var password = ""
    @State private var rePassword = ""
    
    @State private var user: User?
    
    @State private var showMain = false
    @State private var isLoading = false
    
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    
    var body: some View {
        
        let personalInformation = [firstName, lastName, email, password, rePassword]
        
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9607843137, green: 0.1764705882, blue: 0.2901960784, alpha: 1)), Color(#colorLiteral(red: 0.8551853299, green: 0.8111677766, blue: 0.07408294827, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .opacity(0.3)
                
                GeometryReader { geometry in
                    ActivityIndicatorView(isVisible: $isLoading, type: .flickeringDots)
                        .foregroundColor(Color(#colorLiteral(red: 0.5565254092, green: 0.5570400953, blue: 0.5776087046, alpha: 1)))
                        .frame(width: 80, height: 80, alignment: .center)
                        .opacity(0.8)
                        .isHidden(isLoading ? false : true)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("First name", text: $firstName)
                                .padding(10)
                                .overlay(RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.gray, lineWidth: 2))
                                .font(.system(size: 14))
                                .textContentType(.givenName)
                                .autocapitalization(.words)
                                .disableAutocorrection(true)
                            
                            TextField("Last name", text: $lastName)
                                .padding(10)
                                .overlay(RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.gray, lineWidth: 2))
                                .font(.system(size: 14))
                                .textContentType(.familyName)
                                .autocapitalization(.words)
                                .disableAutocorrection(true)
                            
                            Text("Make sure it matches the name on your government ID.")
                                .font(.system(.caption))
                                .foregroundColor(Color(.gray))
                                .fixedSize(horizontal: false, vertical: true)
                            
                        }
                        
                        VStack(alignment: .leading) {
                            HStack() {
                                DatePicker(selection: $birthday, in: ...Date(), displayedComponents: .date) {
                                        Text("Birthday (mm/dd/yyyy)")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(#colorLiteral(red: 0.756479919, green: 0.6241776347, blue: 0.6169845462, alpha: 1)))
                                }.accentColor(Color(#colorLiteral(red: 0.5565254092, green: 0.5570400953, blue: 0.5776087046, alpha: 1)))
                            }.padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.gray, lineWidth: 2))
                            
                            Text("To sign up, you need to be at least 18. Your birthday won't be shared with other people using Swart.")
                                .font(.system(.caption))
                                .foregroundColor(Color(.gray))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        VStack(spacing: 10) {
                            TextField("Email Address", text: $email)
                                .padding(10)
                                .overlay(RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.gray, lineWidth: 2))
                                .font(.system(size: 14))
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.gray, lineWidth: 2))
                            .font(.system(size: 14))
                            .disableAutocorrection(true)
                            .textContentType(.newPassword)
                            .autocapitalization(.none)
                        
                        SecureField("Confirm Password", text: $rePassword)
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.gray, lineWidth: 2))
                            .font(.system(size: 14))
                            .disableAutocorrection(true)
                            .textContentType(.newPassword)
                            .autocapitalization(.none)
                        }
                        
                        
                        VStack(spacing: 20) {
                            Group {
                                Text("By selecting Agree and continue below, I agree to Swart's")
                                    + Text(" Terms of Service").foregroundColor(.blue).underline()
                                    + Text(" and")
                                    + Text(" Privacy Policy").foregroundColor(.blue).underline()
                                    + Text(".")
                            }.font(.system(.caption))
                            .foregroundColor(Color(.gray))
                            .fixedSize(horizontal: false, vertical: true)
                            
                            Button(action: {
                                createUserInDatabase(array: personalInformation)
                                
                            }, label: {
                                Text("Agree and continue")
                                    .frame(width: UIScreen.main.bounds.size.width * 3/4, height: 10, alignment: .center)
                                    .font(.system(size: 17))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                            .opacity(0.7))
                            })
                        }
                    }.padding()
                    .padding([.leading, .trailing], 10)
                }.isHidden(isLoading ? true : false)
            }.navigationBarTitle(Text("Finish signing up"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showLogInSheetView = false
            }) {
                HStack {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .opacity(0.7)
                }
            })
            .alert(isPresented: $isAlertPresented) {
                Alert(title: Text(alertMessage), message: .none, dismissButton: .default(Text("OK"), action: {
                    if isLoading {
                        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
                            if error != nil {
                                alertMessage = error!.localizedDescription
                                isAlertPresented = true
                            } else {
                                if let user = authDataResult?.user {
                                    authentificationViewModel.userInAuthentification.id = user.uid
                                    self.showMain = true
                                }
                            }
                        }
                    }
                })
            )}
            .fullScreenCover(isPresented: $showMain, content: {
                MainTabView.init(userRepositoryViewModel: UserRepositoryViewModel())
            })
        }
    }
    
    private func createUserInDatabase(array: [String]) {

        let userIsAdult = datesFormattersViewModel.userIs18(birthdate: birthday)
    
        if array.contains("") {
            alertMessage = "Please fill all the required information."
            isAlertPresented = true
        } else if userIsAdult == false {
            alertMessage = "You cannot create an account if you are under 18."
            isAlertPresented = true
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
                if error != nil {
                    alertMessage = error!.localizedDescription
                    isAlertPresented = true
                } else if password != rePassword {
                    alertMessage = "Please insert same passwords."
                    isAlertPresented = true
                } else {
                    isLoading = true
            
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
             
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                
                            if error == nil {
                                alertMessage = "Welcome to Swart, we have sent you an email with your connection info !"
                                isAlertPresented = true
                            }
                                            
                            if let user = authDataResult?.user {
                                authentificationViewModel.userInAuthentification.id = user.uid
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "MM/dd/yyyy"
                                let birthdate = formatter.string(from: birthday)
                                
                                let newUser = UserSwart(id: authentificationViewModel.userInAuthentification.id, firstName: firstName, lastName: lastName, birthdate: birthdate, email: email)
                                                
                                userRepositoryViewModel.saveUserInfoToDatabase(id: authentificationViewModel.userInAuthentification.id ?? "", user: newUser)
                            }
                        })
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateAccountView(showLogInSheetView: .constant(false))
        }
    }
}
