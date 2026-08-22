package com.company.irs941.controller;

import java.util.Optional;
import java.util.Map;
import java.util.HashMap;
import java.net.URL;
import java.net.HttpURLConnection;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.company.irs941.model.Employer;
import com.company.irs941.model.User;
import com.company.irs941.service.AuthService;
import com.company.irs941.service.EmployerService;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Controller
public class AuthController {

    private static final Logger logger = LogManager.getLogger(AuthController.class);

    @Autowired
    private AuthService authService;

    @Autowired(required = false)
    private EmployerService employerService;

    @org.springframework.beans.factory.annotation.Value("${google.clientId:5271500097-fv86qrvqcc1b71a66jl31fuf5i2d52ca.apps.googleusercontent.com}")
    private String googleClientId;

    @org.springframework.beans.factory.annotation.Value("${google.clientSecret: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}")
    private String googleClientSecret;

    @org.springframework.beans.factory.annotation.Value("${google.redirectUri:http://localhost:8090/newdb/login/oauth2/code/google}")
    private String googleRedirectUri;

    @org.springframework.beans.factory.annotation.Value("${google.authUrl:https://accounts.google.com/o/oauth2/v2/auth}")
    private String googleAuthUrl;

    @org.springframework.beans.factory.annotation.Value("${google.tokenUrl:https://oauth2.googleapis.com/token}")
    private String googleTokenUrl;

    @org.springframework.beans.factory.annotation.Value("${google.userInfoUrl:https://www.googleapis.com/oauth2/v3/userinfo}")
    private String googleUserInfoUrl;

    @org.springframework.beans.factory.annotation.Value("${google.scope:openid profile email}")
    private String googleScope;

    @GetMapping({ "/", "/index", "/home", "/index.html", "/landing" })
    public String showHomePage() {
        logger.info("[AUTH] Displaying Form 941 public home page.");
        return "index";
    }

    @GetMapping("/login")
    public String showLoginPage() {
        logger.info("[AUTH] Displaying login page.");
        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {
        logger.info("[AUTH LOGIN ATTEMPT] Email: {}", email);
        Optional<User> optUser = authService.authenticate(email, password);
        if (optUser.isPresent()) {
            User u = optUser.get();
            session.setAttribute("user", u);
            session.setAttribute("userId", u.getUserId());
            session.setAttribute("userEmail", u.getEmail());
            String name = u.getFullName() != null ? u.getFullName() : "User";
            session.setAttribute("userFullName", name);
            String firstName = u.getFirstName();
            session.setAttribute("userFirstName", firstName != null && !firstName.isEmpty() ? firstName : name);
            logger.info("[AUTH LOGIN SUCCESS] User logged in successfully: {}", email);
            return "redirect:/dashboard";
        } else {
            logger.warn("[AUTH LOGIN FAILED] Invalid credentials for email: {}", email);
            model.addAttribute("error", "Invalid email or password. Please try again.");
            return "login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login";
    }

    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@RequestParam(value = "name", required = false) String nameParam,
            @RequestParam(value = "fullName", required = false) String fullNameParam,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam(value = "businessName", required = false) String businessName,
            @RequestParam(value = "ein", required = false) String ein,
            HttpSession session,
            Model model) {
        String contactName = (nameParam != null && !nameParam.trim().isEmpty()) ? nameParam.trim() : fullNameParam;
        if (contactName == null || contactName.trim().isEmpty()) {
            contactName = email.split("@")[0];
        }
        try {
            User u = authService.registerUser(contactName, email, password);
            if (u == null || u.getUserId() == null) {
                model.addAttribute("error", "Failed to create user account. Please try again.");
                return "register";
            }

            // Create business profile if Business Name or EIN provided
            if ((businessName != null && !businessName.trim().isEmpty()) || (ein != null && !ein.trim().isEmpty())) {
                if (employerService != null) {
                    Employer emp = new Employer();
                    emp.setBusinessName(businessName != null ? businessName.trim() : "My Business");
                    emp.setEin(ein != null ? ein.trim() : "");
                    emp.setContactName(contactName);
                    emp.setEmail(email);
                    emp.setCreatedBy(u.getUserId());
                    employerService.saveEmployer(emp, u.getUserId());
                }
            }

            session.setAttribute("user", u);
            session.setAttribute("userId", u.getUserId());
            session.setAttribute("userEmail", u.getEmail());
            session.setAttribute("userFullName", u.getFullName());
            session.setAttribute("userFirstName", u.getFirstName());
            return "redirect:/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", "Error creating account: " + e.getMessage());
            return "register";
        }
    }

