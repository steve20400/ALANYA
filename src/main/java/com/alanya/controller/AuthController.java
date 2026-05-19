package com.alanya.controller;

import com.alanya.dto.request.LoginRequest;
import com.alanya.dto.request.RegisterRequest;
import com.alanya.dto.response.AuthResponse;
import com.alanya.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {
    
    @Autowired
    private AuthService authService;
    
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }
    
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }
    
    @PostMapping("/register-otp")
    public ResponseEntity<Map<String, String>> requestRegistrationOtp(@Valid @RequestBody RegisterRequest request) {
        String otp = authService.requestRegistrationOtp(request);
        return ResponseEntity.ok(Map.of("debugOtp", otp));
    }
}
