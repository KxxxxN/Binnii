//
//  SupabaseAuthSwiftUi.swift
//  Test
//
//  Created by Kansinee Klinkhachon on 22/2/2569 BE.
//

import Supabase
import Foundation

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://xgtuoeggsylaqkniyvmz.supabase.co")!,
    supabaseKey: "sb_publishable_0-xCNtJL7YCTtPDcznZqzA_kda28osj",
    options: SupabaseClientOptions(
        auth: .init(
            emitLocalSessionAsInitialSession: true
        )
    )
)
