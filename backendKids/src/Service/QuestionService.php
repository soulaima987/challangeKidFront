<?php

namespace App\Service;

use App\Entity\Question;

class QuestionService
{
    private $optionService;
    public function __construct(OptionService $optionService)
    {
        $this->optionService = $optionService;
    }

    public function questionToJson(Question $question)
    {
        $options = $question->getOptions()->toArray();

        return [
            'id' => $question->getId(),
            'questionNumber' => $question->getQuestionNumber(),
            'type' => $question->getType(),
            'options' => array_map(function ($option) {
                return $this->optionService->optionToJson($option);
            }, $options),
        ];
    }
}
