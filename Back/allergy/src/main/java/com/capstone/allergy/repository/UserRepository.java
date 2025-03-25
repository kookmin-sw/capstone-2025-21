package com.capstone.allergy.repository;

import com.capstone.allergy.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    boolean existsByUsername(String username);
    Optional<User> findByUsername(String username);
}
//아이디 중복 검사, 로그인용 사용자 조회에 활용