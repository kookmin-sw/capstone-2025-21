package com.capstone.allergy.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        final String securitySchemeName = "bearerAuth";

        return new OpenAPI()
                .info(new Info()
                        .title("Menu Project API")
                        .version("1.0")
                        .description("""
                    외국인을 위한 메뉴 추천 어플리케이션 API입니다. 🇰🇷

                    🔐 JWT 인증이 필요한 API는 Swagger에 자물쇠(🔒) 아이콘으로 표시되어 있습니다.

                    ✅ 호출 시 반드시 아래와 같은 헤더를 포함해야 합니다:

                        Authorization: Bearer {발급받은 JWT 토큰}

                    ▶ 상단의 "Authorize" 버튼을 클릭해 JWT 토큰을 입력하면,
                    인증이 필요한 API도 Swagger에서 바로 테스트할 수 있습니다.
                    """)
                )
                .components(new Components()
                        .addSecuritySchemes(securitySchemeName,
                                new SecurityScheme()
                                        .name(securitySchemeName)
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")
                        )
                );
    }
}
