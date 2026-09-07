import Foundation
import Supabase

enum SupabaseManager {
    static let shared: SupabaseClient = {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
            let url = URL(string: urlString),
            let anonKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
            !anonKey.isEmpty
        else {
            fatalError(
                "Missing SUPABASE_URL / SUPABASE_ANON_KEY. Copy Config/Secrets.example.xcconfig " +
                "to Config/Secrets.xcconfig and fill in your Supabase project's values."
            )
        }
        return SupabaseClient(supabaseURL: url, supabaseKey: anonKey)
    }()
}
