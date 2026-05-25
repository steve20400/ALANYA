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
    
    @Column(name = "readAt")
    private LocalDateTime readAt;
    
    @Column(name = "mediaUrl")
    private String mediaUrl;
    
    @Column(name = "isDeleted")
    private Boolean isDeleted = false;
    
    @Column(name = "isEdited")
    private Boolean isEdited = false;
    
    @Column(name = "replyToID")
    private Integer replyToId;
    
    // Getters
    public Long getId() { return id; }
    public Integer getSenderId() { return senderId; }
    public Integer getConversationId() { return conversationId; }
    public String getContent() { return content; }
    public Short getType() { return type; }
    public Boolean getStatus() { return status; }
    public LocalDateTime getSendAt() { return sendAt; }
    public LocalDateTime getReadAt() { return readAt; }
    public String getMediaUrl() { return mediaUrl; }
    public Boolean getIsDeleted() { return isDeleted; }
    public Boolean getIsEdited() { return isEdited; }
    public Integer getReplyToId() { return replyToId; }
    
    // Setters
    public void setId(Long id) { this.id = id; }
    public void setSenderId(Integer senderId) { this.senderId = senderId; }
    public void setConversationId(Integer conversationId) { this.conversationId = conversationId; }
    public void setContent(String content) { this.content = content; }
    public void setType(Short type) { this.type = type; }
    public void setStatus(Boolean status) { this.status = status; }
    public void setSendAt(LocalDateTime sendAt) { this.sendAt = sendAt; }
    public void setReadAt(LocalDateTime readAt) { this.readAt = readAt; }
    public void setMediaUrl(String mediaUrl) { this.mediaUrl = mediaUrl; }
    public void setIsDeleted(Boolean isDeleted) { this.isDeleted = isDeleted; }
    public void setIsEdited(Boolean isEdited) { this.isEdited = isEdited; }
    public void setReplyToId(Integer replyToId) { this.replyToId = replyToId; }
}
