package com.capstone.allergy.controller;

import com.capstone.allergy.domain.User;
import com.capstone.allergy.dto.LoginRequest;
import com.capstone.allergy.dto.SignupFullRequest;
import com.capstone.allergy.jwt.JwtTokenProvider;
import com.capstone.allergy.repository.UserRepository;
import com.capstone.allergy.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "인증 관련 API", description = "회원가입, 로그인, 로그아웃 기능을 제공합니다.")
public class AuthController {

    private final UserService userService;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    // ✅ 회원가입
    @Operation(summary = "회원가입", description = "회원가입 단계의 모든 정보를 받아 회원을 등록합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "회원가입 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청 (이미 존재하는 유저 등)")
    })
    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody SignupFullRequest request) {
        try {
            userService.registerUser(request);
            return ResponseEntity.ok("회원가입 성공!");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // ✅ 로그인
    @Operation(summary = "로그인", description = "아이디와 비밀번호를 입력받아 JWT 토큰을 반환합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "로그인 성공"),
            @ApiResponse(responseCode = "401", description = "아이디 또는 비밀번호 불일치")
    })
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        Optional<User> userOpt = userRepository.findByUsername(request.getUsername());

        if (userOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("아이디가 존재하지 않습니다.");
        }

        User user = userOpt.get();

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("비밀번호가 틀렸습니다.");
        }

        String token = jwtTokenProvider.createToken(user.getId().toString());

        // 원하면 user 정보도 일부 포함 가능
        Map<String, Object> response = new HashMap<>();
        response.put("token", token);
        response.put("userId", user.getId());
        response.put("username", user.getUsername());

        return ResponseEntity.ok(response);
    }

    // ✅ 로그아웃 (토큰 삭제는 클라이언트가 처리)
    @Operation(summary = "로그아웃", description = "서버에서 별도 처리 없이 클라이언트가 토큰을 삭제하면 됩니다.")
    @ApiResponse(responseCode = "200", description = "로그아웃 성공")
    @PostMapping("/logout")
    public ResponseEntity<?> logout() {
        return ResponseEntity.ok("로그아웃 성공: 클라이언트는 토큰 삭제 요망");
    }
}