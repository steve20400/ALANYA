package com.alanya.dto.request;

import jakarta.validation.constraints.NotNull;

public class MessageRequest {
    @NotNull(message = "Conversation ID is required")
    private Long conversationId;
    
    private String content;
    private Short type = 0;
    private Long replyToId;
    private String mediaUrl;

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Short getType() { return type; }
    public void setType(Short type) { this.type = type; }
    public Long getReplyToId() { return replyToId; }
    public void setReplyToId(Long replyToId) { this.replyToId = replyToId; }
    public String getMediaUrl() { return mediaUrl; }
    public void setMediaUrl(String mediaUrl) { this.mediaUrl = mediaUrl; }
}