    @GetMapping("/auth/google/popup")
    public String showGooglePopupPage() {
        return "google_popup";
    }

    @GetMapping({"/auth/google/login", "/auth/google/initiate", "/oauth2/authorization/google"})
    public void initiateGoogleLogin(HttpServletResponse response) throws java.io.IOException {
        String clientId = (googleClientId != null && !googleClientId.trim().isEmpty()) 
                ? googleClientId.trim() : "5271500097-fv86qrvqcc1b71a66jl31fuf5i2d52ca.apps.googleusercontent.com";
        String redirectUri = (googleRedirectUri != null && !googleRedirectUri.trim().isEmpty()) 
                ? googleRedirectUri.trim() : "http://localhost:8090/newdb/login/oauth2/code/google";
        String authBaseUrl = (googleAuthUrl != null && !googleAuthUrl.trim().isEmpty())
                ? googleAuthUrl.trim() : "https://accounts.google.com/o/oauth2/v2/auth";
        String scope = (googleScope != null && !googleScope.trim().isEmpty())
                ? googleScope.trim() : "openid profile email";
        
        try {
            String encodedRedirect = java.net.URLEncoder.encode(redirectUri, "UTF-8");
            String encodedScope = java.net.URLEncoder.encode(scope, "UTF-8");
            String googleAuthUrlString = authBaseUrl + "?" +
                    "client_id=" + clientId +
                    "&redirect_uri=" + encodedRedirect +
                    "&response_type=code" +
                    "&scope=" + encodedScope +
                    "&prompt=select_account";
            logger.info("[GOOGLE OAUTH DIRECT REDIRECT] Setting 302 Location header to: {}", googleAuthUrlString);
            response.sendRedirect(googleAuthUrlString);
        } catch (Exception e) {
            logger.error("Error sending Google OAuth direct redirect", e);
            response.sendRedirect("login");
        }
    }

