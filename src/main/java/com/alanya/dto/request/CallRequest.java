package com.alanya.dto.request;

import jakarta.validation.constraints.NotNull;

public class CallRequest {
    @NotNull(message = "Receiver ID is required")
    private Integer receiverId;
    private Short type = 0;

    public Integer getReceiverId() { return receiverId; }
    public void setReceiverId(Integer receiverId) { this.receiverId = receiverId; }
    public Short getType() { return type; }
    public void setType(Short type) { this.type = type; }
}
