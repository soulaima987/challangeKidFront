<?php

namespace App\Service;

use App\Entity\Quiz;

class QuizService
{
    private $questionService;

    public function __construct(QuestionService $questionService)
    {
        $this->questionService = $questionService;
    }

    public function quizToJson(Quiz $quiz)
    {
        $responses = $quiz->getResponses()->toArray();
        $questions = $quiz->getQuestions()->toArray();

        return [
            'id' => $quiz->getId(),
            'lesson' => $quiz->getLesson(),
            'responses' => $responses,
            'questions' => array_map(function ($question) {
                return $this->questionService->questionToJson($question);
            }, $questions)
        ];
    }
}
