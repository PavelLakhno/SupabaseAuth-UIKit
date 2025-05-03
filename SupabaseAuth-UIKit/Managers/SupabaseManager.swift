import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        // Replace these with your Supabase project URL and anon key
        let supabaseURL = "https://deqlpesmejdbyfkbeqsa.supabase.co"
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRlcWxwZXNtZWpkYnlma2JlcXNhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ4Nzk2MzAsImV4cCI6MjA2MDQ1NTYzMH0.vozrdZh1N-fnXM-CTmoBANZsOlSPZQzlaejkNvKjSfA"
        
        client = SupabaseClient(
            supabaseURL: URL(string: supabaseURL)!,
            supabaseKey: supabaseKey
        )
    }
} 
