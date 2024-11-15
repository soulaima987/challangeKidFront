<?php

namespace App\Service;

use App\Entity\Lesson;
class LessonService{
    
    private $postService;

    public function __construct(PostService $postService)
    {
        $this->postService = $postService;
    }
public function lessonToJson(Lesson $lesson)
    {
        $post=$lesson->getPost();
        return [
            'id' => $lesson->getId(),
            'title' => $lesson->getTitle(),
            'description' => $lesson->getDescription(),
            'lessonNumber' => $lesson->getLessonNumber(),
            'chapter' => $lesson->getChapter(),
            'category' => $lesson->getCategories(),
            'post' => $post ? $this->postService->postToJson($post) : null,
            'quiz' => $lesson->getQuiz()];
        }

        
    }
