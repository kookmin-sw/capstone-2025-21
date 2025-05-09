//package com.capstone.allergy.exception;
//
//import com.capstone.allergy.dto.CommonResponse;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.ControllerAdvice;
//import org.springframework.web.bind.annotation.ExceptionHandler;
//import org.springframework.web.multipart.MaxUploadSizeExceededException;
//
//@ControllerAdvice
//public class GlobalExceptionHandler {
//
//    /**
//     * 5MB 초과 업로드 예외 처리
//     */
//    @ExceptionHandler(MaxUploadSizeExceededException.class)
//    public ResponseEntity<CommonResponse<Object>> handleMaxUploadSize(MaxUploadSizeExceededException e) {
//        return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE).body(
//                CommonResponse.builder()
//                        .success(false)
//                        .message("업로드 가능한 최대 파일 크기는 5MB입니다.")
//                        .data(null)
//                        .build()
//        );
//    }
//
//    /**
//     * 일반적인 예외 처리 (옵션)
//     */
//    @ExceptionHandler(Exception.class)
//    public ResponseEntity<CommonResponse<Object>> handleGenericException(Exception e) {
//        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
//                CommonResponse.builder()
//                        .success(false)
//                        .message("서버 내부 오류가 발생했습니다.")
//                        .data(null)
//                        .build()
//        );
//    }
//}
