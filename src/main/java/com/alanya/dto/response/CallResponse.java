package com.alanya.dto.response;

import java.time.LocalDateTime;

public class CallResponse {
    private Long id;
    private Integer callerId;
    private Integer receiverId;
    private Integer contactId;
    private String contactName;
    private String contactInitials;
    private Short type;
    private Short status;
    private String direction;
    private String duration;
    private LocalDateTime createdAt;
    private LocalDateTime startTime;

    public CallResponse(Long id, Integer callerId, Integer receiverId, Integer contactId, 
                        String contactName, String contactInitials, Short type, Short status,
                        String direction, String duration, LocalDateTime createdAt, LocalDateTime startTime) {
        this.id = id;
        this.callerId = callerId;
        this.receiverId = receiverId;
        this.contactId = contactId;
        this.contactName = contactName;
        this.contactInitials = contactInitials;
        this.type = type;
        this.status = status;
        this.direction = direction;
        this.duration = duration;
        this.createdAt = createdAt;
        this.startTime = startTime;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Integer getCallerId() { return callerId; }
    public void setCallerId(Integer callerId) { this.callerId = callerId; }
    public Integer getReceiverId() { return receiverId; }
    public void setReceiverId(Integer receiverId) { this.receiverId = receiverId; }
    public Integer getContactId() { return contactId; }
    public void setContactId(Integer contactId) { this.contactId = contactId; }
    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }
    public String getContactInitials() { return contactInitials; }
    public void setContactInitials(String contactInitials) { this.contactInitials = contactInitials; }
    public Short getType() { return type; }
    public void setType(Short type) { this.type = type; }
    public Short getStatus() { return status; }
    public void setStatus(Short status) { this.status = status; }
    public String getDirection() { return direction; }
    public void setDirection(String direction) { this.direction = direction; }
    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }
}
