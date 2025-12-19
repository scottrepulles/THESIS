// Create Event
global.supabase_url = "https://nwzgdpzsyqlidamamzip.supabase.co"; // Replace with your URL
global.supabase_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53emdkcHpzeXFsaWRhbWFtemlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc2MDQ3MzAsImV4cCI6MjA3MzE4MDczMH0.6Nf8bMFsJtvx2QBbK3NFQ7utPr50pDFY-KPyyzjAEps";    // Replace with your key

show_debug_message("Supabase URL: " + global.supabase_url);
show_debug_message("API Key length: " + string(string_length(global.supabase_key)));