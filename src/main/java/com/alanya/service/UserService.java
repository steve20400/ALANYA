package com.alanya.service;

import com.alanya.dto.response.UserResponse;
import com.alanya.model.Contact;
import com.alanya.model.User;
import com.alanya.repository.ContactRepository;
import com.alanya.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ContactRepository contactRepository;

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

    public List<UserResponse> getContacts(Integer userId) {
        List<Contact> contacts = contactRepository.findByUserId(userId);
        if (contacts.isEmpty()) return List.of();
        
        List<Integer> contactIds = contacts.stream()
                .map(Contact::getFriendId)
                .collect(Collectors.toList());
        
        return userRepository.findAllById(contactIds).stream()
                .map(user -> new UserResponse(
                    user.getId(),
                    user.getName(),
                    user.getPhone(),
                    user.getEmail(),
                    user.getAvatarUrl(),
                    user.getIsOnline(),
                    user.getStatusMsg(),
                    user.getCreatedAt()
                ))
                .collect(Collectors.toList());
    }

    @Transactional
    public void addContact(Integer userId, Integer contactId) {
        if (userId.equals(contactId)) {
            throw new RuntimeException("Cannot add yourself as contact");
        }
        
        if (!userRepository.existsById(contactId)) {
            throw new RuntimeException("User not found");
        }
        
        boolean exists = contactRepository.findByUserIdAndFriendId(userId, contactId).isPresent();
        if (exists) {
            throw new RuntimeException("Contact already exists");
        }
        
        Contact contact = new Contact();
        contact.setUserId(userId);
        contact.setFriendId(contactId);
        contact.setCreatedAt(LocalDateTime.now());
        contactRepository.save(contact);
    }

    @Transactional
    public void removeContact(Integer userId, Integer contactId) {
        contactRepository.deleteByUserIdAndFriendId(userId, contactId);
    }
}
