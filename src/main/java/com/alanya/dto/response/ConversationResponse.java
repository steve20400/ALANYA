package com.alanya.dto.response;

import java.time.LocalDateTime;

public class ConversationResponse {
    private Long id;
    private String name;
    private String initials;
    private Boolean isGroup;
    private Boolean isPinned;
    private Integer unreadCount;
    private String lastMessage;
    private LocalDateTime lastMessageAt;
    private Boolean online;

    public ConversationResponse(Long id, String name, String initials, Boolean isGroup,
                                Boolean isPinned, Integer unreadCount, String lastMessage,
                                LocalDateTime lastMessageAt, Boolean online) {
        this.id = id;
        this.name = name;
        this.initials = initials;
        this.isGroup = isGroup;
        this.isPinned = isPinned;
        this.unreadCount = unreadCount;
        this.lastMessage = lastMessage;
        this.lastMessageAt = lastMessageAt;
        this.online = online;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getInitials() { return initials; }
    public void setInitials(String initials) { this.initials = initials; }
    public Boolean getIsGroup() { return isGroup; }
    public void setIsGroup(Boolean isGroup) { this.isGroup = isGroup; }
    public Boolean getIsPinned() { return isPinned; }
    public void setIsPinned(Boolean isPinned) { this.isPinned = isPinned; }
    public Integer getUnreadCount() { return unreadCount; }
    public void setUnreadCount(Integer unreadCount) { this.unreadCount = unreadCount; }
    public String getLastMessage() { return lastMessage; }
    public void setLastMessage(String lastMessage) { this.lastMessage = lastMessage; }
    public LocalDateTime getLastMessageAt() { return lastMessageAt; }
    public void setLastMessageAt(LocalDateTime lastMessageAt) { this.lastMessageAt = lastMessageAt; }
    public Boolean getOnline() { return online; }
    public void setOnline(Boolean online) { this.online = online; }
}
