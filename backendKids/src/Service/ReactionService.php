<?php

namespace App\Service;

use App\Entity\Post;
use App\Entity\Reaction;
use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;

class ReactionService
{
    public function serialize(Reaction $reaction)
    {
        return [
            'type' => $reaction->getType()
        ];
    }

    private $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    public function addReaction(Post $post, User $user, string $reactionType): JsonResponse
    {

        $reaction = new Reaction();
        $reaction->setType($reactionType);
        $reaction->setPost($post);
        $reaction->setUser($user);

        $post->addReaction($reaction);

        $user->addReaction($reaction);

        $this->entityManager->persist($reaction);
        $this->entityManager->persist($post);
        $this->entityManager->persist($user);
        $this->entityManager->flush();
        return new JsonResponse('You reacted to the post');
    }
}
