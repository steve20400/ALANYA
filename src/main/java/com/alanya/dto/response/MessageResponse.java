package com.alanya.dto.response;

import java.time.LocalDateTime;

public class MessageResponse {
    private Long id;
    private Integer senderId;
    private String senderName;
    private Long conversationId;
    private String content;
    private Short type;
    private Boolean status;
    private LocalDateTime sendAt;
    private LocalDateTime readAt;
    private String mediaUrl;
    private Boolean isDeleted;
    private Boolean isEdited;
    private Long replyToId;

    public MessageResponse(Long id, Integer senderId, String senderName, Long conversationId,
                           String content, Short type, Boolean status, LocalDateTime sendAt,
                           LocalDateTime readAt, String mediaUrl, Boolean isDeleted, 
                           Boolean isEdited, Long replyToId) {
        this.id = id;
        this.senderId = senderId;
        this.senderName = senderName;
        this.conversationId = conversationId;
        this.content = content;
        this.type = type;
        this.status = status;
        this.sendAt = sendAt;
        this.readAt = readAt;
        this.mediaUrl = mediaUrl;
        this.isDeleted = isDeleted;
        this.isEdited = isEdited;
        this.replyToId = replyToId;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Integer getSenderId() { return senderId; }
    public void setSenderId(Integer senderId) { this.senderId = senderId; }
    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }
    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Short getType() { return type; }
    public void setType(Short type) { this.type = type; }
    public Boolean getStatus() { return status; }
    public void setStatus(Boolean status) { this.status = status; }
    public LocalDateTime getSendAt() { return sendAt; }
    public void setSendAt(LocalDateTime sendAt) { this.sendAt = sendAt; }
    public LocalDateTime getReadAt() { return readAt; }
    public void setReadAt(LocalDateTime readAt) { this.readAt = readAt; }
    public String getMediaUrl() { return mediaUrl; }
    public void setMediaUrl(String mediaUrl) { this.mediaUrl = mediaUrl; }
    public Boolean getIsDeleted() { return isDeleted; }
    public void setIsDeleted(Boolean isDeleted) { this.isDeleted = isDeleted; }
    public Boolean getIsEdited() { return isEdited; }
    public void setIsEdited(Boolean isEdited) { this.isEdited = isEdited; }
    public Long getReplyToId() { return replyToId; }
    public void setReplyToId(Long replyToId) { this.replyToId = replyToId; }
}
