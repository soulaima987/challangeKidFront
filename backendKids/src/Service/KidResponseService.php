<?php

namespace App\Service;

use App\Entity\KidResponse;

class KidResponseService
{
    public function kidResponseToJson(KidResponse $kidResponse)
    {
        return [
            'id' => $kidResponse->getId(),
            'quiz' => $kidResponse->getQuiz(),
            'kid' => $kidResponse->getKid(),
            'optionResponse' => $kidResponse->getOptionResponse(),
        ];
    }
}
