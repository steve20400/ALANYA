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
