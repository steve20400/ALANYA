package com.alanya.controller;

import com.alanya.dto.response.UserResponse;
import com.alanya.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/me")
    public ResponseEntity<UserResponse> getCurrentUser(Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = userService.getUserIdByPhone(phone);
        return ResponseEntity.ok(userService.getUserById(userId));
    }

    @PutMapping("/me")
    public ResponseEntity<UserResponse> updateProfile(@RequestBody Map<String, String> updates, Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = userService.getUserIdByPhone(phone);
        // Pour l'instant, retourne juste l'utilisateur
        return ResponseEntity.ok(userService.getUserById(userId));
    }

    @GetMapping("/contacts")
    public ResponseEntity<List<UserResponse>> getContacts(Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = userService.getUserIdByPhone(phone);
        return ResponseEntity.ok(userService.getContacts(userId));
    }

    @PostMapping("/contacts/{contactId}")
    public ResponseEntity<Void> addContact(@PathVariable Integer contactId, Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = userService.getUserIdByPhone(phone);
        userService.addContact(userId, contactId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/contacts/{contactId}")
    public ResponseEntity<Void> removeContact(@PathVariable Integer contactId, Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = userService.getUserIdByPhone(phone);
        userService.removeContact(userId, contactId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<UserResponse>> searchUsers(@RequestParam String query) {
        // Recherche simple par nom
        return ResponseEntity.ok(List.of());
    }
}