    @RequestMapping(value = { "/auth/google/register", "/register/google", "/auth/google/callback", "/login/oauth2/code/google" }, method = { RequestMethod.GET, RequestMethod.POST })
    public String registerWithGoogle(@RequestParam(value = "code", required = false) String code,
            @RequestParam(value = "googleId", required = false) String googleIdParam,
            @RequestParam(value = "sub", required = false) String subParam,
            @RequestParam(value = "googleEmail", required = false) String googleEmail,
            @RequestParam(value = "googleName", required = false) String googleName,
            @RequestParam(value = "email", required = false) String fallbackEmail,
            @RequestParam(value = "name", required = false) String fallbackName,
            HttpSession session,
            Model model) {

        String rawEmail = (googleEmail != null && !googleEmail.trim().isEmpty()) ? googleEmail : fallbackEmail;
        String rawName = (googleName != null && !googleName.trim().isEmpty()) ? googleName : fallbackName;
        String googleId = (googleIdParam != null && !googleIdParam.trim().isEmpty()) ? googleIdParam : subParam;

        // If authorization code is provided by Google OAuth redirect
        if (code != null && !code.trim().isEmpty()) {
            try {
                logger.info("[GOOGLE OAUTH CALLBACK] Received authorization code from Google. Exchanging token...");
                Map<String, String> googleUserInfo = exchangeGoogleAuthCode(code.trim());
                if (googleUserInfo != null && googleUserInfo.containsKey("email")) {
                    rawEmail = googleUserInfo.get("email");
                    rawName = googleUserInfo.get("name");
                    googleId = googleUserInfo.get("sub");
                    logger.info("[GOOGLE OAUTH TOKEN SUCCESS] Verified Google User: email={}, sub={}, name={}", rawEmail, googleId, rawName);
                }
            } catch (Exception e) {
                logger.error("Failed to exchange Google OAuth code", e);
            }
        }

        if (rawEmail == null || rawEmail.trim().isEmpty()) {
            model.addAttribute("error", "Google authentication failed or was cancelled.");
            return "register";
        }

        if (googleId == null || googleId.trim().isEmpty()) {
            googleId = "google-sub-" + Math.abs(rawEmail.toLowerCase().hashCode());
        }

        String email = rawEmail.trim().toLowerCase();
        String name = (rawName != null && !rawName.trim().isEmpty()) ? rawName.trim() : email.split("@")[0];

        try {
            logger.info("[GOOGLE AUTHENTICATION ATTEMPT] Email: {}, Name: {}, GoogleId(sub): {}", email, name, googleId);
            User u = authService.processGoogleOAuthUser(googleId, email, name);

            if (u != null && u.getUserId() != null) {
                session.setAttribute("user", u);
                session.setAttribute("userId", u.getUserId());
                session.setAttribute("userEmail", u.getEmail());
                session.setAttribute("userFullName", u.getFullName());
                String firstName = u.getFirstName();
                session.setAttribute("userFirstName", firstName != null && !firstName.isEmpty() ? firstName : name);
                logger.info("[GOOGLE AUTHENTICATION SUCCESS] User logged in: {}, userId: {}", u.getEmail(), u.getUserId());
                return "redirect:/dashboard";
            } else {
                model.addAttribute("error", "Failed to authenticate account with Google. Please try again.");
                return "register";
            }
        } catch (Exception e) {
            logger.error("[GOOGLE AUTHENTICATION ERROR] {}", e.getMessage(), e);
            model.addAttribute("error", "Google authentication failed: " + e.getMessage());
            return "register";
        }
    }

