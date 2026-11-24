// Wall Board configuration.
// These two values come from the Microsoft 365 app registration.
// They are NOT secrets: the app uses a browser sign-in (PKCE), so the data
// is still protected by the user's own Microsoft login.
window.DASHBOARD_CONFIG = {
  clientId: "64d895e8-19e5-4ce3-9310-bf53ff78793f", // Application (client) ID
  tenantId: "765842c8-2727-46b3-a91b-4e67225d83f0", // Directory (tenant) ID
  timezone: "GMT Standard Time"                      // UK time for the calendar
};
