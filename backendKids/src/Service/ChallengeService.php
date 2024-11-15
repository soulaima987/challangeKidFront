<?php

namespace App\Service;

use App\Entity\Challenge;
use App\Entity\Chapter;
use Doctrine\ORM\EntityManagerInterface;

class ChallengeService
{
    private $categoryService;
    private $chapterService;
    private $entityManager;

    function __construct(CategoryService $categoryService, ChapterService $chapterService, EntityManagerInterface $entityManager)
    {
        $this->categoryService = $categoryService;
        $this->chapterService = $chapterService;
        $this->entityManager = $entityManager;
    }
    public function challengeToJson(Challenge $challenge)
    {
        $categories = $challenge->getCategories()->toArray();
        $coach = $challenge->getCoach();
        $chapters = $challenge->getChapters()->toArray();
        return [
            'id' => $challenge->getId(),
            'title' => $challenge->getTitle(),
            'description' => $challenge->getDescription(),
            'category' => $challenge->getCategories(),
            'imageFileName' => $challenge->getImageFileName(),
            'kid' => $challenge->getKid(),
            'coach' => $coach->getId(),
            'categories' => array_map(function ($category) {
                return $this->categoryService->categoryToJson($category);
            }, $categories),
            'chapters' => array_map(function ($chapter) {
                return $this->chapterService->chapterToJson($chapter);
            }, $chapters)
        ];
    }

    public function addChapters($challenge, array $chapterTitles)
    {
        foreach ($chapterTitles as $chapterTitle) {
            $chapter = $this->entityManager->getRepository(Chapter::class)->findOneBy(['title' => $chapterTitle]);
            $challenge->addChapter($chapter);
        }
        $this->entityManager->persist($chapter);
        $this->entityManager->flush();
    }
}
