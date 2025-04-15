package com.capstone.allergy.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;


import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Collections;
import java.util.Map;
import java.util.UUID;
import java.io.File;
import java.io.IOException;



@RestController
@RequestMapping("/api/gallery")
@Tag(name = "이미지 업로드", description = "이미지 업로드 및 조회 API")
public class ImageController {

    private final String uploadDir;

    public ImageController(@Value("${file.upload-dir}") String uploadDir) {
        this.uploadDir = uploadDir;
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs(); // 업로드 폴더가 없으면 생성
        }
    }

    @Operation(
            summary = "이미지 업로드",
            description = "이미지를 업로드하고 해당 이미지의 조회 URL을 반환합니다.",
            responses = {
                    @ApiResponse(responseCode = "200", description = "업로드 성공, 이미지 URL 반환"),
                    @ApiResponse(responseCode = "400", description = "파일이 비어 있음"),
                    @ApiResponse(responseCode = "500", description = "서버 오류로 업로드 실패")
            }
    )

    @PostMapping("/upload")
    public ResponseEntity<Map<String, String>> uploadImage(
            @Parameter(description = "업로드할 이미지 파일", required = true)
            @RequestParam("image") MultipartFile file) {
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body(Collections.singletonMap("error", "파일이 없습니다."));
        }

        try {
            // 파일명 설정 (중복 방지)
            String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();
            Path filePath = Paths.get(uploadDir, fileName);

            // 파일 저장
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            // 저장된 이미지 URL 반환
            String imageUrl = "/api/gallery/images/" + fileName;
            return ResponseEntity.ok(Collections.singletonMap("url", imageUrl));

        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.singletonMap("error", "파일 업로드 실패"));
        }
    }

    @Operation(
            summary = "이미지 조회",
            description = "파일명을 통해 이미지를 반환합니다.",
            responses = {
                    @ApiResponse(responseCode = "200", description = "이미지 반환"),
                    @ApiResponse(responseCode = "400", description = "이미지 없음"),
                    @ApiResponse(responseCode = "500", description = "서버 오류")
            }
    )

    @GetMapping("/images/{fileName}")
    public ResponseEntity<Resource> getImage(
            @Parameter(description = "조회할 이미지 파일명", required = true)
            @PathVariable String fileName) {
        try {
            Path filePath = Paths.get(uploadDir).resolve(fileName).normalize();
            Resource resource = new UrlResource(filePath.toUri());

            if (!resource.exists() || !resource.isReadable()) {
                return ResponseEntity.notFound().build();
            }

            // 파일 확장자를 확인하여 적절한 MIME 타입 설정
            String contentType = Files.probeContentType(filePath);
            if (contentType == null) {
                contentType = "application/octet-stream"; // 기본값 설정
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(resource);
        } catch (MalformedURLException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
}
