package com.alanya.service;

import com.alanya.dto.request.CallRequest;
import com.alanya.dto.response.CallResponse;
import com.alanya.model.CallHistory;
import com.alanya.model.User;
import com.alanya.repository.CallHistoryRepository;
import com.alanya.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CallService {

    @Autowired
    private CallHistoryRepository callHistoryRepository;

    @Autowired
    private UserRepository userRepository;

    public Integer getUserIdByPhone(String phone) {
        return userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("User not found"))
                .getId();
    }

    public List<CallResponse> getCallHistory(Integer userId) {
        List<CallHistory> calls = callHistoryRepository.findByCallerIdOrReceiverIdOrderByCreatedAtDesc(userId, userId);
        return calls.stream()
                .map(call -> mapToCallResponse(call, userId))
                .collect(Collectors.toList());
    }

    @Transactional
    public CallResponse startCall(Integer callerId, CallRequest request) {
        CallHistory call = new CallHistory();
        call.setCallerId(callerId);
        call.setReceiverId(request.getReceiverId());
        call.setType(request.getType());
        call.setStatus((short) 0);
        call.setCreatedAt(LocalDateTime.now());
        call = callHistoryRepository.save(call);

        return mapToCallResponse(call, callerId);
    }

    @Transactional
    public CallResponse acceptCall(Long callId, Integer userId) {
        CallHistory call = callHistoryRepository.findById(callId)
                .orElseThrow(() -> new RuntimeException("Call not found"));

        if (!call.getReceiverId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }

        call.setStatus((short) 1);
        call.setStartTime(LocalDateTime.now());
        call = callHistoryRepository.save(call);

        return mapToCallResponse(call, userId);
    }

    @Transactional
    public CallResponse endCall(Long callId, Integer userId) {
        CallHistory call = callHistoryRepository.findById(callId)
                .orElseThrow(() -> new RuntimeException("Call not found"));

        if (!call.getReceiverId().equals(userId) && !call.getCallerId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }

        call.setStatus((short) 3);
        if (call.getStartTime() != null) {
            long duration = ChronoUnit.SECONDS.between(call.getStartTime(), LocalDateTime.now());
            call.setDuration((int) duration);
        }
        call = callHistoryRepository.save(call);

        return mapToCallResponse(call, userId);
    }

    private CallResponse mapToCallResponse(CallHistory call, Integer currentUserId) {
        boolean isCaller = call.getCallerId().equals(currentUserId);
        Integer contactId = isCaller ? call.getReceiverId() : call.getCallerId();
        
        User contact = userRepository.findById(contactId).orElse(null);
        String direction = isCaller ? "out" : (call.getStatus() == 0 ? "missed" : "in");
        String duration = call.getDuration() != null ? formatDuration(call.getDuration()) : "-";

        return new CallResponse(
            call.getId(),
            call.getCallerId(),
            call.getReceiverId(),
            contactId,
            contact != null ? contact.getName() : "Unknown",
            getInitials(contact != null ? contact.getName() : "U"),
            call.getType(),
            call.getStatus(),
            direction,
            duration,
            call.getCreatedAt(),
            call.getStartTime()
        );
    }

    private String getInitials(String name) {
        if (name == null || name.isEmpty()) return "?";
        String[] parts = name.split(" ");
        if (parts.length == 1) return parts[0].substring(0, Math.min(2, parts[0].length())).toUpperCase();
        return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
    }

    private String formatDuration(int seconds) {
        int minutes = seconds / 60;
        int remainingSeconds = seconds % 60;
        if (minutes > 0) {
            return String.format("%d min %d s", minutes, remainingSeconds);
        }
        return String.format("%d s", remainingSeconds);
    }
}
