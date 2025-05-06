package com.capstone.allergy.cache;

import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ImagePathCache {

    private final Map<Long, String> imagePathMap = new ConcurrentHashMap<>();

    public void storeImagePath(Long userId, String imagePath) {
        imagePathMap.put(userId, imagePath);
    }

    public String getLatestImagePath(Long userId) {
        return imagePathMap.get(userId);
    }

    public void removeImagePath(Long userId) {
        imagePathMap.remove(userId);
    }

    public boolean hasImagePath(Long userId) {
        return imagePathMap.containsKey(userId);
    }
}
