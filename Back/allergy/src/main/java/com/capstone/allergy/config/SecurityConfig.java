package com.capstone.allergy.config;

import com.capstone.allergy.jwt.JwtAuthenticationFilter; // ✅ 필터 import
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor // ✅ JwtAuthenticationFilter 주입을 위해 필요
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter; // ✅ 필드 추가

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/api/auth/**",              // 기존 허용 경로
                                "/swagger-ui/**",           // Swagger UI 정적 리소스
                                "/v3/api-docs/**",          // OpenAPI 문서 경로
                                "/swagger-ui.html",         // Swagger HTML 진입점
                                "/api/gallery/images/**"    // 이미지 조회 경호 익명 허용
                        ).permitAll()
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form.disable())
                .httpBasic(httpBasic -> httpBasic.disable());

        // ✅ JWT 인증 필터를 UsernamePasswordAuthenticationFilter 앞에 추가
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
