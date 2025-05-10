package com.capstone.allergy.scheduler;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.File;

@Slf4j
@Component
public class UploadCleanerScheduler {

    @Value("${file.upload-dir}")
    private String uploadDir;

    // 하루에 한 번 (24시간마다 실행)
    @Scheduled(fixedRate = 24 * 60 * 60 * 1000) // 단위: 밀리초
    public void deleteOldImages() {
        File folder = new File(uploadDir);
        File[] files = folder.listFiles();

        if (files == null || files.length == 0) {
            log.info("The uploads folder is empty or does not exist: {}", uploadDir);
            return;
        }

        long now = System.currentTimeMillis();
        int deletedCount = 0;

        for (File file : files) {
            if (now - file.lastModified() > 24 * 60 * 60 * 1000) { // 24시간 초과
                if (file.delete()) {
                    log.info("Deleted file: {}", file.getName());
                    deletedCount++;
                }
            }
        }

        log.info("Upload cleanup completed - Total files deleted: {}", deletedCount);
    }
}
