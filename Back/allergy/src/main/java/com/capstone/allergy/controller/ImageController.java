package com.capstone.allergy.controller;

import com.capstone.allergy.cache.ImagePathCache;
import com.capstone.allergy.dto.CommonResponse;
import com.capstone.allergy.dto.UploadImageResponse;
import com.capstone.allergy.cache.ImagePathCache;
import com.capstone.allergy.jwt.CustomUserDetails;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.*;
import java.util.UUID;

@RestController
@RequestMapping("/api/gallery")
@Tag(name = "이미지 업로드", description = "이미지 업로드 및 조회 API")
public class ImageController {

    private final String uploadDir;
    private final ImagePathCache imagePathCache;

    public ImageController(@Value("${file.upload-dir}") String uploadDir, ImagePathCache imagePathCache) {
        this.uploadDir = uploadDir;
        this.imagePathCache = imagePathCache;

        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs(); // 업로드 폴더가 없으면 생성
        }
    }

    @Operation(
            summary = "이미지 업로드",
            description = """
이미지를 업로드합니다.
이미지를 `multipart/form-data` 형식으로 업로드하며,
폼 데이터의 key는 `'image'`, value는 업로드할 파일입니다.

- `Content-Type`: `multipart/form-data`
- `Authorization`: Bearer {Token}
""",
            security = @SecurityRequirement(name = "bearerAuth"), // ✅ JWT 인증 명시
            requestBody = @io.swagger.v3.oas.annotations.parameters.RequestBody(
                    description = "업로드할 이미지 파일",
                    required = true,
                    content = @Content(
                            mediaType = MediaType.MULTIPART_FORM_DATA_VALUE,
                            schema = @Schema(type = "object"),
                            examples = @ExampleObject(
                                    name = "Form Data 예시",
                                    value = "image: (파일 선택)"
                            )
                    )
            ),
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "업로드 성공",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = CommonResponse.class),
                                    examples = @ExampleObject(
                                            name = "업로드 성공 예시",
                                            value = "{\n" +
                                                    "  \"success\": true,\n" +
                                                    "  \"message\": \"이미지 업로드 성공\",\n" +
                                                    "  \"data\": {\n" +
                                                    "    \"url\": \"/api/gallery/images/uuid_filename.jpg\"\n" +
                                                    "  }\n" +
                                                    "}"
                                    )
                            )
                    ),
                    @ApiResponse(
                            responseCode = "400",
                            description = "파일이 비어 있음",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = CommonResponse.class),
                                    examples = @ExampleObject(
                                            name = "파일 없음 예시",
                                            value = "{\n" +
                                                    "  \"success\": false,\n" +
                                                    "  \"message\": \"파일이 없습니다.\",\n" +
                                                    "  \"data\": null\n" +
                                                    "}"
                                    )
                            )
                    ),
                    @ApiResponse(
                            responseCode = "500",
                            description = "서버 내부 오류",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = CommonResponse.class),
                                    examples = @ExampleObject(
                                            name = "서버 오류 예시",
                                            value = "{\n" +
                                                    "  \"success\": false,\n" +
                                                    "  \"message\": \"서버 내부 오류가 발생했습니다.\",\n" +
                                                    "  \"data\": null\n" +
                                                    "}"
                                    )
                            )
                    )
            }
    )
    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<CommonResponse<UploadImageResponse>> uploadImage(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @Parameter(description = "업로드할 이미지 파일", required = true)
            @RequestParam("image") MultipartFile file) {

        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body(
                    CommonResponse.<UploadImageResponse>builder()
                            .success(false)
                            .message("파일이 없습니다.")
                            .data(null)
                            .build()
            );
        }

        try {
            String originalFilename = file.getOriginalFilename();
            String extension = "";

            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }

            String fileName = UUID.randomUUID().toString() + extension;

            Path filePath = Paths.get(uploadDir, fileName);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            String imageUrl = "/api/gallery/images/" + fileName;

            Long userId = userDetails.getUser().getId();
            imagePathCache.storeImagePath(userId, imageUrl);

            return ResponseEntity.ok(
                    CommonResponse.<UploadImageResponse>builder()
                            .success(true)
                            .message("이미지 업로드 성공")
                            .data(new UploadImageResponse(imageUrl))
                            .build()
            );

        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                    CommonResponse.<UploadImageResponse>builder()
                            .success(false)
                            .message("파일 업로드 실패")
                            .data(null)
                            .build()
            );
        }
    }


    @Operation(
            summary = "이미지 조회",
            description = """
업로드된 이미지를 조회합니다.

- `Content-Type`: 필요 없음
- `Authorization`: Bearer {Token}
""",
            security = @SecurityRequirement(name = "bearerAuth"),
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "이미지 반환 성공 (바이너리 형식)",
                            content = @Content(mediaType = "image/jpeg")
                    ),
                    @ApiResponse(
                            responseCode = "404",
                            description = "파일을 찾을 수 없음",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = CommonResponse.class),
                                    examples = @ExampleObject(
                                            name = "파일 없음 예시",
                                            value = "{\n" +
                                                    "  \"success\": false,\n" +
                                                    "  \"message\": \"이미지를 찾을 수 없습니다.\",\n" +
                                                    "  \"data\": null\n" +
                                                    "}"
                                    )
                            )
                    ),
                    @ApiResponse(
                            responseCode = "500",
                            description = "서버 내부 오류",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = CommonResponse.class),
                                    examples = @ExampleObject(
                                            name = "서버 오류 예시",
                                            value = "{\n" +
                                                    "  \"success\": false,\n" +
                                                    "  \"message\": \"서버 내부 오류가 발생했습니다.\",\n" +
                                                    "  \"data\": null\n" +
                                                    "}"
                                    )
                            )
                    ),
                    @ApiResponse(
                            responseCode = "413",
                            description = "파일 크기 초과",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = CommonResponse.class),
                                    examples = @ExampleObject(
                                            name = "파일 크기 초과 예시",
                                            value = "{\n" +
                                                    "  \"success\": false,\n" +
                                                    "  \"message\": \"업로드 가능한 최대 파일 크기는 5MB입니다.\",\n" +
                                                    "  \"data\": null\n" +
                                                    "}"
                                    )
                            )
                    )
            }
    )
    @GetMapping("/images/{fileName}")
    public ResponseEntity<?> getImage(
            @Parameter(description = "조회할 이미지 파일명", required = true)
            @PathVariable String fileName) {
        try {
            Path filePath = Paths.get(uploadDir).resolve(fileName).normalize();
            Resource resource = new UrlResource(filePath.toUri());

            if (!resource.exists() || !resource.isReadable()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                        CommonResponse.builder()
                                .success(false)
                                .message("이미지를 찾을 수 없습니다.")
                                .data(null)
                                .build()
                );
            }

            String contentType = Files.probeContentType(filePath);
            if (contentType == null) {
                contentType = "application/octet-stream";
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(resource);

        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                    CommonResponse.builder()
                            .success(false)
                            .message("이미지 로드 중 서버 오류가 발생했습니다.")
                            .data(null)
                            .build()
            );
        }
    }
}
