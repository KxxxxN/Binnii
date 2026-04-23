//
//  AccountViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 21/4/2569 BE.
//


import SwiftUI
import Combine

@MainActor
final class AccountViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var path = NavigationPath()
    @Published var isNotificationOn = true
    @Published var hasError = false
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    private let authViewModel = AuthViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        setupNotificationObservers()
    }
    
    // MARK: - Navigation
    func navigate(to destination: AccountDestination) {
        path.append(destination)
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func popToProfile() {
        while path.count > 1 { path.removeLast() }
    }
    
    // MARK: - Auth Actions
    func signOut() async {
        await authViewModel.signOut()
        if authViewModel.isAuthenticated {
            hasError = true
        } else {
            isLoggedIn = false
        }
    }

    func deleteAccount() async {
        await authViewModel.deleteUser()
        if authViewModel.isAuthenticated {
            hasError = true
        } else {
            isLoggedIn = false
        }
    }

    
    func loadSession() async {
        await authViewModel.getInitialSession()
    }
    
    // MARK: - Observers
    private func setupNotificationObservers() {
        NotificationCenter.default.publisher(for: .popToAccount)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.popToRoot() }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .popToProfile)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.popToProfile() }
            .store(in: &cancellables)
    }
}
