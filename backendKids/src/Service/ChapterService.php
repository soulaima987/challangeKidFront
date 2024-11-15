<?php

namespace App\Service;

use App\Entity\Chapter;
use App\Entity\Lesson;
use Doctrine\ORM\EntityManagerInterface;

class ChapterService
{
    private $entityManager;
    private $lessonService;

    function __construct(EntityManagerInterface $entityManager, LessonService $lessonService)
    {
        $this->entityManager = $entityManager;
        $this->lessonService = $lessonService;
    }

    public function chapterToJson(Chapter $chapter)
    {
        $lessons = $chapter->getLessons()->toArray();
        return [
            'id' => $chapter->getId(),
            'title' => $chapter->getTitle(),
            'description' => $chapter->getDescription(),
            'chapterNumber' => $chapter->getChapterNumber(),
            'challenge' => $chapter->getChallenge(),
            'category' => $chapter->getCategories(),
            'lessons' => array_map(function ($lesson) {
                return $this->lessonService->lessonToJson($lesson);
            }, $lessons)
        ];
    }

    public function addLessons($chapter, array $lessonTitles)
    {
        foreach ($lessonTitles as $lessonTitle) {
            $lesson = $this->entityManager->getRepository(Lesson::class)->findOneBy(['title' => $lessonTitle]);
            $chapter->addLesson($lesson);
        }
        $this->entityManager->persist($chapter);
        $this->entityManager->flush();
    }
}
