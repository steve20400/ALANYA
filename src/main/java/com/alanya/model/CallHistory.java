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
    
    @Column(name = "start_time")
    private LocalDateTime startTime;
    
    @Column(name = "duree")
    private Integer duration;
    
    // Getters
    public Long getId() { return id; }
    public Integer getCallerId() { return callerId; }
    public Integer getReceiverId() { return receiverId; }
    public Short getType() { return type; }
    public Short getStatus() { return status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getStartTime() { return startTime; }
    public Integer getDuration() { return duration; }
    
    // Setters
    public void setId(Long id) { this.id = id; }
    public void setCallerId(Integer callerId) { this.callerId = callerId; }
    public void setReceiverId(Integer receiverId) { this.receiverId = receiverId; }
    public void setType(Short type) { this.type = type; }
    public void setStatus(Short status) { this.status = status; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }
    public void setDuration(Integer duration) { this.duration = duration; }
}
