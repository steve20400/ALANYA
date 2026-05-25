package com.alanya.service;

import com.alanya.dto.request.MessageRequest;
import com.alanya.dto.response.ConversationResponse;
import com.alanya.dto.response.MessageResponse;
import com.alanya.model.Conversation;
import com.alanya.model.Message;
import com.alanya.model.User;
import com.alanya.repository.ConversationRepository;
import com.alanya.repository.MessageRepository;
import com.alanya.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ChatService {

    @Autowired
    private ConversationRepository conversationRepository;

    @Autowired
    private MessageRepository messageRepository;

    @Autowired
    private UserRepository userRepository;

    public Integer getUserIdByPhone(String phone) {
        return userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("User not found"))
                .getId();
    }

    public List<ConversationResponse> getUserConversations(Integer userId) {
        List<Conversation> conversations = conversationRepository.findByParticipantIdOrderByLastMessageAtDesc(userId);
        return conversations.stream()
                .map(conv -> mapToConversationResponse(conv, userId))
                .collect(Collectors.toList());
    }

    @Transactional
    public ConversationResponse createDirectConversation(Integer userId, Integer contactId) {
        List<Conversation> existing = conversationRepository.findByParticipantIdOrderByLastMessageAtDesc(userId);
        
        for (Conversation conv : existing) {
            if (!conv.getIsGroup() && conv.getParticipantId().equals(contactId)) {
                return mapToConversationResponse(conv, userId);
            }
        }

        Conversation conversation = new Conversation();
        conversation.setParticipantId(userId);
        conversation.setIsGroup(false);
        conversation.setCreatedAt(LocalDateTime.now());
        conversation = conversationRepository.save(conversation);

        return mapToConversationResponse(conversation, userId);
    }

    public List<MessageResponse> getMessages(Long conversationId, Integer userId) {
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("Conversation not found"));
        
        if (!conversation.getParticipantId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }

        List<Message> messages = messageRepository.findByConversationIdOrderBySendAtAsc(conversationId.intValue());
        return messages.stream()
                .map(this::mapToMessageResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public MessageResponse sendMessage(Long conversationId, Integer senderId, MessageRequest request) {
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("Conversation not found"));

        Message message = new Message();
        message.setConversationId(conversationId.intValue());
        message.setSenderId(senderId);
        message.setContent(request.getContent());
        message.setType(request.getType());
        message.setSendAt(LocalDateTime.now());
        message.setStatus(false);
        message = messageRepository.save(message);

        conversation.setLastMessageText(request.getContent());
        conversation.setLastMessageAt(LocalDateTime.now());
        
        if (!conversation.getParticipantId().equals(senderId)) {
            conversation.setUnreadCount(conversation.getUnreadCount() + 1);
        }
        
        conversationRepository.save(conversation);

        return mapToMessageResponse(message);
    }

    @Transactional
    public void markMessagesAsRead(Long conversationId, Integer userId) {
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("Conversation not found"));
        
        List<Message> messages = messageRepository.findByConversationIdOrderBySendAtAsc(conversationId.intValue());
        for (Message msg : messages) {
            if (!msg.getSenderId().equals(userId) && !msg.getStatus()) {
                msg.setStatus(true);
                msg.setReadAt(LocalDateTime.now());
                messageRepository.save(msg);
            }
        }
        
        conversation.setUnreadCount(0);
        conversationRepository.save(conversation);
    }

    private ConversationResponse mapToConversationResponse(Conversation conversation, Integer currentUserId) {
        User otherUser = null;
        if (!conversation.getIsGroup() && conversation.getParticipantId() != currentUserId) {
            otherUser = userRepository.findById(conversation.getParticipantId()).orElse(null);
        }

        String name = conversation.getIsGroup() ? conversation.getGroupName() : 
                      (otherUser != null ? otherUser.getName() : "Unknown");
        String initials = getInitials(name);

        return new ConversationResponse(
            conversation.getId(),
            name,
            initials,
            conversation.getIsGroup(),
            conversation.getIsPinned(),
            conversation.getUnreadCount(),
            conversation.getLastMessageText(),
            conversation.getLastMessageAt(),
            otherUser != null && otherUser.getIsOnline() != null && otherUser.getIsOnline()
        );
    }

    private MessageResponse mapToMessageResponse(Message message) {
        User sender = userRepository.findById(message.getSenderId()).orElse(null);
        return new MessageResponse(
            message.getId(),
            message.getSenderId(),
            sender != null ? sender.getName() : "Unknown",
            Long.valueOf(message.getConversationId()),
            message.getContent(),
            message.getType(),
            message.getStatus(),
            message.getSendAt(),
            message.getReadAt(),
            message.getMediaUrl(),
            message.getIsDeleted() != null && message.getIsDeleted(),
            message.getIsEdited() != null && message.getIsEdited(),
            message.getReplyToId() != null ? Long.valueOf(message.getReplyToId()) : null
        );
    }

    private String getInitials(String name) {
        if (name == null || name.isEmpty()) return "?";
        String[] parts = name.split(" ");
        if (parts.length == 1) return parts[0].substring(0, Math.min(2, parts[0].length())).toUpperCase();
        return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
    }
}
