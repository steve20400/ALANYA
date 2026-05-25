package com.alanya.controller;

import com.alanya.dto.request.MessageRequest;
import com.alanya.dto.response.ConversationResponse;
import com.alanya.dto.response.MessageResponse;
import com.alanya.service.ChatService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/chats")
public class ChatController {

    @Autowired
    private ChatService chatService;

    @GetMapping
    public ResponseEntity<List<ConversationResponse>> getConversations(Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = chatService.getUserIdByPhone(phone);
        return ResponseEntity.ok(chatService.getUserConversations(userId));
    }

    @PostMapping("/direct/{contactId}")
    public ResponseEntity<ConversationResponse> createDirectConversation(@PathVariable Integer contactId, Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = chatService.getUserIdByPhone(phone);
        return ResponseEntity.ok(chatService.createDirectConversation(userId, contactId));
    }

    @GetMapping("/{conversationId}/messages")
    public ResponseEntity<List<MessageResponse>> getMessages(@PathVariable Long conversationId, Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = chatService.getUserIdByPhone(phone);
        return ResponseEntity.ok(chatService.getMessages(conversationId, userId));
    }

    @PostMapping("/{conversationId}/messages")
    public ResponseEntity<MessageResponse> sendMessage(@PathVariable Long conversationId, @Valid @RequestBody MessageRequest request, Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = chatService.getUserIdByPhone(phone);
        return ResponseEntity.ok(chatService.sendMessage(conversationId, userId, request));
    }

    @PostMapping("/{conversationId}/read")
    public ResponseEntity<Void> markMessagesAsRead(@PathVariable Long conversationId, Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = chatService.getUserIdByPhone(phone);
        chatService.markMessagesAsRead(conversationId, userId);
        return ResponseEntity.ok().build();
    }
}
