package com.capstone.allergy.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user")
@Tag(name = "사용자 API", description = "사용자 정보 관련 기능을 제공합니다.")
public class UserController {

    @Operation(summary = "내 프로필 조회", description = "현재 로그인한 사용자의 ID 정보를 반환합니다.")
    @ApiResponse(responseCode = "200", description = "사용자 ID 반환 성공")
    @GetMapping("/profile")
    public ResponseEntity<?> getMyProfile(Authentication authentication) {
        String userId = (String) authentication.getPrincipal();
        return ResponseEntity.ok("내 사용자 ID: " + userId);
    }
}
