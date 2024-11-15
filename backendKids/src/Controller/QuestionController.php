<?php

namespace App\Controller;

use App\Entity\Question;
use App\Entity\Quiz;
use App\Form\QuestionType;
use App\Repository\QuestionRepository;
use App\Service\QuestionService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use OpenApi\Attributes as OA;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

#[Route('/api/question')]
#[OA\Tag(name: 'Question')]
class QuestionController extends AbstractController
{
    private $questionService;

    public function __construct(QuestionService $questionService)
    {
        $this->questionService = $questionService;
    }

    #[Route('/{quiz}', name: 'question_index', methods: ['GET'])]
    public function index(Quiz $quiz, QuestionRepository $questionRepository): JsonResponse
    {
        $listJson = [];
        $list = $questionRepository->findBy(["quiz" => $quiz]);
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->questionService->questionToJson($value);
        }
        return new JsonResponse($listJson);
    }

    #[Route('/{quiz}/new', name: 'question_new', methods: ['POST'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "questionNumber" => 1,
                "type" => "multi answer",
                "question" => "teeeeeeeeeest",
            ]
        )
    )]
    public function new(Quiz $quiz, Request $request, EntityManagerInterface $entityManager): Response
    {
        $data = json_decode($request->getContent(), true);

        $question = new Question();
        $form = $this->createForm(QuestionType::class, $question);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $question->setQuiz($quiz);
            $entityManager->persist($question);
            $entityManager->flush();
        }

        return new JsonResponse(true);
    }

    #[Route('/{id}', name: 'question_show', methods: ['GET'])]
    public function show($id, QuestionRepository $questionRepository): Response
    {
        $question = $questionRepository->find($id);
        $question = $this->questionService->questionToJson($question);
        return new JsonResponse($question);
    }

    #[Route('/{id}/edit', name: 'question_edit', methods: ['PUT'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "questionNumber" => 1,
                "type" => "multi answer",
                "question" => "teeeeeeeeeest"
            ]
        )
    )]
    public function edit($id, Request $request, QuestionRepository $questionRepository, EntityManagerInterface $entityManager): Response
    {
        $question = $questionRepository->find($id);

        $data = json_decode($request->getContent(), true);
        $form = $this->createForm(QuestionType::class, $question);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $entityManager->persist($question);
            $entityManager->flush();

            return new JsonResponse(['status' => 'question updated successfully']);
        }

        return new JsonResponse(['error' => 'An error has occured']);
    }

    #[Route('/delete/{id}', name: 'question_delete', methods: ['DELETE'])]
    public function delete($id, QuestionRepository $questionRepository, EntityManagerInterface $entityManager): Response
    {
        $question = $questionRepository->find($id);
        if (!$question) {
            throw new NotFoundHttpException('Question not found');
        }

        $entityManager->remove($question);
        $entityManager->flush();

        return new JsonResponse(['status' => 'The Question has been deleted']);
    }
}
