package com.alanya.controller;

import com.alanya.dto.request.CallRequest;
import com.alanya.dto.response.CallResponse;
import com.alanya.service.CallService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/calls")
public class CallController {

    @Autowired
    private CallService callService;

    @GetMapping
    public ResponseEntity<List<CallResponse>> getCalls(Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = callService.getUserIdByPhone(phone);
        return ResponseEntity.ok(callService.getCallHistory(userId));
    }

    @PostMapping("/start")
    public ResponseEntity<CallResponse> startCall(@Valid @RequestBody CallRequest request, Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = callService.getUserIdByPhone(phone);
        return ResponseEntity.ok(callService.startCall(userId, request));
    }

    @PostMapping("/{callId}/accept")
    public ResponseEntity<CallResponse> acceptCall(@PathVariable Long callId, Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = callService.getUserIdByPhone(phone);
        return ResponseEntity.ok(callService.acceptCall(callId, userId));
    }

    @PostMapping("/{callId}/end")
    public ResponseEntity<CallResponse> endCall(@PathVariable Long callId, Authentication authentication) {
        String phone = authentication.getName();
        Integer userId = callService.getUserIdByPhone(phone);
        return ResponseEntity.ok(callService.endCall(callId, userId));
    }
}
