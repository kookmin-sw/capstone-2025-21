package com.capstone.allergy.controller;

import com.capstone.allergy.dto.CommonResponse;
import com.capstone.allergy.jwt.CustomUserDetails;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
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

    @Operation(
            summary = "내 프로필 조회",
            description = "현재 로그인한 사용자의 ID 정보를 반환합니다.",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @ApiResponse(
            responseCode = "200",
            description = "사용자 ID 반환 성공",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = CommonResponse.class),
                    examples = @ExampleObject(
                            name = "사용자 ID 조회 예시",
                            value = "{\n" +
                                    "  \"success\": true,\n" +
                                    "  \"message\": \"사용자 ID 반환 성공\",\n" +
                                    "  \"data\": \"123\"\n" +
                                    "}"
                    )
            )
    )
    @GetMapping("/profile")
    public ResponseEntity<CommonResponse<Long>> getMyProfile(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getUser().getId();

        return ResponseEntity.ok(
                CommonResponse.<Long>builder()
                        .success(true)
                        .message("사용자 ID 반환 성공")
                        .data(userId)
                        .build()
        );
    }
}
