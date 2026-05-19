#!/bin/bash

cd /home/steve/Documents/react\ next.js/alanya\ web/alanya-backend

# Nettoyage complet
rm -rf src/main/java/com/alanya
mkdir -p src/main/java/com/alanya/config
mkdir -p src/main/java/com/alanya/controller
mkdir -p src/main/java/com/alanya/dto/request
mkdir -p src/main/java/com/alanya/dto/response
mkdir -p src/main/java/com/alanya/exception
mkdir -p src/main/java/com/alanya/model
mkdir -p src/main/java/com/alanya/repository
mkdir -p src/main/java/com/alanya/security
mkdir -p src/main/java/com/alanya/service
mkdir -p src/main/java/com/alanya/utils

# Fichier: AlanyaApplication.java
cat > src/main/java/com/alanya/AlanyaApplication.java << 'EOF'
package com.alanya;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class AlanyaApplication {
    public static void main(String[] args) {
        SpringApplication.run(AlanyaApplication.class, args);
    }
}
EOF

# Fichier: SecurityConfig.java
cat > src/main/java/com/alanya/config/SecurityConfig.java << 'EOF'
package com.alanya.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable)
            .cors(cors -> cors.configure(http))
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.SATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/auth/**", "/ws/**", "/webrtc/**").permitAll()
                .anyRequest().authenticated()
            );
        return http.build();
    }
}
EOF

# Fichier: WebSocketConfig.java
cat > src/main/java/com/alanya/config/WebSocketConfig.java << 'EOF'
package com.alanya.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic", "/queue", "/user");
        config.setApplicationDestinationPrefixes("/app");
        config.setUserDestinationPrefix("/user");
    }
    
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
                .setAllowedOrigins("http://localhost:5173", "http://localhost:3000")
                .withSockJS();
    }
}
EOF

# Fichier: WebRtcConfig.java
cat > src/main/java/com/alanya/config/WebRtcConfig.java << 'EOF'
package com.alanya.config;

import org.springframework.context.annotation.Configuration;

@Configuration
public class WebRtcConfig {
    // Configuration WebRTC
}
EOF

# Fichier: CorsConfig.java
cat > src/main/java/com/alanya/config/CorsConfig.java << 'EOF'
package com.alanya.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;
import java.util.Arrays;

@Configuration
public class CorsConfig {
    
    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        config.setAllowedOriginPatterns(Arrays.asList("http://localhost:5173", "http://localhost:3000"));
        config.setAllowedHeaders(Arrays.asList("Origin", "Content-Type", "Accept", "Authorization"));
        config.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }
}
EOF

# Fichier: User.java
cat > src/main/java/com/alanya/model/User.java << 'EOF'
package com.alanya.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "alanyalD")
    private Integer id;
    
    @Column(name = "nom", nullable = false, length = 60)
    private String name;
    
    @Column(name = "alanyaPhone", nullable = false, unique = true, length = 10)
    private String phone;
    
    @Column(name = "email", unique = true)
    private String email;
    
    @Column(name = "password", nullable = false)
    private String password;
    
    @Column(name = "avatar_url", length = 255)
    private String avatarUrl;
    
    @Column(name = "is_online")
    private Boolean isOnline = false;
    
    @Column(name = "last_seen")
    private LocalDateTime lastSeen;
    
    @Column(name = "status_msg", length = 100)
    private String statusMsg = "Disponible";
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    // Getters
    public Integer getId() { return id; }
    public String getName() { return name; }
    public String getPhone() { return phone; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getAvatarUrl() { return avatarUrl; }
    public Boolean getIsOnline() { return isOnline; }
    public LocalDateTime getLastSeen() { return lastSeen; }
    public String getStatusMsg() { return statusMsg; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    
    // Setters
    public void setId(Integer id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setEmail(String email) { this.email = email; }
    public void setPassword(String password) { this.password = password; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    public void setIsOnline(Boolean isOnline) { this.isOnline = isOnline; }
    public void setLastSeen(LocalDateTime lastSeen) { this.lastSeen = lastSeen; }
    public void setStatusMsg(String statusMsg) { this.statusMsg = statusMsg; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
EOF

# Fichier: Contact.java
cat > src/main/java/com/alanya/model/Contact.java << 'EOF'
package com.alanya.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "preferred_contact")
public class Contact {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idPrefContact")
    private Long id;
    
    @Column(name = "alanyalD", nullable = false)
    private Integer userId;
    
    @Column(name = "idFriend", nullable = false)
    private Integer friendId;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Integer getFriendId() { return friendId; }
    public void setFriendId(Integer friendId) { this.friendId = friendId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
EOF

# Fichier: Conversation.java
cat > src/main/java/com/alanya/model/Conversation.java << 'EOF'
package com.alanya.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "conversation")
public class Conversation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "conversId")
    private Long id;
    
    @Column(name = "participantID", nullable = false)
    private Integer participantId;
    
    @Column(name = "isGroup")
    private Boolean isGroup = false;
    
    @Column(name = "GroupName", length = 255)
    private String groupName;
    
    @Column(name = "lastMessageText", columnDefinition = "TEXT")
    private String lastMessageText;
    
    @Column(name = "lastMessageAt")
    private LocalDateTime lastMessageAt;
    
    @Column(name = "isPinned")
    private Boolean isPinned = false;
    
    @Column(name = "unreadCount")
    private Integer unreadCount = 0;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Integer getParticipantId() { return participantId; }
    public void setParticipantId(Integer participantId) { this.participantId = participantId; }
    public Boolean getIsGroup() { return isGroup; }
    public void setIsGroup(Boolean isGroup) { this.isGroup = isGroup; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public String getLastMessageText() { return lastMessageText; }
    public void setLastMessageText(String lastMessageText) { this.lastMessageText = lastMessageText; }
    public LocalDateTime getLastMessageAt() { return lastMessageAt; }
    public void setLastMessageAt(LocalDateTime lastMessageAt) { this.lastMessageAt = lastMessageAt; }
    public Boolean getIsPinned() { return isPinned; }
    public void setIsPinned(Boolean isPinned) { this.isPinned = isPinned; }
    public Integer getUnreadCount() { return unreadCount; }
    public void setUnreadCount(Integer unreadCount) { this.unreadCount = unreadCount; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
EOF

# Fichier: Message.java
cat > src/main/java/com/alanya/model/Message.java << 'EOF'
package com.alanya.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "message")
public class Message {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "msgID")
    private Long id;
    
    @Column(name = "senderID", nullable = false)
    private Integer senderId;
    
    @Column(name = "conversationID", nullable = false)
    private Integer conversationId;
    
    @Column(name = "content", columnDefinition = "TEXT")
    private String content;
    
    @Column(name = "type")
    private Short type = 0;
    
    @Column(name = "status")
    private Boolean status = false;
    
    @Column(name = "sendAt")
    private LocalDateTime sendAt;
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Integer getSenderId() { return senderId; }
    public void setSenderId(Integer senderId) { this.senderId = senderId; }
    public Integer getConversationId() { return conversationId; }
    public void setConversationId(Integer conversationId) { this.conversationId = conversationId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Short getType() { return type; }
    public void setType(Short type) { this.type = type; }
    public Boolean getStatus() { return status; }
    public void setStatus(Boolean status) { this.status = status; }
    public LocalDateTime getSendAt() { return sendAt; }
    public void setSendAt(LocalDateTime sendAt) { this.sendAt = sendAt; }
}
EOF

# Fichier: CallHistory.java
cat > src/main/java/com/alanya/model/CallHistory.java << 'EOF'
package com.alanya.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "call_history")
public class CallHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "IDCall")
    private Long id;
    
    @Column(name = "idCaller", nullable = false)
    private Integer callerId;
    
    @Column(name = "idReceiver", nullable = false)
    private Integer receiverId;
    
    @Column(name = "type")
    private Short type = 0;
    
    @Column(name = "status")
    private Short status = 0;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "duree")
    private Integer duration;
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Integer getCallerId() { return callerId; }
    public void setCallerId(Integer callerId) { this.callerId = callerId; }
    public Integer getReceiverId() { return receiverId; }
    public void setReceiverId(Integer receiverId) { this.receiverId = receiverId; }
    public Short getType() { return type; }
    public void setType(Short type) { this.type = type; }
    public Short getStatus() { return status; }
    public void setStatus(Short status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }
}
EOF

# Fichier: UserRepository.java
cat > src/main/java/com/alanya/repository/UserRepository.java << 'EOF'
package com.alanya.repository;

import com.alanya.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByPhone(String phone);
    Optional<User> findByEmail(String email);
    Optional<User> findByPhoneOrEmail(String phone, String email);
    boolean existsByPhone(String phone);
    boolean existsByEmail(String email);
}
EOF

# Fichier: ContactRepository.java
cat > src/main/java/com/alanya/repository/ContactRepository.java << 'EOF'
package com.alanya.repository;

import com.alanya.model.Contact;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ContactRepository extends JpaRepository<Contact, Long> {
    List<Contact> findByUserId(Integer userId);
    Optional<Contact> findByUserIdAndFriendId(Integer userId, Integer friendId);
    void deleteByUserIdAndFriendId(Integer userId, Integer friendId);
}
EOF

# Fichier: ConversationRepository.java
cat > src/main/java/com/alanya/repository/ConversationRepository.java << 'EOF'
package com.alanya.repository;

import com.alanya.model.Conversation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ConversationRepository extends JpaRepository<Conversation, Long> {
    List<Conversation> findByParticipantIdOrderByLastMessageAtDesc(Integer participantId);
}
EOF

# Fichier: MessageRepository.java
cat > src/main/java/com/alanya/repository/MessageRepository.java << 'EOF'
package com.alanya.repository;

import com.alanya.model.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {
    List<Message> findByConversationIdOrderBySendAtAsc(Integer conversationId);
}
EOF

# Fichier: CallHistoryRepository.java
cat > src/main/java/com/alanya/repository/CallHistoryRepository.java << 'EOF'
package com.alanya.repository;

import com.alanya.model.CallHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CallHistoryRepository extends JpaRepository<CallHistory, Long> {
    List<CallHistory> findByCallerIdOrReceiverIdOrderByCreatedAtDesc(Integer userId1, Integer userId2);
}
EOF

# Fichier: LoginRequest.java
cat > src/main/java/com/alanya/dto/request/LoginRequest.java << 'EOF'
package com.alanya.dto.request;

import jakarta.validation.constraints.NotBlank;

public class LoginRequest {
    @NotBlank(message = "Phone or email is required")
    private String identifier;
    
    @NotBlank(message = "Password is required")
    private String password;
    
    public String getIdentifier() { return identifier; }
    public void setIdentifier(String identifier) { this.identifier = identifier; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
EOF

# Fichier: RegisterRequest.java
cat > src/main/java/com/alanya/dto/request/RegisterRequest.java << 'EOF'
package com.alanya.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class RegisterRequest {
    @NotBlank(message = "Name is required")
    @Size(min = 2, max = 60)
    private String name;
    
    @NotBlank(message = "Phone number is required")
    @Pattern(regexp = "^\\+?[0-9]{8,15}$")
    private String phone;
    
    @NotBlank(message = "Email is required")
    @Email
    private String email;
    
    @NotBlank(message = "Password is required")
    @Size(min = 6)
    private String password;
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
EOF

# Fichier: UserResponse.java
cat > src/main/java/com/alanya/dto/response/UserResponse.java << 'EOF'
package com.alanya.dto.response;

import java.time.LocalDateTime;

public class UserResponse {
    private Integer id;
    private String name;
    private String phone;
    private String email;
    private String avatarUrl;
    private Boolean isOnline;
    private String statusMsg;
    private LocalDateTime createdAt;
    
    public UserResponse() {}
    
    public UserResponse(Integer id, String name, String phone, String email, String avatarUrl, Boolean isOnline, String statusMsg, LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.avatarUrl = avatarUrl;
        this.isOnline = isOnline;
        this.statusMsg = statusMsg;
        this.createdAt = createdAt;
    }
    
    public Integer getId() { return id; }
    public String getName() { return name; }
    public String getPhone() { return phone; }
    public String getEmail() { return email; }
    public String getAvatarUrl() { return avatarUrl; }
    public Boolean getIsOnline() { return isOnline; }
    public String getStatusMsg() { return statusMsg; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    
    public void setId(Integer id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setEmail(String email) { this.email = email; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    public void setIsOnline(Boolean isOnline) { this.isOnline = isOnline; }
    public void setStatusMsg(String statusMsg) { this.statusMsg = statusMsg; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
EOF

# Fichier: AuthResponse.java
cat > src/main/java/com/alanya/dto/response/AuthResponse.java << 'EOF'
package com.alanya.dto.response;

public class AuthResponse {
    private String accessToken;
    private String refreshToken;
    private String tokenType = "Bearer";
    private UserResponse user;
    
    public AuthResponse(String accessToken, String refreshToken, UserResponse user) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        this.user = user;
    }
    
    public String getAccessToken() { return accessToken; }
    public String getRefreshToken() { return refreshToken; }
    public String getTokenType() { return tokenType; }
    public UserResponse getUser() { return user; }
    
    public void setAccessToken(String accessToken) { this.accessToken = accessToken; }
    public void setRefreshToken(String refreshToken) { this.refreshToken = refreshToken; }
    public void setUser(UserResponse user) { this.user = user; }
}
EOF

# Fichier: UserDetailsServiceImpl.java
cat > src/main/java/com/alanya/security/UserDetailsServiceImpl.java << 'EOF'
package com.alanya.security;

import com.alanya.model.User;
import com.alanya.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByPhoneOrEmail(username, username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        
        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getPhone())
                .password(user.getPassword())
                .authorities("USER")
                .build();
    }
}
EOF

# Fichier: UserService.java
cat > src/main/java/com/alanya/service/UserService.java << 'EOF'
package com.alanya.service;

import com.alanya.dto.response.UserResponse;
import com.alanya.model.User;
import com.alanya.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    public UserResponse getUserById(Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return new UserResponse(
            user.getId(),
            user.getName(),
            user.getPhone(),
            user.getEmail(),
            user.getAvatarUrl(),
            user.getIsOnline(),
            user.getStatusMsg(),
            user.getCreatedAt()
        );
    }
    
    public Integer getUserIdByPhone(String phone) {
        return userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("User not found"))
                .getId();
    }
}
EOF

# Fichier: AuthService.java
cat > src/main/java/com/alanya/service/AuthService.java << 'EOF'
package com.alanya.service;

import com.alanya.dto.request.LoginRequest;
import com.alanya.dto.request.RegisterRequest;
import com.alanya.dto.response.AuthResponse;
import com.alanya.dto.response.UserResponse;
import com.alanya.model.User;
import com.alanya.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.Random;

@Service
public class AuthService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private UserService userService;
    
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByPhone(request.getPhone())) {
            throw new RuntimeException("Phone already registered");
        }
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already registered");
        }
        
        User user = new User();
        user.setName(request.getName());
        user.setPhone(request.getPhone());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setCreatedAt(LocalDateTime.now());
        user.setIsOnline(true);
        
        user = userRepository.save(user);
        
        UserResponse userResponse = userService.getUserById(user.getId());
        String accessToken = "dummy-token-" + System.currentTimeMillis();
        String refreshToken = "dummy-refresh-" + System.currentTimeMillis();
        
        return new AuthResponse(accessToken, refreshToken, userResponse);
    }
    
    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByPhoneOrEmail(request.getIdentifier(), request.getIdentifier())
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid password");
        }
        
        user.setIsOnline(true);
        user.setLastSeen(LocalDateTime.now());
        userRepository.save(user);
        
        UserResponse userResponse = userService.getUserById(user.getId());
        String accessToken = "dummy-token-" + System.currentTimeMillis();
        String refreshToken = "dummy-refresh-" + System.currentTimeMillis();
        
        return new AuthResponse(accessToken, refreshToken, userResponse);
    }
    
    public String requestRegistrationOtp(RegisterRequest request) {
        return String.format("%06d", new Random().nextInt(999999));
    }
}
EOF

# Fichier: AuthController.java
cat > src/main/java/com/alanya/controller/AuthController.java << 'EOF'
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
EOF

# Fichier: application.properties
cat > src/main/resources/application.properties << 'EOF'
spring.application.name=alanya-backend
server.port=8080
server.servlet.context-path=/api

spring.datasource.url=jdbc:mysql://localhost:3306/alanya_db?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=root
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect

jwt.secret=alanyaSuperSecretKeyForJWTTokenGeneration2025ENSPY
jwt.expiration=900000
jwt.refreshExpiration=604800000
EOF

echo "✅ Tous les fichiers ont été créés avec succès!"
echo "📁 Structure créée dans: src/main/java/com/alanya/"
echo ""
echo "Pour compiler, exécutez:"
echo "mvn clean compile"
