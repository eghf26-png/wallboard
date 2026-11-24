// Wall Board configuration.
// These two values come from the Microsoft 365 app registration (step 3).
// They are NOT secrets: the app uses a browser sign-in (PKCE), so the data
// is still protected by the user's own Microsoft login.
window.DASHBOARD_CONFIG = {
  clientId: "",                 // Application (client) ID from Entra
  tenantId: "",                 // Directory (tenant) ID from Entra
  timezone: "GMT Standard Time" // UK time for the calendar
};
