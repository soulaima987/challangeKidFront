<?php

namespace App\Service;

use App\Entity\Category;
use App\Entity\Challenge;
use App\Entity\Kid;
use App\Entity\Post;
use App\Entity\User;
use App\Repository\ChallengeRepository;
use Doctrine\ORM\EntityManagerInterface;
use Exception;
use phpDocumentor\Reflection\Types\Integer;

class KidService
{
    private $entityManager;
    private $categoryService;

    public function __construct(EntityManagerInterface $entityManager = null, CategoryService $categoryService = null)
    {
        $this->entityManager = $entityManager;
        $this->categoryService = $categoryService;
    }

    public function kidToJson(Kid $kid)
    {
        $challenges = $kid->getChallenges()->toArray();
        $responses = $kid->getResponses()->toArray();
        $categories = $kid->getInterests()->toArray();

        return [
            'id' => $kid->getId(),
            'fullName' => $kid->getFullName(),
            'email' => $kid->getEmail(),
            'registrationDate' => $kid->getRegistrationDate()->format('Y-m-d H:i:s'),
            'interests' => array_map(function ($category) {
                return $this->categoryService->categoryToJson($category);
            }, $categories),
            'friends' => $kid->getFriends(),
            'points' => $kid->getPoints(),
            'level' => $kid->getLevel(),
            'challenges' => $challenges,
            'responses' => $responses,
        ];
    }

    public function serializeFriendData(User $friendData)
    {
        return [
            'fullName' => $friendData->getFullName(),
            'email' => $friendData->getEmail(),
        ];
    }

    public function updateCategories(int $kidId, array $categoryTitles)
    {
        $kid = $this->entityManager->getRepository(Kid::class)->find($kidId);
        if (!$kidId) {
            throw new Exception("kid not found");
        }

        foreach ($categoryTitles as $categoryTitle) {
            $category = $this->entityManager->getRepository(Category::class)->findOneBy(['title' => $categoryTitle]);
            $kid->addInterest($category);
        }
        $this->entityManager->persist($kid);
        $this->entityManager->flush();
    }

    public function scoreChallenge(Kid $kid, Challenge $challenge): int
    {
        $score = 0;

        // get interests titles from the kid
        $interests = array_map(fn($category) => $category->getTitle(), $kid->getInterests()->toArray());

        // get category titles from the challenge
        $categories = array_map(fn($category) => $category->getTitle(), $challenge->getCategories()->toArray());

        foreach ($categories as $category) {
            if (in_array($category, $interests))
                $score++;
        }

        return $score;
    }

    public function scorePost(Kid $kid, Post $post): int
    {
        $score = 0;

        // get interests titles from the kid
        $interests = array_map(fn($category) => $category->getTitle(), $kid->getInterests()->toArray());

        // get category titles from the post
        $categories = array_map(fn($category) => $category->getTitle(), $post->getCategories()->toArray());

        foreach ($categories as $category) {
            if (in_array($category, $interests))
                $score++;
        }

        return $score;
    }

    public function getChallengesForKid(int $kidId, int $limit = 10): array
    {
        $kid = $this->entityManager->getRepository(Kid::class)->find($kidId);
        if (!$kid) {
            throw new Exception("kid not found");
        }

        $challenges = $this->entityManager->getRepository(Challenge::class)->findAll();

        $scores = [];
        foreach ($challenges as $challenge) {
            $score = $this->scoreChallenge($kid, $challenge);
            $scores[$score][] = $challenge;
        }

        krsort($scores);

        $flattenedChallenges = [];
        foreach ($scores as $challengeArray) {
            foreach ($challengeArray as $challenge) {
                $flattenedChallenges[] = $challenge;
            }
        }

        return array_slice($flattenedChallenges, 0, $limit);
    }

    public function getPostsForKid(int $kidId, int $limit = 10): array
    {
        $kid = $this->entityManager->getRepository(Kid::class)->find($kidId);
        if (!$kid) {
            throw new Exception("kid not found");
        }

        $posts = $this->entityManager->getRepository(Post::class)->findAll();

        $scores = [];
        foreach ($posts as $post) {
            $score = $this->scorePost($kid, $post);
            $scores[$score][] = $post;
        }

        krsort($scores);

        $flattenedPosts = [];
        foreach ($scores as $postArray) {
            foreach ($postArray as $post) {
                $flattenedPosts[] = $post;
            }
        }

        return array_slice($flattenedPosts, 0, $limit);
    }

    public function getFriends(int $kidId): array
    {
        $kid = $this->entityManager->getRepository(Kid::class)->find($kidId);
        if (!$kid) {
            throw new Exception("kid not found");
        }

        $friends = $kid->getFriends();

        return $friends;
    }
}
