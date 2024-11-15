<?php

namespace App\Service;

use App\Entity\User;

class UserService
{
    public function userToJson(User $user)
    {
        $posts = $user->getPosts()->toArray();

        return [
            'id' => $user->getId(),
            'fullName' => $user->getFullName(),
            'email' => $user->getEmail(),
            
        ];
    }
}
