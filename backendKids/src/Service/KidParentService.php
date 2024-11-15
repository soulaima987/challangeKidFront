<?php

namespace App\Service;

use App\Entity\KidParent;

class KidParentService
{
    public function kidParentToJson(KidParent $kidParent)
    {
        return [
            'id' => $kidParent->getId(),
            'firstName' => $kidParent->getFirstName(),
            'secondName' => $kidParent->getSecondName(),
            'email' => $kidParent->getEmail(),
            'registrationDate' => $kidParent->getRegistrationDate()->format('Y-m-d H:i:s'),
            'birthDate' => $kidParent->getBirthDate()->format('Y-m-d'),
            'kid' => $kidParent->getKid(),
        ];
    }
}
