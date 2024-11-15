<?php

namespace App\Service;

use App\Entity\Option;

class OptionService
{
    public function optionToJson(Option $option)
    {
        return [
            'id' => $option->getId(),
            'question' => $option->getQuestion(),
            'type' => $option->isType(),
            'response' => $option->getResponse(),
            'content' => $option->getContent(),
        ];
    }
}