    private Map<String, String> exchangeGoogleAuthCode(String code) {
        Map<String, String> result = new HashMap<>();
        try {
            String clientId = (googleClientId != null && !googleClientId.trim().isEmpty()) 
                    ? googleClientId.trim() : "5271500097-fv86qrvqcc1b71a66jl31fuf5i2d52ca.apps.googleusercontent.com";
            String clientSecret = (googleClientSecret != null && !googleClientSecret.trim().isEmpty()) 
                    ? googleClientSecret.trim() : "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";
            String redirectUri = (googleRedirectUri != null && !googleRedirectUri.trim().isEmpty()) 
                    ? googleRedirectUri.trim() : "http://localhost:8090/newdb/login/oauth2/code/google";
            String tokenEndpointUrl = (googleTokenUrl != null && !googleTokenUrl.trim().isEmpty())
                    ? googleTokenUrl.trim() : "https://oauth2.googleapis.com/token";
            String userInfoEndpointUrl = (googleUserInfoUrl != null && !googleUserInfoUrl.trim().isEmpty())
                    ? googleUserInfoUrl.trim() : "https://www.googleapis.com/oauth2/v3/userinfo";

            logger.info("[GOOGLE TOKEN EXCHANGE] Exchanging authorization code at tokenUrl={}, redirectUri={}", tokenEndpointUrl, redirectUri);

            URL url = new URL(tokenEndpointUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)");
            conn.setRequestProperty("Accept", "application/json");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            String postParams = "code=" + java.net.URLEncoder.encode(code, "UTF-8") +
                    "&client_id=" + java.net.URLEncoder.encode(clientId, "UTF-8") +
                    "&client_secret=" + java.net.URLEncoder.encode(clientSecret, "UTF-8") +
                    "&redirect_uri=" + java.net.URLEncoder.encode(redirectUri, "UTF-8") +
                    "&grant_type=authorization_code";

            try (java.io.OutputStream os = conn.getOutputStream()) {
                os.write(postParams.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                String responseBody;
                try (java.io.InputStream is = conn.getInputStream();
                     java.util.Scanner scanner = new java.util.Scanner(is, "UTF-8")) {
                    responseBody = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
                }
                
                logger.info("[GOOGLE TOKEN RESPONSE] {}", responseBody);

                // 1. Try decoding id_token (JWT payload) directly first
                String idToken = extractJsonValue(responseBody, "id_token");
                if (idToken != null && idToken.contains(".")) {
                    try {
                        String[] parts = idToken.split("\\.");
                        if (parts.length >= 2) {
                            String rawPayload = parts[1];
                            while (rawPayload.length() % 4 != 0) {
                                rawPayload += "=";
                            }
                            byte[] decoded = java.util.Base64.getUrlDecoder().decode(rawPayload);
                            String jwtPayload = new String(decoded, java.nio.charset.StandardCharsets.UTF_8);
                            logger.info("[GOOGLE ID TOKEN PAYLOAD] {}", jwtPayload);
                            String sub = extractJsonValue(jwtPayload, "sub");
                            String email = extractJsonValue(jwtPayload, "email");
                            String name = extractJsonValue(jwtPayload, "name");

                            if (sub != null && !sub.isEmpty()) result.put("sub", sub);
                            if (email != null && !email.isEmpty()) result.put("email", email);
                            if (name != null && !name.isEmpty()) result.put("name", name);
                        }
                    } catch (Exception e) {
                        logger.error("Failed to decode Google id_token JWT", e);
                    }
                }

                // 2. Fallback to UserInfo API endpoint if email not found in id_token
                if (!result.containsKey("email")) {
                    String accessToken = extractJsonValue(responseBody, "access_token");
                    if (accessToken != null && !accessToken.isEmpty()) {
                        URL userInfoUrl = new URL(userInfoEndpointUrl);
                        HttpURLConnection userInfoConn = (HttpURLConnection) userInfoUrl.openConnection();
                        userInfoConn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)");
                        userInfoConn.setRequestProperty("Authorization", "Bearer " + accessToken);

                        if (userInfoConn.getResponseCode() == 200) {
                            String userInfoBody;
                            try (java.io.InputStream is = userInfoConn.getInputStream();
                                 java.util.Scanner scanner = new java.util.Scanner(is, "UTF-8")) {
                                userInfoBody = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
                            }
                            logger.info("[GOOGLE USERINFO BODY] {}", userInfoBody);
                            String sub = extractJsonValue(userInfoBody, "sub");
                            String email = extractJsonValue(userInfoBody, "email");
                            String name = extractJsonValue(userInfoBody, "name");

                            if (sub != null && !sub.isEmpty()) result.put("sub", sub);
                            if (email != null && !email.isEmpty()) result.put("email", email);
                            if (name != null && !name.isEmpty()) result.put("name", name);
                        } else {
                            logger.error("[GOOGLE USERINFO ERROR] Status: {}", userInfoConn.getResponseCode());
                        }
                    }
                }
            } else {
                String errorBody = "";
                if (conn.getErrorStream() != null) {
                    try (java.io.InputStream es = conn.getErrorStream();
                         java.util.Scanner scanner = new java.util.Scanner(es, "UTF-8")) {
                        errorBody = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
                    }
                }
                logger.error("[GOOGLE OAUTH ERROR] Token endpoint status {}: {}", responseCode, errorBody);
            }
        } catch (Exception e) {
            logger.error("[GOOGLE OAUTH TOKEN EXCEPTION]", e);
        }
        return result;
    }

    private String extractJsonValue(String json, String key) {
        if (json == null || key == null) return "";
        try {
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("\"" + java.util.regex.Pattern.quote(key) + "\"\\s*:\\s*\"([^\"]+)\"").matcher(json);
            if (m.find()) {
                return m.group(1).trim();
            }
            java.util.regex.Matcher m2 = java.util.regex.Pattern.compile("\"" + java.util.regex.Pattern.quote(key) + "\"\\s*:\\s*([^,\\}\\]\\s]+)").matcher(json);
            if (m2.find()) {
                return m2.group(1).replace("\"", "").trim();
            }
        } catch (Exception ignored) {}
        return "";
    }
}
